`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] i_dividend;
    reg [15:0] i_divisor;
    reg [15:0] i_quotient;
    reg [15:0] i_remainder;
    wire [15:0] o_dividend;
    wire [15:0] o_quotient;
    wire [15:0] o_remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_dividend(i_dividend),
        .i_divisor(i_divisor),
        .i_quotient(i_quotient),
        .i_remainder(i_remainder),
        .o_dividend(o_dividend),
        .o_quotient(o_quotient),
        .o_remainder(o_remainder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Initial step, Remainder < Divisor", test_num);

            i_dividend = 16'h8000;
            i_divisor  = 16'h0005;
            i_remainder = 16'h0000;
            i_quotient  = 16'h0000;




            #1;





            check_outputs(16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Remainder equals Divisor (Subtraction occurs)", test_num);

            i_dividend = 16'h8000;
            i_divisor  = 16'h0001;
            i_remainder = 16'h0000;
            i_quotient  = 16'h0000;




            #1;





            check_outputs(16'h0000, 16'h0001, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Intermediate step, Remainder < Divisor (No subtraction)", test_num);

            i_dividend = 16'h4000;
            i_divisor  = 16'h0003;
            i_remainder = 16'h0001;
            i_quotient  = 16'h0002;




            #1;





            check_outputs(16'h8000, 16'h0004, 16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Intermediate step, Subtraction occurs", test_num);

            i_dividend = 16'hFFFF;
            i_divisor  = 16'h0002;
            i_remainder = 16'h0001;
            i_quotient  = 16'h0005;




            #1;





            check_outputs(16'hFFFE, 16'h000B, 16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large remainder value", test_num);

            i_dividend = 16'h0000;
            i_divisor  = 16'hFFFF;
            i_remainder = 16'h7FFF;
            i_quotient  = 16'h0000;




            #1;





            check_outputs(16'h0000, 16'h0000, 16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large values, Subtraction occurs", test_num);
            i_dividend = 16'h8000;
            i_divisor  = 16'h0001;
            i_remainder = 16'hFFFF;
            i_quotient  = 16'h1234;





            #1;






            check_outputs(16'h0000, 16'h2469, 16'hFFFE);
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
        input [15:0] expected_o_dividend;
        input [15:0] expected_o_quotient;
        input [15:0] expected_o_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_dividend === (expected_o_dividend ^ o_dividend ^ expected_o_dividend) &&
                expected_o_quotient === (expected_o_quotient ^ o_quotient ^ expected_o_quotient) &&
                expected_o_remainder === (expected_o_remainder ^ o_remainder ^ expected_o_remainder)) begin
                $display("PASS");
                $display("  Outputs: o_dividend=%h, o_quotient=%h, o_remainder=%h",
                         o_dividend, o_quotient, o_remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dividend=%h, o_quotient=%h, o_remainder=%h",
                         expected_o_dividend, expected_o_quotient, expected_o_remainder);
                $display("  Got:      o_dividend=%h, o_quotient=%h, o_remainder=%h",
                         o_dividend, o_quotient, o_remainder);
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
