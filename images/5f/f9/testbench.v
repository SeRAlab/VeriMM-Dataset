`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [1:0] op;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .op(op),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
            op = 2'b00;
            $display("Test Case 001: Select input 'a' (op=00)");
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
            op = 2'b01;
            $display("Test Case 002: Select input 'b' (op=01)");
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
            op = 2'b10;
            $display("Test Case 003: Select input 'c' (op=10)");
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
            op = 2'b11;
            $display("Test Case 004: Select input 'd' (op=11)");
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h00;
            op = 2'b01;
            $display("Test Case 005: All inputs 0, select 'b'");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'hFF; b = 8'hFF; c = 8'hFF; d = 8'hFF;
            op = 2'b10;
            $display("Test Case 006: All inputs FF, select 'c'");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            op = 2'b00;
            a = 8'h55; b = 8'hAA; c = 8'h11; d = 8'h22;
            #2;
            a = 8'h99;
            $display("Test Case 007: Update input 'a' while selected");
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'hDE; b = 8'hAD; c = 8'hBE; d = 8'hEF;
            op = 2'b11;
            $display("Test Case 008: Select 'd' with distinct pattern");
            #1;

            check_outputs(8'hEF);
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
