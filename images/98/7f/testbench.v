`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [49:0] in;
    wire majority_out;
    wire out_and;
    wire out_or;
    wire out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .majority_out(majority_out),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            in = 50'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            in = {50{1'b1}};

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exactly 25 ones (Threshold low)", test_num);
            in = {25{1'b1}};

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exactly 26 ones (Threshold high)", test_num);
            in = {{24{1'b0}}, {26{1'b1}}};

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set", test_num);
            in = 50'h0000000000001;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Almost all bits set (49 bits)", test_num);
            in = ~50'h1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern", test_num);
            in = 50'hAAAAAAAAAAAAAAAAA;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_majority_out;
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_majority_out === (expected_majority_out ^ majority_out ^ expected_majority_out) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         majority_out, out_and, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         expected_majority_out, expected_out_and, expected_out_or, expected_out_xor);
                $display("  Got:      majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         majority_out, out_and, out_or, out_xor);
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
