`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [1:0] aluc;
    reg [31:0] b;
    wire carry;
    wire [31:0] data_out;
    wire negative;
    wire overflow;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .aluc(aluc),
        .b(b),
        .carry(carry),
        .data_out(data_out),
        .negative(negative),
        .overflow(overflow),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h0000000A;
            b = 32'h00000014;
            aluc = 2'b00;

            #1;


            check_outputs(1'b0, 32'h0000001E, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            aluc = 2'b00;

            #1;


            check_outputs(1'b1, 32'h00000000, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h00000020;
            b = 32'h00000010;
            aluc = 2'b01;

            #1;


            check_outputs(1'b1, 32'h00000010, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'h00000005;
            b = 32'h0000000A;
            aluc = 2'b01;

            #1;


            check_outputs(1'b0, 32'hFFFFFFF6, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'h7FFFFFFF;
            b = 32'h00000001;
            aluc = 2'b10;

            #1;


            check_outputs(1'b0, 32'h80000000, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            aluc = 2'b10;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFE, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h80000000;
            b = 32'h00000001;
            aluc = 2'b11;

            #1;


            check_outputs(1'b1, 32'h7FFFFFFF, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h12345678;
            b = 32'h12345678;
            aluc = 2'b11;

            #1;


            check_outputs(1'b1, 32'h00000000, 1'b0, 1'b0, 1'b1);
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
        input expected_carry;
        input [31:0] expected_data_out;
        input expected_negative;
        input expected_overflow;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_negative === (expected_negative ^ negative ^ expected_negative) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, data_out=%h, negative=%b, overflow=%b, zero=%b",
                         carry, data_out, negative, overflow, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, data_out=%h, negative=%b, overflow=%b, zero=%b",
                         expected_carry, expected_data_out, expected_negative, expected_overflow, expected_zero);
                $display("  Got:      carry=%b, data_out=%h, negative=%b, overflow=%b, zero=%b",
                         carry, data_out, negative, overflow, zero);
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
