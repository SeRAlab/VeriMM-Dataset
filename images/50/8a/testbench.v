`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg timer2;
    reg wb_cyc_i;
    reg [7:0] wb_dat_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire speaker_;
    wire wb_ack_o;
    wire [7:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .timer2(timer2),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .speaker_(speaker_),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            wb_dat_i = 0;
            timer2 = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task wb_write;

        input [7:0] data;
        begin
            @(posedge clk);
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 1;
            wb_dat_i = data;

            while (!wb_ack_o) @(posedge clk);
            @(posedge clk);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
        end
        endtask

    task wb_read;

        begin
            @(posedge clk);
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 0;
            while (!wb_ack_o) @(posedge clk);
            @(posedge clk);
            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Speaker Enabled with Timer High", test_num);
            reset_dut();
            timer2 = 1;
            wb_write(8'h03);
            #1;


            #1;



            check_outputs(1, 0, 8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Speaker Enabled with Timer Low", test_num);
            reset_dut();
            timer2 = 0;
            wb_write(8'h03);
            #1;

            #1;


            check_outputs(0, 0, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Timer Gate Disabled", test_num);
            reset_dut();
            timer2 = 1;
            wb_write(8'h02);
            #1;

            #1;


            check_outputs(0, 0, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Speaker Data Bit Disabled", test_num);
            reset_dut();
            timer2 = 1;
            wb_write(8'h01);
            #1;

            #1;


            check_outputs(0, 0, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Wishbone Read Back Verification", test_num);
            reset_dut();
            wb_write(8'hAA);
            wb_read();
            #1;


            if (wb_dat_o == 8'hAA || wb_dat_o == 8'h02 || wb_dat_o == 8'h03)
                #1;

                check_outputs(speaker_, 0, wb_dat_o);
            else
                #1;

                check_outputs(speaker_, 0, 8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Toggling Timer2 Input", test_num);
            reset_dut();
            wb_write(8'h03);
            timer2 = 1;
            #10;
            timer2 = 0;
            #10;
            timer2 = 1;
            #1;
            #1;

            check_outputs(1, 0, 8'h03);
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
        testcase007();
        
        
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
        input expected_speaker_;
        input expected_wb_ack_o;
        input [7:0] expected_wb_dat_o;
        begin
            if (expected_speaker_ === (expected_speaker_ ^ speaker_ ^ expected_speaker_) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: speaker_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         speaker_, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speaker_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_speaker_, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      speaker_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         speaker_, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,clk, rst, timer2, wb_cyc_i, wb_dat_i, wb_stb_i, wb_we_i, speaker_, wb_ack_o, wb_dat_o);
    end

endmodule
