`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A_in;
    reg [7:0] B_in;
    reg C_in;
    reg [2:0] Opcode_in;
    wire C_out;
    wire [7:0] Result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_in(A_in),
        .B_in(B_in),
        .C_in(C_in),
        .Opcode_in(Opcode_in),
        .C_out(C_out),
        .Result_out(Result_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (A=10, B=20, C_in=0)", test_num);
            A_in = 8'd10;
            B_in = 8'd20;
            C_in = 1'b0;
            Opcode_in = 3'b000;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (A=10, B=20, C_in=1)", test_num);
            A_in = 8'd10;
            B_in = 8'd20;
            C_in = 1'b1;
            Opcode_in = 3'b000;
            #1;

            check_outputs(1'b0, 8'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (A=255, B=1, C_in=0)", test_num);
            A_in = 8'hFF;
            B_in = 8'h01;
            C_in = 1'b0;
            Opcode_in = 3'b000;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (A=50, B=10)", test_num);
            A_in = 8'd50;
            B_in = 8'd10;
            C_in = 1'b0;
            Opcode_in = 3'b001;
            #1;

            check_outputs(1'b0, 8'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND (A=0xAA, B=0xF0)", test_num);
            A_in = 8'hAA;
            B_in = 8'hF0;
            C_in = 1'b0;
            Opcode_in = 3'b010;
            #1;

            check_outputs(1'b0, 8'hA0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR (A=0xAA, B=0x0F)", test_num);
            A_in = 8'hAA;
            B_in = 8'h0F;
            C_in = 1'b0;
            Opcode_in = 3'b011;
            #1;

            check_outputs(1'b0, 8'hAF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Modulo (A=10, B=3)", test_num);
            A_in = 8'd10;
            B_in = 8'd3;
            C_in = 1'b0;
            Opcode_in = 3'b100;
            #1;

            check_outputs(1'b0, 8'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Default Case (Opcode=5)", test_num);
            A_in = 8'hFF;
            B_in = 8'hFF;
            C_in = 1'b1;
            Opcode_in = 3'b101;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Extreme (A=255, B=255, C_in=1)", test_num);
            A_in = 8'hFF;
            B_in = 8'hFF;
            C_in = 1'b1;
            Opcode_in = 3'b000;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Result 0 (A=128, B=128)", test_num);
            A_in = 8'd128;
            B_in = 8'd128;
            Opcode_in = 3'b001;
            #1;

            check_outputs(1'b0, 8'd0);
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
        input expected_C_out;
        input [7:0] expected_Result_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_Result_out === (expected_Result_out ^ Result_out ^ expected_Result_out)) begin
                $display("PASS");
                $display("  Outputs: C_out=%b, Result_out=%h",
                         C_out, Result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%b, Result_out=%h",
                         expected_C_out, expected_Result_out);
                $display("  Got:      C_out=%b, Result_out=%h",
                         C_out, Result_out);
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
