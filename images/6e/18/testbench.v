`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [35:0] datain;
    reg dst_rdy_i;
    reg reset;
    reg src_rdy_i;
    wire [35:0] dataout;
    wire dst_rdy_o;
    wire src_rdy_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .datain(datain),
        .dst_rdy_i(dst_rdy_i),
        .reset(reset),
        .src_rdy_i(src_rdy_i),
        .dataout(dataout),
        .dst_rdy_o(dst_rdy_o),
        .src_rdy_o(src_rdy_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            datain = 0;
            src_rdy_i = 0;
            dst_rdy_i = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(36'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            src_rdy_i = 1;
            datain = 36'hA_5555_AAAA;
            dst_rdy_i = 1;

            @(posedge clk);
            #1;
            src_rdy_i = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(36'hA_5555_AAAA, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            src_rdy_i = 1;
            datain = 36'hB_1234_5678;
            dst_rdy_i = 0;

            @(posedge clk);
            #1;
            src_rdy_i = 0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(36'hB_1234_5678, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            src_rdy_i = 1;
            datain = 36'hF_FFFF_FFFF;
            dst_rdy_i = 0;

            @(posedge clk);
            #1;
            clear = 1;
            @(posedge clk);
            #1;
            clear = 0;


            #1;



            check_outputs(36'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            dst_rdy_i = 1;
            src_rdy_i = 1;


            datain = 36'h1_1111_1111;
            @(posedge clk);


            datain = 36'h2_2222_2222;
            @(posedge clk);

            #1;
            src_rdy_i = 0;


            #1;



            check_outputs(36'h2_2222_2222, 1'b1, 1'b1);
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
        input [35:0] expected_dataout;
        input expected_dst_rdy_o;
        input expected_src_rdy_o;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_dst_rdy_o === (expected_dst_rdy_o ^ dst_rdy_o ^ expected_dst_rdy_o) &&
                expected_src_rdy_o === (expected_src_rdy_o ^ src_rdy_o ^ expected_src_rdy_o)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         dataout, dst_rdy_o, src_rdy_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         expected_dataout, expected_dst_rdy_o, expected_src_rdy_o);
                $display("  Got:      dataout=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         dataout, dst_rdy_o, src_rdy_o);
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
        $dumpvars(0,clear, clk, datain, dst_rdy_i, reset, src_rdy_i, dataout, dst_rdy_o, src_rdy_o);
    end

endmodule
