`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUresultin;
    reg [1:0] MemtoRegin;
    reg [31:0] PCplusin;
    reg [4:0] Rdin;
    reg [1:0] RegDstin;
    reg RegWrin;
    reg [4:0] Rtin;
    reg clk;
    reg [31:0] rdatain;
    wire [31:0] ALUresultout;
    wire [1:0] MemtoRegout;
    wire [31:0] PCplusout;
    wire [4:0] Rdout;
    wire [1:0] RegDstout;
    wire RegWrout;
    wire [4:0] Rtout;
    wire [31:0] rdataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUresultin(ALUresultin),
        .MemtoRegin(MemtoRegin),
        .PCplusin(PCplusin),
        .Rdin(Rdin),
        .RegDstin(RegDstin),
        .RegWrin(RegWrin),
        .Rtin(Rtin),
        .clk(clk),
        .rdatain(rdatain),
        .ALUresultout(ALUresultout),
        .MemtoRegout(MemtoRegout),
        .PCplusout(PCplusout),
        .Rdout(Rdout),
        .RegDstout(RegDstout),
        .RegWrout(RegWrout),
        .Rtout(Rtout),
        .rdataout(rdataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ALUresultin = 32'b0;
            MemtoRegin = 2'b0;
            PCplusin = 32'b0;
            Rdin = 5'b0;
            RegDstin = 2'b0;
            RegWrin = 1'b0;
            Rtin = 5'b0;
            rdatain = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic functional check", test_num);


            ALUresultin = 32'hDEADBEEF;
            MemtoRegin = 2'b01;
            PCplusin = 32'h00400004;
            Rdin = 5'd10;
            RegDstin = 2'b10;
            RegWrin = 1'b1;
            Rtin = 5'd5;
            rdatain = 32'hCAFEBABE;


            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hDEADBEEF, 2'b01, 32'h00400004, 5'd10, 2'b10, 1'b1, 5'd5, 32'hCAFEBABE);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Boundary values (All 1s)", test_num);

            ALUresultin = 32'hFFFFFFFF;
            MemtoRegin = 2'b11;
            PCplusin = 32'hFFFFFFFF;
            Rdin = 5'b11111;
            RegDstin = 2'b11;
            RegWrin = 1'b1;
            Rtin = 5'b11111;
            rdatain = 32'hFFFFFFFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 2'b11, 32'hFFFFFFFF, 5'b11111, 2'b11, 1'b1, 5'b11111, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Transition and Timing Check", test_num);


            ALUresultin = 32'h11111111;
            RegWrin = 1'b1;
            @(posedge clk);
            #2;


            ALUresultin = 32'h22222222;
            RegWrin = 1'b0;
            #1;




            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h22222222, 2'b0, 32'b0, 5'b0, 2'b0, 1'b0, 5'b0, 32'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Alternating bit patterns", test_num);

            ALUresultin = 32'hAAAAAAAA;
            MemtoRegin = 2'b10;
            PCplusin = 32'h55555555;
            Rdin = 5'h15;
            RegDstin = 2'b01;
            RegWrin = 1'b1;
            Rtin = 5'h0A;
            rdatain = 32'hA5A5A5A5;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAAAAAA, 2'b10, 32'h55555555, 5'h15, 2'b01, 1'b1, 5'h0A, 32'hA5A5A5A5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Zero/Clear verification", test_num);


            ALUresultin = 32'hFFFFFFFF;
            @(posedge clk);
            #2;


            ALUresultin = 32'h0;
            MemtoRegin = 2'b0;
            PCplusin = 32'h0;
            Rdin = 5'h0;
            RegDstin = 2'b0;
            RegWrin = 1'b0;
            Rtin = 5'h0;
            rdatain = 32'h0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 2'b0, 32'h0, 5'h0, 2'b0, 1'b0, 5'h0, 32'h0);
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
        input [31:0] expected_ALUresultout;
        input [1:0] expected_MemtoRegout;
        input [31:0] expected_PCplusout;
        input [4:0] expected_Rdout;
        input [1:0] expected_RegDstout;
        input expected_RegWrout;
        input [4:0] expected_Rtout;
        input [31:0] expected_rdataout;
        begin
            if (expected_ALUresultout === (expected_ALUresultout ^ ALUresultout ^ expected_ALUresultout) &&
                expected_MemtoRegout === (expected_MemtoRegout ^ MemtoRegout ^ expected_MemtoRegout) &&
                expected_PCplusout === (expected_PCplusout ^ PCplusout ^ expected_PCplusout) &&
                expected_Rdout === (expected_Rdout ^ Rdout ^ expected_Rdout) &&
                expected_RegDstout === (expected_RegDstout ^ RegDstout ^ expected_RegDstout) &&
                expected_RegWrout === (expected_RegWrout ^ RegWrout ^ expected_RegWrout) &&
                expected_Rtout === (expected_Rtout ^ Rtout ^ expected_Rtout) &&
                expected_rdataout === (expected_rdataout ^ rdataout ^ expected_rdataout)) begin
                $display("PASS");
                $display("  Outputs: ALUresultout=%h, MemtoRegout=%h, PCplusout=%h, Rdout=%h, RegDstout=%h, RegWrout=%b, Rtout=%h, rdataout=%h",
                         ALUresultout, MemtoRegout, PCplusout, Rdout, RegDstout, RegWrout, Rtout, rdataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUresultout=%h, MemtoRegout=%h, PCplusout=%h, Rdout=%h, RegDstout=%h, RegWrout=%b, Rtout=%h, rdataout=%h",
                         expected_ALUresultout, expected_MemtoRegout, expected_PCplusout, expected_Rdout, expected_RegDstout, expected_RegWrout, expected_Rtout, expected_rdataout);
                $display("  Got:      ALUresultout=%h, MemtoRegout=%h, PCplusout=%h, Rdout=%h, RegDstout=%h, RegWrout=%b, Rtout=%h, rdataout=%h",
                         ALUresultout, MemtoRegout, PCplusout, Rdout, RegDstout, RegWrout, Rtout, rdataout);
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
        $dumpvars(0,ALUresultin, MemtoRegin, PCplusin, Rdin, RegDstin, RegWrin, Rtin, clk, rdatain, ALUresultout, MemtoRegout, PCplusout, Rdout, RegDstout, RegWrout, Rtout, rdataout);
    end

endmodule
