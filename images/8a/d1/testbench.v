`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire out_and;
    wire out_anotb;
    wire out_nand;
    wire out_nor;
    wire out_or;
    wire out_xnor;
    wire out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_and(out_and),
        .out_anotb(out_anotb),
        .out_nand(out_nand),
        .out_nor(out_nor),
        .out_or(out_or),
        .out_xnor(out_xnor),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=0", test_num);
            a = 0;
            b = 0;


            #1;



            check_outputs(0, 0, 1, 1, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=1", test_num);
            a = 0;
            b = 1;


            #1;



            check_outputs(0, 0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=1, b=0", test_num);
            a = 1;
            b = 0;


            #1;



            check_outputs(0, 1, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=1, b=1", test_num);
            a = 1;
            b = 1;


            #1;



            check_outputs(1, 0, 0, 0, 1, 1, 0);
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
        input expected_out_and;
        input expected_out_anotb;
        input expected_out_nand;
        input expected_out_nor;
        input expected_out_or;
        input expected_out_xnor;
        input expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_anotb === (expected_out_anotb ^ out_anotb ^ expected_out_anotb) &&
                expected_out_nand === (expected_out_nand ^ out_nand ^ expected_out_nand) &&
                expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xnor === (expected_out_xnor ^ out_xnor ^ expected_out_xnor) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%b, out_anotb=%b, out_nand=%b, out_nor=%b, out_or=%b, out_xnor=%b, out_xor=%b",
                         out_and, out_anotb, out_nand, out_nor, out_or, out_xnor, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%b, out_anotb=%b, out_nand=%b, out_nor=%b, out_or=%b, out_xnor=%b, out_xor=%b",
                         expected_out_and, expected_out_anotb, expected_out_nand, expected_out_nor, expected_out_or, expected_out_xnor, expected_out_xor);
                $display("  Got:      out_and=%b, out_anotb=%b, out_nand=%b, out_nor=%b, out_or=%b, out_xnor=%b, out_xor=%b",
                         out_and, out_anotb, out_nand, out_nor, out_or, out_xnor, out_xor);
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
