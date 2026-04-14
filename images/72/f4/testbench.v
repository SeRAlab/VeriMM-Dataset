`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] A3Win;
    reg [31:0] Datain;
    reg MemtoRegin;
    reg [31:0] PCin;
    reg RegWritein;
    reg [31:0] aluoutin;
    reg clk;
    reg [1:0] res_Win;
    wire [4:0] A3Wout;
    wire [31:0] Dataout;
    wire MemtoRegout;
    wire [31:0] PCout;
    wire RegWriteout;
    wire [31:0] aluoutout;
    wire [1:0] res_Wout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A3Win(A3Win),
        .Datain(Datain),
        .MemtoRegin(MemtoRegin),
        .PCin(PCin),
        .RegWritein(RegWritein),
        .aluoutin(aluoutin),
        .clk(clk),
        .res_Win(res_Win),
        .A3Wout(A3Wout),
        .Dataout(Dataout),
        .MemtoRegout(MemtoRegout),
        .PCout(PCout),
        .RegWriteout(RegWriteout),
        .aluoutout(aluoutout),
        .res_Wout(res_Wout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A3Win = 0;
            Datain = 0;
            MemtoRegin = 0;
            PCin = 0;
            RegWritein = 0;
            aluoutin = 0;
            res_Win = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            A3Win = 5'h0A;
            Datain = 32'h12345678;
            MemtoRegin = 1'b1;
            PCin = 32'h000000A0;
            RegWritein = 1'b1;
            aluoutin = 32'h87654321;
            res_Win = 2'b01;

            @(posedge clk);
            #2;

            $display("Test Case 001: Basic Data Transfer");
            #1;

            check_outputs(5'h0A, 32'h12345678, 1'b1, 32'h000000A0, 1'b1, 32'h87654321, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            A3Win = 5'b0;
            Datain = 32'b0;
            MemtoRegin = 1'b0;
            PCin = 32'b0;
            RegWritein = 1'b0;
            aluoutin = 32'b0;
            res_Win = 2'b0;

            @(posedge clk);
            #2;

            $display("Test Case 002: Zero Data Transfer");
            #1;

            check_outputs(5'b0, 32'b0, 1'b0, 32'b0, 1'b0, 32'b0, 2'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            A3Win = 5'h1F;
            Datain = 32'hFFFFFFFF;
            MemtoRegin = 1'b1;
            PCin = 32'hFFFFFFFF;
            RegWritein = 1'b1;
            aluoutin = 32'hFFFFFFFF;
            res_Win = 2'b11;

            @(posedge clk);
            #2;

            $display("Test Case 003: Maximum Value Transfer");
            #1;

            check_outputs(5'h1F, 32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            A3Win = 5'h0A;
            Datain = 32'hAAAAAAAA;
            MemtoRegin = 1'b0;
            PCin = 32'hAAAAAAAA;
            RegWritein = 1'b1;
            aluoutin = 32'hAAAAAAAA;
            res_Win = 2'b10;

            @(posedge clk);
            #2;

            $display("Test Case 004: Pattern 0xAAAAAAAA");
            #1;

            check_outputs(5'h0A, 32'hAAAAAAAA, 1'b0, 32'hAAAAAAAA, 1'b1, 32'hAAAAAAAA, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            A3Win = 5'h15;
            Datain = 32'h55555555;
            MemtoRegin = 1'b1;
            PCin = 32'h55555555;
            RegWritein = 1'b0;
            aluoutin = 32'h55555555;
            res_Win = 2'b01;

            @(posedge clk);
            #2;

            $display("Test Case 005: Pattern 0x55555555");
            #1;

            check_outputs(5'h15, 32'h55555555, 1'b1, 32'h55555555, 1'b0, 32'h55555555, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            A3Win = 5'h01; Datain = 32'h1; PCin = 32'h10;
            @(posedge clk);
            #1;


            A3Win = 5'h02; Datain = 32'h2; PCin = 32'h20;
            @(posedge clk);
            #2;

            $display("Test Case 006: Multi-cycle Update");

            #1;


            check_outputs(5'h02, 32'h00000002, 0, 32'h00000020, 0, 0, 0);
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
        input [4:0] expected_A3Wout;
        input [31:0] expected_Dataout;
        input expected_MemtoRegout;
        input [31:0] expected_PCout;
        input expected_RegWriteout;
        input [31:0] expected_aluoutout;
        input [1:0] expected_res_Wout;
        begin
            if (expected_A3Wout === (expected_A3Wout ^ A3Wout ^ expected_A3Wout) &&
                expected_Dataout === (expected_Dataout ^ Dataout ^ expected_Dataout) &&
                expected_MemtoRegout === (expected_MemtoRegout ^ MemtoRegout ^ expected_MemtoRegout) &&
                expected_PCout === (expected_PCout ^ PCout ^ expected_PCout) &&
                expected_RegWriteout === (expected_RegWriteout ^ RegWriteout ^ expected_RegWriteout) &&
                expected_aluoutout === (expected_aluoutout ^ aluoutout ^ expected_aluoutout) &&
                expected_res_Wout === (expected_res_Wout ^ res_Wout ^ expected_res_Wout)) begin
                $display("PASS");
                $display("  Outputs: A3Wout=%h, Dataout=%h, MemtoRegout=%b, PCout=%h, RegWriteout=%b, aluoutout=%h, res_Wout=%h",
                         A3Wout, Dataout, MemtoRegout, PCout, RegWriteout, aluoutout, res_Wout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A3Wout=%h, Dataout=%h, MemtoRegout=%b, PCout=%h, RegWriteout=%b, aluoutout=%h, res_Wout=%h",
                         expected_A3Wout, expected_Dataout, expected_MemtoRegout, expected_PCout, expected_RegWriteout, expected_aluoutout, expected_res_Wout);
                $display("  Got:      A3Wout=%h, Dataout=%h, MemtoRegout=%b, PCout=%h, RegWriteout=%b, aluoutout=%h, res_Wout=%h",
                         A3Wout, Dataout, MemtoRegout, PCout, RegWriteout, aluoutout, res_Wout);
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
        $dumpvars(0,A3Win, Datain, MemtoRegin, PCin, RegWritein, aluoutin, clk, res_Win, A3Wout, Dataout, MemtoRegout, PCout, RegWriteout, aluoutout, res_Wout);
    end

endmodule
