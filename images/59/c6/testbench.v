`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] L;
    reg [3:0] U;
    reg [3:0] Y;
    reg [3:0] Z;
    reg [1:0] select_ms;
    wire [3:0] Lp;
    wire [3:0] Up;
    wire [3:0] Yp;
    wire [3:0] Zp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .L(L),
        .U(U),
        .Y(Y),
        .Z(Z),
        .select_ms(select_ms),
        .Lp(Lp),
        .Up(Up),
        .Yp(Yp),
        .Zp(Zp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            select_ms = 2'b00;
            L = 4'd2;
            U = 4'd4;
            Y = 4'd10;
            Z = 4'd12;


            #1;



            check_outputs(4'h3, 4'h9, 4'h9, 4'h7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            select_ms = 2'b01;
            L = 4'sb1101;
            U = 4'sb1111;
            Y = 4'd8;
            Z = 4'd10;

            #1;


            check_outputs(4'hF, 4'h5, 4'h6, 4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            select_ms = 2'b10;
            L = 4'sb1010;
            U = 4'sb0000;
            Y = 4'd13;
            Z = 4'd13;

            #1;


            check_outputs(4'hD, 4'h7, 4'hA, 4'h6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            select_ms = 2'b11;
            L = 4'd0;
            U = 4'sb1100;
            Y = 4'd4;
            Z = 4'd8;

            #1;


            check_outputs(4'h4, 4'h4, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            select_ms = 2'b00;
            L = 4'sb0111;
            U = 4'sb1010;
            Y = 4'd0;
            Z = 4'd5;

            #1;


            check_outputs(4'h8, 4'hF, 4'hF, 4'h0);
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
        input [3:0] expected_Lp;
        input [3:0] expected_Up;
        input [3:0] expected_Yp;
        input [3:0] expected_Zp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Lp === (expected_Lp ^ Lp ^ expected_Lp) &&
                expected_Up === (expected_Up ^ Up ^ expected_Up) &&
                expected_Yp === (expected_Yp ^ Yp ^ expected_Yp) &&
                expected_Zp === (expected_Zp ^ Zp ^ expected_Zp)) begin
                $display("PASS");
                $display("  Outputs: Lp=%h, Up=%h, Yp=%h, Zp=%h",
                         Lp, Up, Yp, Zp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Lp=%h, Up=%h, Yp=%h, Zp=%h",
                         expected_Lp, expected_Up, expected_Yp, expected_Zp);
                $display("  Got:      Lp=%h, Up=%h, Yp=%h, Zp=%h",
                         Lp, Up, Yp, Zp);
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
