`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    wire [7:0] o_led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .o_led(o_led)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin

            repeat(2) @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            repeat(1) @(posedge i_clk);
            #1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            repeat(4) @(posedge i_clk);
            #1;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            repeat(7) @(posedge i_clk);
            #1;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(8) @(posedge i_clk);
            #1;

            #1;


            check_outputs(8'h01);
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
        input [7:0] expected_o_led;
        begin
            if (expected_o_led === (expected_o_led ^ o_led ^ expected_o_led)) begin
                $display("PASS");
                $display("  Outputs: o_led=%h",
                         o_led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_led=%h",
                         expected_o_led);
                $display("  Got:      o_led=%h",
                         o_led);
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
        $dumpvars(0,i_clk, o_led);
    end

endmodule
