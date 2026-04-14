`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in;
    wire out_alt_pattern;
    wire out_majority_zero;
    wire out_symmetric;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_alt_pattern(out_alt_pattern),
        .out_majority_zero(out_majority_zero),
        .out_symmetric(out_symmetric)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones", test_num);
            in = 9'b111_111_111;



            #1;




            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros", test_num);
            in = 9'b000_000_000;



            #1;




            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern starting with 1", test_num);
            in = 9'b101_010_101;



            #1;




            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern starting with 0", test_num);
            in = 9'b010_101_010;



            #1;




            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority zero boundary (4 zeros)", test_num);
            in = 9'b111_110_000;



            #1;




            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority zero boundary (5 zeros)", test_num);
            in = 9'b111_100_000;



            #1;




            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symmetric but not alternating", test_num);
            in = 9'b110_010_011;



            #1;




            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symmetric and majority zero", test_num);
            in = 9'b001_010_100;



            #1;




            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Not symmetric, not alternating, no majority zero", test_num);
            in = 9'b111_111_000;



            #1;




            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Almost alternating", test_num);
            in = 9'b101_010_111;



            #1;




            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_out_alt_pattern;
        input expected_out_majority_zero;
        input expected_out_symmetric;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_alt_pattern === (expected_out_alt_pattern ^ out_alt_pattern ^ expected_out_alt_pattern) &&
                expected_out_majority_zero === (expected_out_majority_zero ^ out_majority_zero ^ expected_out_majority_zero) &&
                expected_out_symmetric === (expected_out_symmetric ^ out_symmetric ^ expected_out_symmetric)) begin
                $display("PASS");
                $display("  Outputs: out_alt_pattern=%b, out_majority_zero=%b, out_symmetric=%b",
                         out_alt_pattern, out_majority_zero, out_symmetric);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_alt_pattern=%b, out_majority_zero=%b, out_symmetric=%b",
                         expected_out_alt_pattern, expected_out_majority_zero, expected_out_symmetric);
                $display("  Got:      out_alt_pattern=%b, out_majority_zero=%b, out_symmetric=%b",
                         out_alt_pattern, out_majority_zero, out_symmetric);
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
