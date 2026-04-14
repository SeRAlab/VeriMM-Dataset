`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg clr_n_in;
    reg cnt_ena_in;
    reg load_nanosec_in;
    reg load_sec_in;
    reg [31:0] nanosec_data_in;
    reg pps_bypass_in;
    reg pps_in;
    reg [63:0] sec_data_in;
    wire [31:0] nanosec_data_out;
    wire [63:0] sec_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .clr_n_in(clr_n_in),
        .cnt_ena_in(cnt_ena_in),
        .load_nanosec_in(load_nanosec_in),
        .load_sec_in(load_sec_in),
        .nanosec_data_in(nanosec_data_in),
        .pps_bypass_in(pps_bypass_in),
        .pps_in(pps_in),
        .sec_data_in(sec_data_in),
        .nanosec_data_out(nanosec_data_out),
        .sec_data_out(sec_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            clr_n_in = 0;
            cnt_ena_in = 0;
            load_nanosec_in = 0;
            load_sec_in = 0;
            nanosec_data_in = 0;
            pps_bypass_in = 0;
            pps_in = 0;
            sec_data_in = 0;
            repeat(2) @(posedge clk_in);
            #1 clr_n_in = 1;
            repeat(1) @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk_in);
            sec_data_in = 64'hFEDCBA9876543210;
            nanosec_data_in = 32'hABCDEF01;
            load_sec_in = 1;
            load_nanosec_in = 1;
            @(posedge clk_in);
            load_sec_in = 0;
            load_nanosec_in = 0;
            #1;

            check_outputs(32'hABCDEF01, 64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk_in);
            cnt_ena_in = 1;
            repeat(10) @(posedge clk_in);
            cnt_ena_in = 0;

            #1;


            check_outputs(32'd10, 64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk_in);

            repeat(3) begin
                pps_in = 1;
                @(posedge clk_in);
                pps_in = 0;
                @(posedge clk_in);
            end
            #1;

            check_outputs(32'h0, 64'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            sec_data_in = 64'd100;
            nanosec_data_in = 32'd500;
            load_sec_in = 1;
            load_nanosec_in = 1;
            @(posedge clk_in);
            load_sec_in = 0;
            load_nanosec_in = 0;


            cnt_ena_in = 1;
            repeat(5) @(posedge clk_in);
            pps_in = 1;
            @(posedge clk_in);
            pps_in = 0;
            repeat(5) @(posedge clk_in);
            cnt_ena_in = 0;



            #1;




            check_outputs(32'd511, 64'd101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            cnt_ena_in = 1;
            repeat(20) @(posedge clk_in);
            pps_bypass_in = 1;
            pps_in = 1;
            @(posedge clk_in);
            pps_in = 0;


            clr_n_in = 0;
            @(posedge clk_in);
            clr_n_in = 1;

            #1;


            check_outputs(32'h0, 64'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_nanosec_data_out;
        input [63:0] expected_sec_data_out;
        begin
            if (expected_nanosec_data_out === (expected_nanosec_data_out ^ nanosec_data_out ^ expected_nanosec_data_out) &&
                expected_sec_data_out === (expected_sec_data_out ^ sec_data_out ^ expected_sec_data_out)) begin
                $display("PASS");
                $display("  Outputs: nanosec_data_out=%h, sec_data_out=%h",
                         nanosec_data_out, sec_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nanosec_data_out=%h, sec_data_out=%h",
                         expected_nanosec_data_out, expected_sec_data_out);
                $display("  Got:      nanosec_data_out=%h, sec_data_out=%h",
                         nanosec_data_out, sec_data_out);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk_in, clr_n_in, cnt_ena_in, load_nanosec_in, load_sec_in, nanosec_data_in, pps_bypass_in, pps_in, sec_data_in, nanosec_data_out, sec_data_out);
    end

endmodule
