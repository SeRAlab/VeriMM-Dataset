`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] ALUFunin;
    reg ALUSrc1in;
    reg ALUSrc2in;
    reg [31:0] DatabusAin;
    reg [31:0] DatabusBin;
    reg MemRdin;
    reg MemWrin;
    reg [1:0] MemtoRegin;
    reg [31:0] PCplusin;
    reg [1:0] RegDstin;
    reg RegWrin;
    reg Signin;
    reg clk;
    reg datahazard;
    reg [31:0] immin;
    reg [31:0] instructionin;
    wire [5:0] ALUFunout;
    wire ALUSrc1out;
    wire ALUSrc2out;
    wire [31:0] DatabusAout;
    wire [31:0] DatabusBout;
    wire MemRdout;
    wire MemWrout;
    wire [1:0] MemtoRegout;
    wire [31:0] PCplusout;
    wire [4:0] Rdout;
    wire [1:0] RegDstout;
    wire RegWrout;
    wire [4:0] Rsout;
    wire [4:0] Rtout;
    wire Signout;
    wire [31:0] immout;
    wire [4:0] shamt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUFunin(ALUFunin),
        .ALUSrc1in(ALUSrc1in),
        .ALUSrc2in(ALUSrc2in),
        .DatabusAin(DatabusAin),
        .DatabusBin(DatabusBin),
        .MemRdin(MemRdin),
        .MemWrin(MemWrin),
        .MemtoRegin(MemtoRegin),
        .PCplusin(PCplusin),
        .RegDstin(RegDstin),
        .RegWrin(RegWrin),
        .Signin(Signin),
        .clk(clk),
        .datahazard(datahazard),
        .immin(immin),
        .instructionin(instructionin),
        .ALUFunout(ALUFunout),
        .ALUSrc1out(ALUSrc1out),
        .ALUSrc2out(ALUSrc2out),
        .DatabusAout(DatabusAout),
        .DatabusBout(DatabusBout),
        .MemRdout(MemRdout),
        .MemWrout(MemWrout),
        .MemtoRegout(MemtoRegout),
        .PCplusout(PCplusout),
        .Rdout(Rdout),
        .RegDstout(RegDstout),
        .RegWrout(RegWrout),
        .Rsout(Rsout),
        .Rtout(Rtout),
        .Signout(Signout),
        .immout(immout),
        .shamt(shamt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ALUFunin = 0;
            ALUSrc1in = 0;
            ALUSrc2in = 0;
            DatabusAin = 0;
            DatabusBin = 0;
            MemRdin = 0;
            MemWrin = 0;
            MemtoRegin = 0;
            PCplusin = 0;
            RegDstin = 0;
            RegWrin = 0;
            Signin = 0;
            datahazard = 0;
            immin = 0;
            instructionin = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Pass-through and Field Extraction", test_num);



            instructionin = 32'h02956820;
            DatabusAin = 32'hAAAA_BBBB;
            DatabusBin = 32'hCCCC_DDDD;
            immin = 32'h0000_1234;
            PCplusin = 32'h0000_0400;
            ALUFunin = 6'h20;
            ALUSrc1in = 0;
            ALUSrc2in = 0;
            MemRdin = 0;
            MemWrin = 0;
            MemtoRegin = 2'b00;
            RegDstin = 2'b01;
            RegWrin = 1;
            Signin = 0;
            datahazard = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(
                6'h20, 1'b0, 1'b0, 32'hAAAA_BBBB, 32'hCCCC_DDDD, 1'b0, 1'b0, 2'b00,
                32'h0000_0400, 5'h0D, 2'b01, 1'b1, 5'h14, 5'h15, 1'b0, 32'h0000_1234, 5'h00
            );
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Field Extraction (sll $t0, $s1, 4)", test_num);



            instructionin = 32'h00114100;
            DatabusAin = 32'h1111_2222;
            DatabusBin = 32'h3333_4444;
            immin = 32'hFFFF_0000;
            PCplusin = 32'h0000_0800;
            ALUFunin = 6'h00;
            ALUSrc1in = 1;
            ALUSrc2in = 1;
            MemRdin = 1;
            MemWrin = 0;
            MemtoRegin = 2'b10;
            RegDstin = 2'b00;
            RegWrin = 1;
            Signin = 1;
            datahazard = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(
                6'h00, 1'b1, 1'b1, 32'h1111_2222, 32'h3333_4444, 1'b1, 1'b0, 2'b10,
                32'h0000_0800, 5'h08, 2'b00, 1'b1, 5'h00, 5'h11, 1'b1, 32'hFFFF_0000, 5'h04
            );
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Hazard Handling", test_num);

            instructionin = 32'hFFFF_FFFF;
            DatabusAin = 32'h5555_6666;
            DatabusBin = 32'h7777_8888;
            immin = 32'h9999_AAAA;
            PCplusin = 32'hBBBB_CCCC;
            ALUFunin = 6'h3F;
            ALUSrc1in = 1;
            ALUSrc2in = 1;
            MemRdin = 1;
            MemWrin = 1;
            MemtoRegin = 2'b11;
            RegDstin = 2'b11;
            RegWrin = 1;
            Signin = 1;
            datahazard = 1;

            @(posedge clk);
            #2;



            #1;




            check_outputs(
                6'h00, 1'b0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0, 2'b00,
                32'h0, 5'h0, 2'b00, 1'b0, 5'h0, 5'h0, 1'b0, 32'h0, 5'h0
            );
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max boundary values", test_num);

            instructionin = 32'hFFFF_FFFF;
            DatabusAin = 32'hFFFF_FFFF;
            DatabusBin = 32'hFFFF_FFFF;
            immin = 32'hFFFF_FFFF;
            PCplusin = 32'hFFFF_FFFF;
            ALUFunin = 6'b111111;
            ALUSrc1in = 1;
            ALUSrc2in = 1;
            MemRdin = 1;
            MemWrin = 1;
            MemtoRegin = 2'b11;
            RegDstin = 2'b11;
            RegWrin = 1;
            Signin = 1;
            datahazard = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(
                6'b111111, 1'b1, 1'b1, 32'hFFFF_FFFF, 32'hFFFF_FFFF, 1'b1, 1'b1, 2'b11,
                32'hFFFF_FFFF, 5'b11111, 2'b11, 1'b1, 5'b11111, 5'b11111, 1'b1, 32'hFFFF_FFFF, 5'b11111
            );
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
        input [31:0] expected_DatabusAout;
        input [31:0] expected_DatabusBout;
        input expected_MemRdout;
        input expected_MemWrout;
        input [1:0] expected_MemtoRegout;
        input [31:0] expected_PCplusout;
        input [4:0] expected_Rdout;
        input [1:0] expected_RegDstout;
        input expected_RegWrout;
        input [4:0] expected_Rsout;
        input [4:0] expected_Rtout;
        input expected_Signout;
        input [31:0] expected_immout;
        input [4:0] expected_shamt;
        begin
            if (expected_ALUFunout === (expected_ALUFunout ^ ALUFunout ^ expected_ALUFunout) &&
                expected_ALUSrc1out === (expected_ALUSrc1out ^ ALUSrc1out ^ expected_ALUSrc1out) &&
                expected_ALUSrc2out === (expected_ALUSrc2out ^ ALUSrc2out ^ expected_ALUSrc2out) &&
                expected_DatabusAout === (expected_DatabusAout ^ DatabusAout ^ expected_DatabusAout) &&
                expected_DatabusBout === (expected_DatabusBout ^ DatabusBout ^ expected_DatabusBout) &&
                expected_MemRdout === (expected_MemRdout ^ MemRdout ^ expected_MemRdout) &&
                expected_MemWrout === (expected_MemWrout ^ MemWrout ^ expected_MemWrout) &&
                expected_MemtoRegout === (expected_MemtoRegout ^ MemtoRegout ^ expected_MemtoRegout) &&
                expected_PCplusout === (expected_PCplusout ^ PCplusout ^ expected_PCplusout) &&
                expected_Rdout === (expected_Rdout ^ Rdout ^ expected_Rdout) &&
                expected_RegDstout === (expected_RegDstout ^ RegDstout ^ expected_RegDstout) &&
                expected_RegWrout === (expected_RegWrout ^ RegWrout ^ expected_RegWrout) &&
                expected_Rsout === (expected_Rsout ^ Rsout ^ expected_Rsout) &&
                expected_Rtout === (expected_Rtout ^ Rtout ^ expected_Rtout) &&
                expected_Signout === (expected_Signout ^ Signout ^ expected_Signout) &&
                expected_immout === (expected_immout ^ immout ^ expected_immout) &&
                expected_shamt === (expected_shamt ^ shamt ^ expected_shamt)) begin
                $display("PASS");
                $display("  Outputs: ALUFunout=%h, ALUSrc1out=%b, ALUSrc2out=%b, DatabusAout=%h, DatabusBout=%h, MemRdout=%b, MemWrout=%b, MemtoRegout=%h, PCplusout=%h, Rdout=%h, RegDstout=%h, RegWrout=%b, Rsout=%h, Rtout=%h, Signout=%b, immout=%h, shamt=%h",
                         ALUFunout, ALUSrc1out, ALUSrc2out, DatabusAout, DatabusBout, MemRdout, MemWrout, MemtoRegout, PCplusout, Rdout, RegDstout, RegWrout, Rsout, Rtout, Signout, immout, shamt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUFunout=%h, ALUSrc1out=%b, ALUSrc2out=%b, DatabusAout=%h, DatabusBout=%h, MemRdout=%b, MemWrout=%b, MemtoRegout=%h, PCplusout=%h, Rdout=%h, RegDstout=%h, RegWrout=%b, Rsout=%h, Rtout=%h, Signout=%b, immout=%h, shamt=%h",
                         expected_ALUFunout, expected_ALUSrc1out, expected_ALUSrc2out, expected_DatabusAout, expected_DatabusBout, expected_MemRdout, expected_MemWrout, expected_MemtoRegout, expected_PCplusout, expected_Rdout, expected_RegDstout, expected_RegWrout, expected_Rsout, expected_Rtout, expected_Signout, expected_immout, expected_shamt);
                $display("  Got:      ALUFunout=%h, ALUSrc1out=%b, ALUSrc2out=%b, DatabusAout=%h, DatabusBout=%h, MemRdout=%b, MemWrout=%b, MemtoRegout=%h, PCplusout=%h, Rdout=%h, RegDstout=%h, RegWrout=%b, Rsout=%h, Rtout=%h, Signout=%b, immout=%h, shamt=%h",
                         ALUFunout, ALUSrc1out, ALUSrc2out, DatabusAout, DatabusBout, MemRdout, MemWrout, MemtoRegout, PCplusout, Rdout, RegDstout, RegWrout, Rsout, Rtout, Signout, immout, shamt);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ALUFunin, ALUSrc1in, ALUSrc2in, DatabusAin, DatabusBin, MemRdin, MemWrin, MemtoRegin, PCplusin, RegDstin, RegWrin, Signin, clk, datahazard, immin, instructionin, ALUFunout, ALUSrc1out, ALUSrc2out, DatabusAout, DatabusBout, MemRdout, MemWrout, MemtoRegout, PCplusout, Rdout, RegDstout, RegWrout, Rsout, Rtout, Signout, immout, shamt);
    end

endmodule
