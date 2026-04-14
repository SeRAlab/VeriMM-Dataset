`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial state A check", test_num);
        reset = 1; x = 0; y = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transition A -> B check", test_num);
        reset = 1; x = 0; y = 0;
        @(posedge clk);
        #1 reset = 0; x = 1; y = 0;
        @(posedge clk);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transition B -> C check", test_num);
        reset = 1; x = 0; y = 0;
        @(posedge clk);
        #1 reset = 0; x = 1; y = 0;
        @(posedge clk);
        #1 x = 0; y = 1;
        @(posedge clk);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transition C -> D check", test_num);
        reset = 1; x = 0; y = 0;
        @(posedge clk);
        #1 reset = 0; x = 1; y = 0;
        @(posedge clk);
        #1 x = 0; y = 1;
        @(posedge clk);
        #1 x = 1; y = 1;
        @(posedge clk);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full Cycle D -> A check", test_num);
        reset = 1; x = 0; y = 0;
        @(posedge clk);
        #1 reset = 0; x = 1; y = 0;
        @(posedge clk);
        #1 x = 0; y = 1;
        @(posedge clk);
        #1 x = 1; y = 1;
        @(posedge clk);
        #1 x = 0; y = 0;
        @(posedge clk);
        #1;

        check_outputs(0);
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
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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

endmodule
