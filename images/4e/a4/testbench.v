`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire f_and;
    wire f_nand;
    wire f_nor;
    wire f_not;
    wire f_or;
    wire f_xnor;
    wire f_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .f_and(f_and),
        .f_nand(f_nand),
        .f_nor(f_nor),
        .f_not(f_not),
        .f_or(f_or),
        .f_xnor(f_xnor),
        .f_xor(f_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 0;
            b = 0;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);


            #1;



            check_outputs(0, 1, 1, 1, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 0;
            b = 1;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);

            #1;


            check_outputs(0, 1, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 1;
            b = 0;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);

            #1;


            check_outputs(0, 1, 0, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 1;
            b = 1;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);

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
        input expected_f_and;
        input expected_f_nand;
        input expected_f_nor;
        input expected_f_not;
        input expected_f_or;
        input expected_f_xnor;
        input expected_f_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f_and === (expected_f_and ^ f_and ^ expected_f_and) &&
                expected_f_nand === (expected_f_nand ^ f_nand ^ expected_f_nand) &&
                expected_f_nor === (expected_f_nor ^ f_nor ^ expected_f_nor) &&
                expected_f_not === (expected_f_not ^ f_not ^ expected_f_not) &&
                expected_f_or === (expected_f_or ^ f_or ^ expected_f_or) &&
                expected_f_xnor === (expected_f_xnor ^ f_xnor ^ expected_f_xnor) &&
                expected_f_xor === (expected_f_xor ^ f_xor ^ expected_f_xor)) begin
                $display("PASS");
                $display("  Outputs: f_and=%b, f_nand=%b, f_nor=%b, f_not=%b, f_or=%b, f_xnor=%b, f_xor=%b",
                         f_and, f_nand, f_nor, f_not, f_or, f_xnor, f_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f_and=%b, f_nand=%b, f_nor=%b, f_not=%b, f_or=%b, f_xnor=%b, f_xor=%b",
                         expected_f_and, expected_f_nand, expected_f_nor, expected_f_not, expected_f_or, expected_f_xnor, expected_f_xor);
                $display("  Got:      f_and=%b, f_nand=%b, f_nor=%b, f_not=%b, f_or=%b, f_xnor=%b, f_xor=%b",
                         f_and, f_nand, f_nor, f_not, f_or, f_xnor, f_xor);
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
