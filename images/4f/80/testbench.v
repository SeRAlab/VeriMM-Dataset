`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] Ins;
    reg [15:0] T;
    wire Add;
    wire Div;
    wire End;
    wire Mul;
    wire R1in;
    wire R1out;
    wire R2in;
    wire R2out;
    wire Run;
    wire SelectY;
    wire Sub;
    wire Yin;
    wire Zin;
    wire Zout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ins(Ins),
        .T(T),
        .Add(Add),
        .Div(Div),
        .End(End),
        .Mul(Mul),
        .R1in(R1in),
        .R1out(R1out),
        .R2in(R2in),
        .R2out(R2out),
        .Run(Run),
        .SelectY(SelectY),
        .Sub(Sub),
        .Yin(Yin),
        .Zin(Zin),
        .Zout(Zout)
    );
    task reset_inputs;

    begin
        Ins = 4'b0000;
        T = 16'h0001;
        #5;
    end
        endtask

    task testcase001;

    begin
        reset_inputs();
        $display("Testcase 001: Move (MV) Instruction at T1");
        Ins = 4'b0000; T = 16'h0002;

        #1;


        check_outputs(0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_inputs();
        $display("Testcase 002: Add Instruction T1 (Load Y)");
        Ins = 4'b0001; T = 16'h0002;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        reset_inputs();
        $display("Testcase 003: Add Instruction T2 (ALU Operation)");
        Ins = 4'b0001; T = 16'h0004;
        #1;

        check_outputs(1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        reset_inputs();
        $display("Testcase 004: Add Instruction T3 (Writeback)");
        Ins = 4'b0001; T = 16'h0008;
        #1;

        check_outputs(0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        reset_inputs();
        $display("Testcase 005: Sub Instruction T2");
        Ins = 4'b0010; T = 16'h0004;
        #1;

        check_outputs(0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        reset_inputs();
        $display("Testcase 006: Mul Instruction T2");
        Ins = 4'b0011; T = 16'h0004;
        #1;

        check_outputs(0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        reset_inputs();
        $display("Testcase 007: Div Instruction T2");
        Ins = 4'b0100; T = 16'h0004;
        #1;

        check_outputs(0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        reset_inputs();
        $display("Testcase 008: Idle State (T0)");
        Ins = 4'b0001; T = 16'h0001;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0);
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
        input expected_Add;
        input expected_Div;
        input expected_End;
        input expected_Mul;
        input expected_R1in;
        input expected_R1out;
        input expected_R2in;
        input expected_R2out;
        input expected_Run;
        input expected_SelectY;
        input expected_Sub;
        input expected_Yin;
        input expected_Zin;
        input expected_Zout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Add === (expected_Add ^ Add ^ expected_Add) &&
                expected_Div === (expected_Div ^ Div ^ expected_Div) &&
                expected_End === (expected_End ^ End ^ expected_End) &&
                expected_Mul === (expected_Mul ^ Mul ^ expected_Mul) &&
                expected_R1in === (expected_R1in ^ R1in ^ expected_R1in) &&
                expected_R1out === (expected_R1out ^ R1out ^ expected_R1out) &&
                expected_R2in === (expected_R2in ^ R2in ^ expected_R2in) &&
                expected_R2out === (expected_R2out ^ R2out ^ expected_R2out) &&
                expected_Run === (expected_Run ^ Run ^ expected_Run) &&
                expected_SelectY === (expected_SelectY ^ SelectY ^ expected_SelectY) &&
                expected_Sub === (expected_Sub ^ Sub ^ expected_Sub) &&
                expected_Yin === (expected_Yin ^ Yin ^ expected_Yin) &&
                expected_Zin === (expected_Zin ^ Zin ^ expected_Zin) &&
                expected_Zout === (expected_Zout ^ Zout ^ expected_Zout)) begin
                $display("PASS");
                $display("  Outputs: Add=%b, Div=%b, End=%b, Mul=%b, R1in=%b, R1out=%b, R2in=%b, R2out=%b, Run=%b, SelectY=%b, Sub=%b, Yin=%b, Zin=%b, Zout=%b",
                         Add, Div, End, Mul, R1in, R1out, R2in, R2out, Run, SelectY, Sub, Yin, Zin, Zout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Add=%b, Div=%b, End=%b, Mul=%b, R1in=%b, R1out=%b, R2in=%b, R2out=%b, Run=%b, SelectY=%b, Sub=%b, Yin=%b, Zin=%b, Zout=%b",
                         expected_Add, expected_Div, expected_End, expected_Mul, expected_R1in, expected_R1out, expected_R2in, expected_R2out, expected_Run, expected_SelectY, expected_Sub, expected_Yin, expected_Zin, expected_Zout);
                $display("  Got:      Add=%b, Div=%b, End=%b, Mul=%b, R1in=%b, R1out=%b, R2in=%b, R2out=%b, Run=%b, SelectY=%b, Sub=%b, Yin=%b, Zin=%b, Zout=%b",
                         Add, Div, End, Mul, R1in, R1out, R2in, R2out, Run, SelectY, Sub, Yin, Zin, Zout);
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
