`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] ALUFunin;
    reg ALUSrc1in;
    reg ALUSrc2in;
    reg MemRdin;
    reg MemWrin;
    reg [1:0] MemtoRegin;
    reg [1:0] RegDstin;
    reg RegWrin;
    reg Signin;
    reg flushIDEX;
    wire [5:0] ALUFunout;
    wire ALUSrc1out;
    wire ALUSrc2out;
    wire MemRdout;
    wire MemWrout;
    wire [1:0] MemtoRegout;
    wire [1:0] RegDstout;
    wire RegWrout;
    wire Signout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUFunin(ALUFunin),
        .ALUSrc1in(ALUSrc1in),
        .ALUSrc2in(ALUSrc2in),
        .MemRdin(MemRdin),
        .MemWrin(MemWrin),
        .MemtoRegin(MemtoRegin),
        .RegDstin(RegDstin),
        .RegWrin(RegWrin),
        .Signin(Signin),
        .flushIDEX(flushIDEX),
        .ALUFunout(ALUFunout),
        .ALUSrc1out(ALUSrc1out),
        .ALUSrc2out(ALUSrc2out),
        .MemRdout(MemRdout),
        .MemWrout(MemWrout),
        .MemtoRegout(MemtoRegout),
        .RegDstout(RegDstout),
        .RegWrout(RegWrout),
        .Signout(Signout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through mode (flushIDEX=0)", test_num);
            flushIDEX = 0;
            ALUFunin = 6'b101010;
            ALUSrc1in = 1;
            ALUSrc2in = 0;
            MemRdin = 1;
            MemWrin = 0;
            MemtoRegin = 2'b01;
            RegDstin = 2'b10;
            RegWrin = 1;
            Signin = 1;


            #1;



            check_outputs(6'b101010, 1, 0, 1, 0, 2'b01, 2'b10, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Flush mode (flushIDEX=1) with non-zero inputs", test_num);
            flushIDEX = 1;
            ALUFunin = 6'b111111;
            ALUSrc1in = 1;
            ALUSrc2in = 1;
            MemRdin = 1;
            MemWrin = 1;
            MemtoRegin = 2'b11;
            RegDstin = 2'b11;
            RegWrin = 1;
            Signin = 1;


            #1;



            check_outputs(6'b0, 0, 0, 0, 0, 2'b0, 2'b0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through mode (flushIDEX=0) - All signals high", test_num);
            flushIDEX = 0;
            ALUFunin = 6'b111111;
            ALUSrc1in = 1;
            ALUSrc2in = 1;
            MemRdin = 1;
            MemWrin = 1;
            MemtoRegin = 2'b11;
            RegDstin = 2'b11;
            RegWrin = 1;
            Signin = 1;

            #1;


            check_outputs(6'b111111, 1, 1, 1, 1, 2'b11, 2'b11, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through mode - Alternate pattern", test_num);
            flushIDEX = 0;
            ALUFunin = 6'h1F;
            ALUSrc1in = 0;
            ALUSrc2in = 1;
            MemRdin = 0;
            MemWrin = 1;
            MemtoRegin = 2'b10;
            RegDstin = 2'b01;
            RegWrin = 0;
            Signin = 0;

            #1;


            check_outputs(6'h1F, 0, 1, 0, 1, 2'b10, 2'b01, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition from Flush back to Normal", test_num);


            flushIDEX = 1;
            #5;


            flushIDEX = 0;
            ALUFunin = 6'h2A;
            ALUSrc1in = 1;
            ALUSrc2in = 0;
            MemRdin = 1;
            MemWrin = 0;
            MemtoRegin = 2'b00;
            RegDstin = 2'b11;
            RegWrin = 1;
            Signin = 1;

            #1;


            check_outputs(6'h2A, 1, 0, 1, 0, 2'b00, 2'b11, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through mode - ALUFunin boundary bits", test_num);
            flushIDEX = 0;
            ALUFunin = 6'b100001;
            ALUSrc1in = 0;
            ALUSrc2in = 0;
            MemRdin = 0;
            MemWrin = 0;
            MemtoRegin = 2'b00;
            RegDstin = 2'b00;
            RegWrin = 0;
            Signin = 0;

            #1;


            check_outputs(6'b100001, 0, 0, 0, 0, 2'b00, 2'b00, 0, 0);
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
        input [5:0] expected_ALUFunout;
        input expected_ALUSrc1out;
        input expected_ALUSrc2out;
        input expected_MemRdout;
        input expected_MemWrout;
        input [1:0] expected_MemtoRegout;
        input [1:0] expected_RegDstout;
        input expected_RegWrout;
        input expected_Signout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUFunout === (expected_ALUFunout ^ ALUFunout ^ expected_ALUFunout) &&
                expected_ALUSrc1out === (expected_ALUSrc1out ^ ALUSrc1out ^ expected_ALUSrc1out) &&
                expected_ALUSrc2out === (expected_ALUSrc2out ^ ALUSrc2out ^ expected_ALUSrc2out) &&
                expected_MemRdout === (expected_MemRdout ^ MemRdout ^ expected_MemRdout) &&
                expected_MemWrout === (expected_MemWrout ^ MemWrout ^ expected_MemWrout) &&
                expected_MemtoRegout === (expected_MemtoRegout ^ MemtoRegout ^ expected_MemtoRegout) &&
                expected_RegDstout === (expected_RegDstout ^ RegDstout ^ expected_RegDstout) &&
                expected_RegWrout === (expected_RegWrout ^ RegWrout ^ expected_RegWrout) &&
                expected_Signout === (expected_Signout ^ Signout ^ expected_Signout)) begin
                $display("PASS");
                $display("  Outputs: ALUFunout=%h, ALUSrc1out=%b, ALUSrc2out=%b, MemRdout=%b, MemWrout=%b, MemtoRegout=%h, RegDstout=%h, RegWrout=%b, Signout=%b",
                         ALUFunout, ALUSrc1out, ALUSrc2out, MemRdout, MemWrout, MemtoRegout, RegDstout, RegWrout, Signout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUFunout=%h, ALUSrc1out=%b, ALUSrc2out=%b, MemRdout=%b, MemWrout=%b, MemtoRegout=%h, RegDstout=%h, RegWrout=%b, Signout=%b",
                         expected_ALUFunout, expected_ALUSrc1out, expected_ALUSrc2out, expected_MemRdout, expected_MemWrout, expected_MemtoRegout, expected_RegDstout, expected_RegWrout, expected_Signout);
                $display("  Got:      ALUFunout=%h, ALUSrc1out=%b, ALUSrc2out=%b, MemRdout=%b, MemWrout=%b, MemtoRegout=%h, RegDstout=%h, RegWrout=%b, Signout=%b",
                         ALUFunout, ALUSrc1out, ALUSrc2out, MemRdout, MemWrout, MemtoRegout, RegDstout, RegWrout, Signout);
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
