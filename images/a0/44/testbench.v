`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] scancode;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .scancode(scancode),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            scancode = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task apply_scancode;

        input [15:0] code;
        begin
            @(posedge clk);
            #1 scancode = code;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Correct Full Sequence", test_num);
            reset_dut();
            apply_scancode(LEFT_CODE);
            apply_scancode(UP_CODE);
            apply_scancode(RIGHT_CODE);
            apply_scancode(DOWN_CODE);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Incomplete Sequence", test_num);
            reset_dut();
            apply_scancode(LEFT_CODE);
            apply_scancode(UP_CODE);
            apply_scancode(RIGHT_CODE);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Wrong Order Sequence", test_num);
            reset_dut();
            apply_scancode(DOWN_CODE);
            apply_scancode(RIGHT_CODE);
            apply_scancode(UP_CODE);
            apply_scancode(LEFT_CODE);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Interrupted Sequence", test_num);
            reset_dut();
            apply_scancode(LEFT_CODE);
            apply_scancode(UP_CODE);
            apply_scancode(WRONG_CODE);
            apply_scancode(RIGHT_CODE);
            apply_scancode(DOWN_CODE);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reset Mid-Sequence", test_num);
            reset_dut();
            apply_scancode(LEFT_CODE);
            apply_scancode(UP_CODE);
            reset_dut();
            apply_scancode(RIGHT_CODE);
            apply_scancode(DOWN_CODE);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Sequence then Return to IDLE", test_num);
            reset_dut();
            apply_scancode(LEFT_CODE);
            apply_scancode(UP_CODE);
            apply_scancode(RIGHT_CODE);
            apply_scancode(DOWN_CODE);
            apply_scancode(16'h0000);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_match;
        begin
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
        $dumpvars(0,clk, reset, scancode, match);
    end

endmodule
