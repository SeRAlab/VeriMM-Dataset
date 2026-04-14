`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] next_state;
    wire [3:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .next_state(next_state),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset state", test_num);
            reset_dut();


            #1;



            check_outputs(4'b0010, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition S1 -> S2", test_num);
            reset_dut();
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0100, 4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition S2 -> S3", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transition S3 -> S4", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full cycle wraparound S4 -> S1", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0010, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Asynchronous reset mid-cycle", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #2;
            reset = 1;
            #3;

            #1;


            check_outputs(4'b0010, 4'b0001);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple full cycles", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0100, 4'b0010);
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
        input [3:0] expected_next_state;
        input [3:0] expected_state;
        begin
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h, state=%h",
                         next_state, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h, state=%h",
                         expected_next_state, expected_state);
                $display("  Got:      next_state=%h, state=%h",
                         next_state, state);
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
        $dumpvars(0,clk, reset, next_state, state);
    end

endmodule
