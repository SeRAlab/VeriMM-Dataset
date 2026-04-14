`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] sig;
    wire [2:0] in0;
    wire [2:0] in1;
    wire [2:0] in2;
    wire [2:0] in3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sig(sig),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sig = 3'b000;


            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sequential values 1, 2, 3, 4", test_num);
            reset_dut();
            sig = 3'd1; @(negedge clk);
            sig = 3'd2; @(negedge clk);
            sig = 3'd3; @(negedge clk);
            sig = 3'd4; @(negedge clk);
            #1;

            check_outputs(3'd1, 3'd2, 3'd3, 3'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: High values 7, 6, 5, 4", test_num);
            reset_dut();
            sig = 3'd7; @(negedge clk);
            sig = 3'd6; @(negedge clk);
            sig = 3'd5; @(negedge clk);
            sig = 3'd4; @(negedge clk);
            #1;

            check_outputs(3'd7, 3'd6, 3'd5, 3'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating values 0 and 7", test_num);
            reset_dut();
            sig = 3'd0; @(negedge clk);
            sig = 3'd7; @(negedge clk);
            sig = 3'd0; @(negedge clk);
            sig = 3'd7; @(negedge clk);
            #1;

            check_outputs(3'd0, 3'd7, 3'd0, 3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Consistent single value 5", test_num);
            reset_dut();
            sig = 3'd5; @(negedge clk);
            sig = 3'd5; @(negedge clk);
            sig = 3'd5; @(negedge clk);
            sig = 3'd5; @(negedge clk);
            #1;

            check_outputs(3'd5, 3'd5, 3'd5, 3'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mixed pattern 2, 4, 1, 6", test_num);
            reset_dut();
            sig = 3'd2; @(negedge clk);
            sig = 3'd4; @(negedge clk);
            sig = 3'd1; @(negedge clk);
            sig = 3'd6; @(negedge clk);
            #1;

            check_outputs(3'd2, 3'd4, 3'd1, 3'd6);
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
        input [2:0] expected_in0;
        input [2:0] expected_in1;
        input [2:0] expected_in2;
        input [2:0] expected_in3;
        begin
            if (expected_in0 === (expected_in0 ^ in0 ^ expected_in0) &&
                expected_in1 === (expected_in1 ^ in1 ^ expected_in1) &&
                expected_in2 === (expected_in2 ^ in2 ^ expected_in2) &&
                expected_in3 === (expected_in3 ^ in3 ^ expected_in3)) begin
                $display("PASS");
                $display("  Outputs: in0=%h, in1=%h, in2=%h, in3=%h",
                         in0, in1, in2, in3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in0=%h, in1=%h, in2=%h, in3=%h",
                         expected_in0, expected_in1, expected_in2, expected_in3);
                $display("  Got:      in0=%h, in1=%h, in2=%h, in3=%h",
                         in0, in1, in2, in3);
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
        $dumpvars(0,clk, sig, in0, in1, in2, in3);
    end

endmodule
