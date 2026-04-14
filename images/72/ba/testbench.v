`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg x;
    reg y;
    wire q;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .x(x),
        .y(y),
        .q(q),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x = 0; y = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 1; y = 0;
            @(posedge clk);
            #1;


            $display("Testcase %0d: Set State (0->1)", test_num);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 1; y = 0; @(posedge clk); #1;
            x = 0; y = 0;
            @(posedge clk);
            #1;


            $display("Testcase %0d: Hold State 1", test_num);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 1; y = 0; @(posedge clk); #1;
            x = 1; y = 1;
            @(posedge clk);
            #1;


            $display("Testcase %0d: Toggle State (1->0)", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 0; y = 0;
            @(posedge clk);
            #1;


            $display("Testcase %0d: Hold State 0", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 1; y = 1;
            @(posedge clk);
            #1;


            $display("Testcase %0d: Toggle State (0->1)", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 1; y = 0; @(posedge clk); #1;
            x = 0; y = 1;
            @(posedge clk);
            #1;


            $display("Testcase %0d: Clear State (1->0)", test_num);
            #1;

            check_outputs(0, 0);
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
        input expected_q;
        input expected_state;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: q=%b, state=%b",
                         q, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, state=%b",
                         expected_q, expected_state);
                $display("  Got:      q=%b, state=%b",
                         q, state);
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
        $dumpvars(0,clk, x, y, q, state);
    end

endmodule
