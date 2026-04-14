`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] i_value;
    reg reset;
    wire [3:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_value(i_value),
        .reset(reset),
        .value(value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [3:0] init_val;
        begin
            @(negedge clk);
            reset = 1;
            i_value = init_val;
            @(negedge clk);
            reset = 0;
            i_value = 4'h0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset to 0", test_num);
            reset_dut(4'h0);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Reset to 10 (4'hA)", test_num);
            reset_dut(4'hA);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Increment 0 to 1", test_num);
            reset_dut(4'h0);
            @(negedge clk);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Increment from 5 for 4 cycles", test_num);
            reset_dut(4'h5);
            repeat(4) @(negedge clk);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Wrap-around 15 to 0", test_num);
            reset_dut(4'hF);
            @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multi-cycle wrap-around (14 to 1)", test_num);
            reset_dut(4'hE);
            repeat(3) @(negedge clk);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Synchronous reset override mid-count", test_num);
            reset_dut(4'h0);
            repeat(2) @(negedge clk);

            @(negedge clk);
            reset = 1;
            i_value = 4'hC;
            @(negedge clk);
            reset = 0;
            #1;

            check_outputs(4'hC);
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
        input [3:0] expected_value;
        begin
            if (expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: value=%h",
                         value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value=%h",
                         expected_value);
                $display("  Got:      value=%h",
                         value);
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
        $dumpvars(0,clk, i_value, reset, value);
    end

endmodule
