`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] i_control;
    reg [31:0] i_op1;
    reg [31:0] i_op2;
    wire [31:0] o_result;
    wire o_zf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_control(i_control),
        .i_op1(i_op1),
        .i_op2(i_op2),
        .o_result(o_result),
        .o_zf(o_zf)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: AND Operation", test_num);
            i_control = 4'b0000;
            i_op1 = 32'hF0F0_AAAA;
            i_op2 = 32'h0F0F_FFFF;

            #1;


            check_outputs(32'h0000_AAAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OR Operation", test_num);
            i_control = 4'b0001;
            i_op1 = 32'hF0F0_0000;
            i_op2 = 32'h0F0F_AAAA;

            #1;


            check_outputs(32'hFFFF_AAAA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Positive)", test_num);
            i_control = 4'b0010;
            i_op1 = 32'd100;
            i_op2 = 32'd250;

            #1;


            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Zero Result / ZF Check)", test_num);
            i_control = 4'b0110;
            i_op1 = 32'h1234_5678;
            i_op2 = 32'h1234_5678;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Negative Result)", test_num);
            i_control = 4'b0110;
            i_op1 = 32'd10;
            i_op2 = 32'd20;

            #1;


            check_outputs(32'hFFFF_FFF6, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLT (True Case: 5 < 10)", test_num);
            i_control = 4'b0111;
            i_op1 = 32'd5;
            i_op2 = 32'd10;

            #1;


            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLT (False Case: 10 < 5)", test_num);
            i_control = 4'b0111;
            i_op1 = 32'd10;
            i_op2 = 32'd5;

            #1;


            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NOR Operation", test_num);
            i_control = 4'b1100;
            i_op1 = 32'h0000_0000;
            i_op2 = 32'h0000_0000;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Overflow Wrap)", test_num);
            i_control = 4'b0010;
            i_op1 = 32'hFFFF_FFFF;
            i_op2 = 32'h0000_0001;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NOR (Zero Result)", test_num);
            i_control = 4'b1100;
            i_op1 = 32'hFFFF_0000;
            i_op2 = 32'h0000_FFFF;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
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
        input [31:0] expected_o_result;
        input expected_o_zf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_result === (expected_o_result ^ o_result ^ expected_o_result) &&
                expected_o_zf === (expected_o_zf ^ o_zf ^ expected_o_zf)) begin
                $display("PASS");
                $display("  Outputs: o_result=%h, o_zf=%b",
                         o_result, o_zf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_result=%h, o_zf=%b",
                         expected_o_result, expected_o_zf);
                $display("  Got:      o_result=%h, o_zf=%b",
                         o_result, o_zf);
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
