`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg sub;
    wire borrow_out;
    wire carry_out;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sub(sub),
        .borrow_out(borrow_out),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

        begin
            a = 16'h0005; b = 16'h000A; sub = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 16'h000F);
        end
        endtask

    task testcase002;

        begin
            a = 16'hFFFF; b = 16'h0001; sub = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            a = 16'h8000; b = 16'h8000; sub = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            a = 16'h0014; b = 16'h0005; sub = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 16'h000F);
        end
        endtask

    task testcase005;

        begin
            a = 16'hABCD; b = 16'hABCD; sub = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            a = 16'h0005; b = 16'h000A; sub = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 16'hFFFB);
        end
        endtask

    task testcase007;

        begin
            a = 16'h0000; b = 16'h0001; sub = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0, 16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            a = 16'hFFFF; b = 16'hFFFF; sub = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 16'hFFFE);
        end
        endtask

    task testcase009;

        begin
            a = 16'hFFFF; b = 16'h0000; sub = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            a = 16'h0001; b = 16'hFFFF; sub = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 16'h0002);
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
        input expected_borrow_out;
        input expected_carry_out;
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, carry_out=%b, result=%h",
                         borrow_out, carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, carry_out=%b, result=%h",
                         expected_borrow_out, expected_carry_out, expected_result);
                $display("  Got:      borrow_out=%b, carry_out=%b, result=%h",
                         borrow_out, carry_out, result);
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
