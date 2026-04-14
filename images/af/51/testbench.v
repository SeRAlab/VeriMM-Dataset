`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] currentState;
    wire [1:0] nextState;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .currentState(currentState),
        .nextState(nextState)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            currentState = RED;


            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Red (10 cycles) -> Green", test_num);
            reset_dut();

            repeat(9) @(posedge clk) currentState = nextState;

            @(posedge clk);
            #1;
            #1;

            check_outputs(GREEN);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Green (5 cycles) -> Yellow", test_num);
            reset_dut();

            repeat(10) @(posedge clk) currentState = nextState;

            repeat(4) @(posedge clk) currentState = nextState;

            @(posedge clk);
            #1;
            #1;

            check_outputs(YELLOW);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Yellow (2 cycles) -> Red", test_num);
            reset_dut();

            repeat(15) @(posedge clk) currentState = nextState;

            repeat(1) @(posedge clk) currentState = nextState;

            @(posedge clk);
            #1;
            #1;

            check_outputs(RED);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Red mid-sequence check (cycle 5)", test_num);
            reset_dut();
            repeat(4) @(posedge clk) currentState = nextState;
            @(posedge clk);
            #1;
            #1;

            check_outputs(RED);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Green mid-sequence check (cycle 3)", test_num);
            reset_dut();
            repeat(10) @(posedge clk) currentState = nextState;
            repeat(2) @(posedge clk) currentState = nextState;
            @(posedge clk);
            #1;
            #1;

            check_outputs(GREEN);
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
        input [1:0] expected_nextState;
        begin
            if (expected_nextState === (expected_nextState ^ nextState ^ expected_nextState)) begin
                $display("PASS");
                $display("  Outputs: nextState=%h",
                         nextState);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nextState=%h",
                         expected_nextState);
                $display("  Got:      nextState=%h",
                         nextState);
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
        $dumpvars(0,clk, currentState, nextState);
    end

endmodule
