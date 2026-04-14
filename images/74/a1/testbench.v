`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    wire [31:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Matching Input (0001_0001)", test_num);
            a = 32'h0001_0001;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Upper 16 match, lower 16 mismatch", test_num);
            a = 32'h0001_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Upper 16 mismatch, lower 16 match", test_num);
            a = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both mismatch (zeros)", test_num);
            a = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both mismatch (all ones)", test_num);
            a = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Upper 16 correct, lower 16 high bit set", test_num);
            a = 32'h0001_8001;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Upper 16 high bit set, lower 16 correct", test_num);
            a = 32'h8001_0001;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random non-matching value", test_num);
            a = 32'h1234_5678;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%h",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h",
                         expected_b);
                $display("  Got:      b=%h",
                         b);
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
