`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk50;
    reg stop;
    wire [63:0] key;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk50(clk50),
        .stop(stop),
        .key(key)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verifying initial generation (stop=0)", test_num);


        stop = 0;
        repeat(5) @(posedge clk50);


        #1;
        if (key !== 64'bx && key !== 64'b0) begin
            $display("  PASS: Key generated: %h", key);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Key is invalid or zero: %h", key);
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verifying stop functionality", test_num);


        stop = 0;
        repeat(5) @(posedge clk50);
        stop = 1;
        @(posedge clk50);
        captured_key = key;


        repeat(10) @(posedge clk50);


        #1;



        check_outputs(captured_key);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verifying resume from stop", test_num);


        stop = 1;
        repeat(2) @(posedge clk50);
        captured_key = key;


        stop = 0;
        repeat(5) @(posedge clk50);


        #1;
        if (key !== captured_key) begin
            $display("  PASS: Key resumed and changed from %h to %h", captured_key, key);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Key remained stuck at %h even with stop=0", captured_key);
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verifying continuous generation", test_num);

        stop = 0;
        repeat(100) @(posedge clk50);


        #1;
        if (key !== 64'bx) begin
            $display("  PASS: Key stable after 100 cycles: %h", key);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Key became undefined");
            fail_count = fail_count + 1;
        end
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
        input [63:0] expected_key;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_key === (expected_key ^ key ^ expected_key)) begin
                $display("PASS");
                $display("  Outputs: key=%h",
                         key);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key=%h",
                         expected_key);
                $display("  Got:      key=%h",
                         key);
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
