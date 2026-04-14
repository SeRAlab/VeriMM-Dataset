`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg start;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .start(start),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Positive / Positive (100 / 5)", test_num);
        A = 32'sd100; B = 32'sd5; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(32'sd20);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Positive / Negative (100 / -5)", test_num);
        A = 32'sd100; B = -32'sd5; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(-32'sd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Negative / Positive (-100 / 5)", test_num);
        A = -32'sd100; B = 32'sd5; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(-32'sd20);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Negative / Negative (-100 / -5)", test_num);
        A = -32'sd100; B = -32'sd5; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(32'sd20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Zero Dividend (0 / 50)", test_num);
        A = 32'sd0; B = 32'sd50; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Large Numbers (2000000 / 1000)", test_num);
        A = 32'sd2000000; B = 32'sd1000; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(32'sd2000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Truncation Check (7 / 3)", test_num);
        A = 32'sd7; B = 32'sd3; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(32'sd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Negative Truncation (-7 / 3)", test_num);
        A = -32'sd7; B = 32'sd3; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(-32'sd2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Small Dividend (5 / 10)", test_num);
        A = 32'sd5; B = 32'sd10; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Max Negative Value (-2147483648 / 2)", test_num);
        A = 32'sh8000_0000; B = 32'sd2; start = 1'b1;
        #20;
        start = 1'b0;
        #1;

        check_outputs(-32'sd1073741824);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
