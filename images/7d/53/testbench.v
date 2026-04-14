`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg do_sub;
    wire carry_flag;
    wire [7:0] out;
    wire overflow_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .do_sub(do_sub),
        .carry_flag(carry_flag),
        .out(out),
        .overflow_flag(overflow_flag)
    );
    task testcase001;

        begin
            test_num = 1;
            do_sub = 0; a = 8'd10; b = 8'd20;
            #1;

            check_outputs(1'b0, 8'h1E, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            do_sub = 0; a = 8'd200; b = 8'd100;
            #1;

            check_outputs(1'b1, 8'h2C, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            do_sub = 0; a = 8'd120; b = 8'd10;
            #1;

            check_outputs(1'b0, 8'h82, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            do_sub = 1; a = 8'd50; b = 8'd20;
            #1;

            check_outputs(1'b0, 8'h1E, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            do_sub = 1; a = 8'd20; b = 8'd50;
            #1;

            check_outputs(1'b1, 8'hE2, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            do_sub = 1; a = 8'd100; b = 8'b11001110;
            #1;

            check_outputs(1'b1, 8'h96, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            do_sub = 0; a = 8'h7F; b = 8'h01;
            #1;

            check_outputs(1'b0, 8'h80, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            do_sub = 1; a = 8'h80; b = 8'h01;
            #1;

            check_outputs(1'b0, 8'h7F, 1'b1);
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
        input expected_carry_flag;
        input [7:0] expected_out;
        input expected_overflow_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_flag === (expected_carry_flag ^ carry_flag ^ expected_carry_flag) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_overflow_flag === (expected_overflow_flag ^ overflow_flag ^ expected_overflow_flag)) begin
                $display("PASS");
                $display("  Outputs: carry_flag=%b, out=%h, overflow_flag=%b",
                         carry_flag, out, overflow_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_flag=%b, out=%h, overflow_flag=%b",
                         expected_carry_flag, expected_out, expected_overflow_flag);
                $display("  Got:      carry_flag=%b, out=%h, overflow_flag=%b",
                         carry_flag, out, overflow_flag);
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
