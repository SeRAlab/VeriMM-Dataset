`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] nor_a;
    reg [31:0] nor_b;
    wire [31:0] result_nor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .nor_a(nor_a),
        .nor_b(nor_b),
        .result_nor(result_nor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            nor_a = 32'h00000000;
            nor_b = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            nor_a = 32'hFFFFFFFF;
            nor_b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            nor_a = 32'h55555555;
            nor_b = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Inputs", test_num);
            nor_a = 32'hFFFF0000;
            nor_b = 32'h0000FFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Property with Zeros", test_num);
            nor_a = 32'h11111111;
            nor_b = 32'h00000000;
            #1;

            check_outputs(32'hEEEEEEEE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Hex Pattern", test_num);
            nor_a = 32'h12345678;
            nor_b = 32'h87654321;
            #1;

            check_outputs(32'h688AA886);
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
        input [31:0] expected_result_nor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_nor === (expected_result_nor ^ result_nor ^ expected_result_nor)) begin
                $display("PASS");
                $display("  Outputs: result_nor=%h",
                         result_nor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_nor=%h",
                         expected_result_nor);
                $display("  Got:      result_nor=%h",
                         result_nor);
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
