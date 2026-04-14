`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] ctrl;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Addition 1.0 + 2.0", test_num);
            a = 32'h3f800000;
            b = 32'h40000000;
            ctrl = 2'b00;
            #1;

            check_outputs(32'h40400000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Subtraction 3.0 - 1.0", test_num);
            a = 32'h40400000;
            b = 32'h3f800000;
            ctrl = 2'b01;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiplication 2.0 * 3.0", test_num);
            a = 32'h40000000;
            b = 32'h40400000;
            ctrl = 2'b10;
            #1;

            check_outputs(32'h40c00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Division 6.0 / 2.0", test_num);
            a = 32'h40c00000;
            b = 32'h40000000;
            ctrl = 2'b11;
            #1;

            check_outputs(32'h40400000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Addition 1.0 + (-1.0)", test_num);
            a = 32'h3f800000;
            b = 32'hbf800000;
            ctrl = 2'b00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Subtraction 1.0 - 2.0", test_num);
            a = 32'h3f800000;
            b = 32'h40000000;
            ctrl = 2'b01;
            #1;

            check_outputs(32'hbf800000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Multiplication 2.0 * 0.5", test_num);
            a = 32'h40000000;
            b = 32'h3f000000;
            ctrl = 2'b10;
            #1;

            check_outputs(32'h3f800000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Division 10.0 / 4.0", test_num);
            a = 32'h41200000;
            b = 32'h40800000;
            ctrl = 2'b11;
            #1;

            check_outputs(32'h40200000);
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
