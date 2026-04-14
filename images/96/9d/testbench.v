`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg c_i;
    wire c_o;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_i(c_i),
        .c_o(c_o),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All zeros (0+0+0)");
        a = 2'b00; b = 2'b00; c_i = 1'b0;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Simple addition without carry (1+1+0)");
        a = 2'b01; b = 2'b01; c_i = 1'b0;
        #1;

        check_outputs(1'b0, 2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Simple addition with input carry (1+1+1)");
        a = 2'b01; b = 2'b01; c_i = 1'b1;
        #1;

        check_outputs(1'b0, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Generating carry out (2+2+0)");
        a = 2'b10; b = 2'b10; c_i = 1'b0;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Max addition with input carry (3+3+1)");
        a = 2'b11; b = 2'b11; c_i = 1'b1;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Carry out from partial inputs (3+1+0)");
        a = 2'b11; b = 2'b01; c_i = 1'b0;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Carry out via input carry (1+2+1)");
        a = 2'b01; b = 2'b10; c_i = 1'b1;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Zero inputs with carry (0+0+1)");
        a = 2'b00; b = 2'b00; c_i = 1'b1;
        #1;

        check_outputs(1'b0, 2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Maximum carry out bit pattern (3+3+0)");
        a = 2'b11; b = 2'b11; c_i = 1'b0;
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Symmetric check (2+1+0)");
        a = 2'b10; b = 2'b01; c_i = 1'b0;
        #1;

        check_outputs(1'b0, 2'b11);
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
        input expected_c_o;
        input [1:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_o === (expected_c_o ^ c_o ^ expected_c_o) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: c_o=%b, out=%h",
                         c_o, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_o=%b, out=%h",
                         expected_c_o, expected_out);
                $display("  Got:      c_o=%b, out=%h",
                         c_o, out);
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
