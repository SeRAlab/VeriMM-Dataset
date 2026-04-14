`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    wire o_and;
    wire o_nand;
    wire o_nor;
    wire o_or;
    wire o_xnor;
    wire o_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .o_and(o_and),
        .o_nand(o_nand),
        .o_nor(o_nor),
        .o_or(o_or),
        .o_xnor(o_xnor),
        .o_xor(o_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 8'b00000000;

            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 8'b11111111;

            #10;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 8'b00000001;

            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 8'b11111110;

            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 8'b01010101;

            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 8'b10000000;

            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 8'b00000111;

            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 8'b00110011;

            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_o_and;
        input expected_o_nand;
        input expected_o_nor;
        input expected_o_or;
        input expected_o_xnor;
        input expected_o_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_and === (expected_o_and ^ o_and ^ expected_o_and) &&
                expected_o_nand === (expected_o_nand ^ o_nand ^ expected_o_nand) &&
                expected_o_nor === (expected_o_nor ^ o_nor ^ expected_o_nor) &&
                expected_o_or === (expected_o_or ^ o_or ^ expected_o_or) &&
                expected_o_xnor === (expected_o_xnor ^ o_xnor ^ expected_o_xnor) &&
                expected_o_xor === (expected_o_xor ^ o_xor ^ expected_o_xor)) begin
                $display("PASS");
                $display("  Outputs: o_and=%b, o_nand=%b, o_nor=%b, o_or=%b, o_xnor=%b, o_xor=%b",
                         o_and, o_nand, o_nor, o_or, o_xnor, o_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_and=%b, o_nand=%b, o_nor=%b, o_or=%b, o_xnor=%b, o_xor=%b",
                         expected_o_and, expected_o_nand, expected_o_nor, expected_o_or, expected_o_xnor, expected_o_xor);
                $display("  Got:      o_and=%b, o_nand=%b, o_nor=%b, o_or=%b, o_xnor=%b, o_xor=%b",
                         o_and, o_nand, o_nor, o_or, o_xnor, o_xor);
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
