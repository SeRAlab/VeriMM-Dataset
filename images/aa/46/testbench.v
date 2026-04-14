`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (10 + 20)", test_num);
            a = 8'd10;
            b = 8'd20;
            op = 2'b00;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (255 + 1)", test_num);
            a = 8'hFF;
            b = 8'h01;
            op = 2'b00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (100 - 40)", test_num);
            a = 8'd100;
            b = 8'd40;
            op = 2'b01;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow (10 - 20)", test_num);
            a = 8'd10;
            b = 8'd20;
            op = 2'b01;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (12 * 10)", test_num);
            a = 8'd12;
            b = 8'd10;
            op = 2'b10;
            #1;

            check_outputs(8'd120);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication Overflow (16 * 16)", test_num);
            a = 8'd16;
            b = 8'd16;
            op = 2'b10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (100 / 4)", test_num);
            a = 8'd100;
            b = 8'd4;
            op = 2'b11;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division by Zero", test_num);
            a = 8'd50;
            b = 8'd0;
            op = 2'b11;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (Small / Large)", test_num);
            a = 8'd5;
            b = 8'd10;
            op = 2'b11;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_result;
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
