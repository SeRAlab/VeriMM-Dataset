`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ctrl;
    reg [3:0] shamt;
    reg [15:0] src0;
    reg [15:0] src1;
    wire ne;
    wire ov;
    wire [15:0] result;
    wire zr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .shamt(shamt),
        .src0(src0),
        .src1(src1),
        .ne(ne),
        .ov(ov),
        .result(result),
        .zr(zr)
    );
    task reset_inputs;

        begin
            ctrl = 3'b000;
            shamt = 4'h0;
            src0 = 16'h0000;
            src1 = 16'h0000;
            #5;
        end
        endtask

    task testcase001;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Basic)", test_num);
            ctrl = 3'b000;
            src0 = 16'h1234;
            src1 = 16'h1111;

            #1;


            check_outputs(1'b0, 1'b0, 16'h2345, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Signed Overflow Positive)", test_num);
            ctrl = 3'b000;
            src0 = 16'h7FFF;
            src1 = 16'h0001;

            #1;


            check_outputs(1'b1, 1'b1, 16'h8000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Zero Flag)", test_num);
            ctrl = 3'b001;
            src0 = 16'hAAAA;
            src1 = 16'hAAAA;

            #1;


            check_outputs(1'b0, 1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Signed Overflow Negative)", test_num);
            ctrl = 3'b001;
            src0 = 16'h8000;
            src1 = 16'h0001;

            #1;


            check_outputs(1'b0, 1'b1, 16'h7FFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Logical AND", test_num);
            ctrl = 3'b010;
            src0 = 16'hF0F0;
            src1 = 16'hAAAA;

            #1;


            check_outputs(1'b1, 1'b0, 16'hA0A0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Logical XOR", test_num);
            ctrl = 3'b100;
            src0 = 16'hFFFF;
            src1 = 16'h7FFF;

            #1;


            check_outputs(1'b1, 1'b0, 16'h8000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left Logical", test_num);
            ctrl = 3'b101;
            src0 = 16'h0001;
            shamt = 4'd4;

            #1;


            check_outputs(1'b0, 1'b0, 16'h0010, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right Arithmetic (Sign Extension)", test_num);
            ctrl = 3'b111;
            src0 = 16'h8000;
            shamt = 4'd1;

            #1;


            check_outputs(1'b1, 1'b0, 16'hC000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right Logical", test_num);
            ctrl = 3'b110;
            src0 = 16'h8000;
            shamt = 4'd1;

            #1;


            check_outputs(1'b0, 1'b0, 16'h4000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_inputs();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Max Amount", test_num);
            ctrl = 3'b101;
            src0 = 16'hFFFF;
            shamt = 4'd15;

            #1;


            check_outputs(1'b1, 1'b0, 16'h8000, 1'b0);
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
        input expected_ne;
        input expected_ov;
        input [15:0] expected_result;
        input expected_zr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ne === (expected_ne ^ ne ^ expected_ne) &&
                expected_ov === (expected_ov ^ ov ^ expected_ov) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zr === (expected_zr ^ zr ^ expected_zr)) begin
                $display("PASS");
                $display("  Outputs: ne=%b, ov=%b, result=%h, zr=%b",
                         ne, ov, result, zr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ne=%b, ov=%b, result=%h, zr=%b",
                         expected_ne, expected_ov, expected_result, expected_zr);
                $display("  Got:      ne=%b, ov=%b, result=%h, zr=%b",
                         ne, ov, result, zr);
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
