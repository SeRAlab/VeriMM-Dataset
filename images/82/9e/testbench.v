`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [5:0] Signal;
    reg clk;
    wire [5:0] SignaltoALU;
    wire [5:0] SignaltoMULT;
    wire [5:0] SignaltoMUX;
    wire [5:0] SignaltoSHT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .Signal(Signal),
        .clk(clk),
        .SignaltoALU(SignaltoALU),
        .SignaltoMULT(SignaltoMULT),
        .SignaltoMUX(SignaltoMUX),
        .SignaltoSHT(SignaltoSHT)
    );
    task reset_unit;

    begin
        ALUOp = 2'b00;
        Signal = 6'b000000;
        @(negedge clk);
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: ALUOp=00 (Memory Access Add)", test_num);
        reset_unit();

        ALUOp = 2'b00;
        Signal = 6'b111111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'd32, 6'd32, 6'd32, 6'd32);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: ALUOp=01 (Branch Subtraction)", test_num);
        reset_unit();

        ALUOp = 2'b01;
        Signal = 6'b111111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'd34, 6'd34, 6'd34, 6'd34);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: ALUOp=10, Signal=32 (R-type Add)", test_num);
        reset_unit();

        ALUOp = 2'b10;
        Signal = 6'd32;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'd32, 6'd32, 6'd32, 6'd32);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: ALUOp=10, Signal=34 (R-type Sub)", test_num);
        reset_unit();

        ALUOp = 2'b10;
        Signal = 6'd34;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'd34, 6'd34, 6'd34, 6'd34);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: ALUOp=10, Signal=36 (R-type AND)", test_num);
        reset_unit();

        ALUOp = 2'b10;
        Signal = 6'd36;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'd36, 6'd36, 6'd36, 6'd36);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: ALUOp=10, Signal=24 (R-type Mult)", test_num);
        reset_unit();

        ALUOp = 2'b10;
        Signal = 6'd24;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'd24, 6'd24, 6'd24, 6'd24);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: ALUOp=10, Signal=0 (R-type SLL)", test_num);
        reset_unit();

        ALUOp = 2'b10;
        Signal = 6'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'd0, 6'd0, 6'd0, 6'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: ALUOp=10, Signal=42 (R-type SLT)", test_num);
        reset_unit();

        ALUOp = 2'b10;
        Signal = 6'd42;
        @(posedge clk);
        #2;
        #1;

        check_outputs(6'd42, 6'd42, 6'd42, 6'd42);
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
        input [5:0] expected_SignaltoALU;
        input [5:0] expected_SignaltoMULT;
        input [5:0] expected_SignaltoMUX;
        input [5:0] expected_SignaltoSHT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SignaltoALU === (expected_SignaltoALU ^ SignaltoALU ^ expected_SignaltoALU) &&
                expected_SignaltoMULT === (expected_SignaltoMULT ^ SignaltoMULT ^ expected_SignaltoMULT) &&
                expected_SignaltoMUX === (expected_SignaltoMUX ^ SignaltoMUX ^ expected_SignaltoMUX) &&
                expected_SignaltoSHT === (expected_SignaltoSHT ^ SignaltoSHT ^ expected_SignaltoSHT)) begin
                $display("PASS");
                $display("  Outputs: SignaltoALU=%h, SignaltoMULT=%h, SignaltoMUX=%h, SignaltoSHT=%h",
                         SignaltoALU, SignaltoMULT, SignaltoMUX, SignaltoSHT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SignaltoALU=%h, SignaltoMULT=%h, SignaltoMUX=%h, SignaltoSHT=%h",
                         expected_SignaltoALU, expected_SignaltoMULT, expected_SignaltoMUX, expected_SignaltoSHT);
                $display("  Got:      SignaltoALU=%h, SignaltoMULT=%h, SignaltoMUX=%h, SignaltoSHT=%h",
                         SignaltoALU, SignaltoMULT, SignaltoMUX, SignaltoSHT);
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
