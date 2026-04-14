`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg op;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Simple Addition (2 + 3)", test_num);
            a = 4'd2;
            b = 4'd3;
            op = 1'b0;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Addition with Overflow (10 + 7)", test_num);
            a = 4'd10;
            b = 4'd7;
            op = 1'b0;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Addition at Boundary (15 + 1)", test_num);
            a = 4'hF;
            b = 4'h1;
            op = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Simple Subtraction (10 - 4)", test_num);
            a = 4'd10;
            b = 4'd4;
            op = 1'b1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Subtraction with Wrap Around (3 - 5)", test_num);
            a = 4'd3;
            b = 4'd5;
            op = 1'b1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Subtraction resulting in Zero (8 - 8)", test_num);
            a = 4'd8;
            b = 4'd8;
            op = 1'b1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Subtraction from Zero (0 - 1)", test_num);
            a = 4'h0;
            b = 4'h1;
            op = 1'b1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Max Values Addition (15 + 15)", test_num);
            a = 4'hF;
            b = 4'hF;
            op = 1'b0;
            #1;

            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        input [3:0] expected_result;
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
