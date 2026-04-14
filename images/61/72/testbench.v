`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg e;
    reg f;
    wire g;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .e(e),
        .f(f),
        .g(g),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            e = 1;
            f = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            e = 1;
            f = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: State 1 maintains 1 with e=1, f=0", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            e = 0;
            f = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: State 1 maintains 1 with e=0, f=1", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            e = 0;
            f = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: State 1 moves to 0 with e=0, f=0", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            e = 0; f = 0;
            @(posedge clk);
            #1;

            e = 1; f = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: State 0 moves to 1 with e=1, f=1", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            e = 0; f = 0;
            @(posedge clk);
            #1;

            e = 1; f = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: State 0 stays 0 with e=1, f=0", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            e = 0; f = 0;
            @(posedge clk);
            #1;

            e = 0; f = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: State 0 stays 0 with e=0, f=1", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_g;
        input expected_state;
        begin
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: g=%b, state=%b",
                         g, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%b, state=%b",
                         expected_g, expected_state);
                $display("  Got:      g=%b, state=%b",
                         g, state);
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
        $dumpvars(0,clk, e, f, g, state);
    end

endmodule
