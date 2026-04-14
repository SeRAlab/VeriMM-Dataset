`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg do_sub;
    wire [7:0] out;
    wire result_is_zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .do_sub(do_sub),
        .out(out),
        .result_is_zero(result_is_zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Addition (5 + 10)", test_num);
        a = 8'd5;
        b = 8'd10;
        do_sub = 1'b0;
        #1;

        check_outputs(8'd15, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Addition with overflow (255 + 1)", test_num);
        a = 8'd255;
        b = 8'd1;
        do_sub = 1'b0;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Basic Subtraction (50 - 20)", test_num);
        a = 8'd50;
        b = 8'd20;
        do_sub = 1'b1;
        #1;

        check_outputs(8'd30, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Subtraction resulting in zero (42 - 42)", test_num);
        a = 8'd42;
        b = 8'd42;
        do_sub = 1'b1;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Subtraction with underflow (10 - 20)", test_num);
        a = 8'd10;
        b = 8'd20;
        do_sub = 1'b1;

        #1;


        check_outputs(8'hF6, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Addition of zeros (0 + 0)", test_num);
        a = 8'd0;
        b = 8'd0;
        do_sub = 1'b0;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Subtraction from zero (0 - 1)", test_num);
        a = 8'd0;
        b = 8'd1;
        do_sub = 1'b1;
        #1;

        check_outputs(8'hFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Addition resulting in max value (127 + 128)", test_num);
        a = 8'd127;
        b = 8'd128;
        do_sub = 1'b0;
        #1;

        check_outputs(8'd255, 1'b0);
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
        input [7:0] expected_out;
        input expected_result_is_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_result_is_zero === (expected_result_is_zero ^ result_is_zero ^ expected_result_is_zero)) begin
                $display("PASS");
                $display("  Outputs: out=%h, result_is_zero=%b",
                         out, result_is_zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, result_is_zero=%b",
                         expected_out, expected_result_is_zero);
                $display("  Got:      out=%h, result_is_zero=%b",
                         out, result_is_zero);
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
