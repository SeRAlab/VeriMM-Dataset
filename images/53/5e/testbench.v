`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] function_sel;
    wire [15:0] aluout;
    wire carry_flag;
    wire parity_flag;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .function_sel(function_sel),
        .aluout(aluout),
        .carry_flag(carry_flag),
        .parity_flag(parity_flag),
        .zero_flag(zero_flag)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Basic)", test_num);
            A = 16'h0005;
            B = 16'h000A;
            function_sel = 4'h0;

            #1;


            check_outputs(16'h000F, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Carry and Zero Flag)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            function_sel = 4'h0;

            #1;


            check_outputs(16'h0000, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (Basic)", test_num);
            A = 16'h000A;
            B = 16'h0005;
            function_sel = 4'h1;


            #1;



            check_outputs(16'h0005, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise AND", test_num);
            A = 16'hF0F0;
            B = 16'hAAAA;
            function_sel = 4'h2;

            #1;


            check_outputs(16'hA0A0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise OR", test_num);
            A = 16'h1234;
            B = 16'h8888;
            function_sel = 4'h3;

            #1;


            check_outputs(16'h9AB4, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise XOR", test_num);
            A = 16'hFFFF;
            B = 16'hAAAA;
            function_sel = 4'h4;

            #1;


            check_outputs(16'h5555, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise NAND", test_num);
            A = 16'h00FF;
            B = 16'h0F0F;
            function_sel = 4'h5;

            #1;


            check_outputs(16'hFFF0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Shift Left", test_num);
            A = 16'h8001;
            B = 16'h0001;
            function_sel = 4'h8;

            #1;


            check_outputs(16'h0002, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Shift Right", test_num);
            A = 16'h0001;
            B = 16'h0001;
            function_sel = 4'h9;

            #1;


            check_outputs(16'h0000, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rotate Left", test_num);
            A = 16'hA000;
            B = 16'h0001;
            function_sel = 4'hA;

            #1;


            check_outputs(16'h4001, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Parity Check (Odd)", test_num);
            A = 16'h0001;
            B = 16'h0000;
            function_sel = 4'h0;

            #1;


            check_outputs(16'h0001, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Flag Check", test_num);
            A = 16'h1234;
            B = 16'h1234;
            function_sel = 4'h4;

            #1;


            check_outputs(16'h0000, 1'b0, 1'b1, 1'b1);
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
        testcase011();
        testcase012();
        
        
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
        input [15:0] expected_aluout;
        input expected_carry_flag;
        input expected_parity_flag;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluout === (expected_aluout ^ aluout ^ expected_aluout) &&
                expected_carry_flag === (expected_carry_flag ^ carry_flag ^ expected_carry_flag) &&
                expected_parity_flag === (expected_parity_flag ^ parity_flag ^ expected_parity_flag) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: aluout=%h, carry_flag=%b, parity_flag=%b, zero_flag=%b",
                         aluout, carry_flag, parity_flag, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluout=%h, carry_flag=%b, parity_flag=%b, zero_flag=%b",
                         expected_aluout, expected_carry_flag, expected_parity_flag, expected_zero_flag);
                $display("  Got:      aluout=%h, carry_flag=%b, parity_flag=%b, zero_flag=%b",
                         aluout, carry_flag, parity_flag, zero_flag);
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
