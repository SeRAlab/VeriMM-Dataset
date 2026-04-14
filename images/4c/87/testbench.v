`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg in1;
    reg in2;
    wire out_AND;
    wire out_NOT;
    wire out_OR;
    wire out_XNOR;
    wire out_XOR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .in1(in1),
        .in2(in2),
        .out_AND(out_AND),
        .out_NOT(out_NOT),
        .out_OR(out_OR),
        .out_XNOR(out_XNOR),
        .out_XOR(out_XOR)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 0; in2 = 0; in = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 0; in2 = 0; in = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 0; in2 = 1; in = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 0; in2 = 1; in = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 1; in2 = 0; in = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in1 = 1; in2 = 0; in = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in1 = 1; in2 = 1; in = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in1 = 1; in2 = 1; in = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_out_AND;
        input expected_out_NOT;
        input expected_out_OR;
        input expected_out_XNOR;
        input expected_out_XOR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_AND === (expected_out_AND ^ out_AND ^ expected_out_AND) &&
                expected_out_NOT === (expected_out_NOT ^ out_NOT ^ expected_out_NOT) &&
                expected_out_OR === (expected_out_OR ^ out_OR ^ expected_out_OR) &&
                expected_out_XNOR === (expected_out_XNOR ^ out_XNOR ^ expected_out_XNOR) &&
                expected_out_XOR === (expected_out_XOR ^ out_XOR ^ expected_out_XOR)) begin
                $display("PASS");
                $display("  Outputs: out_AND=%b, out_NOT=%b, out_OR=%b, out_XNOR=%b, out_XOR=%b",
                         out_AND, out_NOT, out_OR, out_XNOR, out_XOR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_AND=%b, out_NOT=%b, out_OR=%b, out_XNOR=%b, out_XOR=%b",
                         expected_out_AND, expected_out_NOT, expected_out_OR, expected_out_XNOR, expected_out_XOR);
                $display("  Got:      out_AND=%b, out_NOT=%b, out_OR=%b, out_XNOR=%b, out_XOR=%b",
                         out_AND, out_NOT, out_OR, out_XNOR, out_XOR);
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
