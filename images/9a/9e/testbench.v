`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ALUOut;
    reg [31:0] ConBA;
    reg [31:0] DatabusA;
    reg [25:0] JT;
    reg [2:0] PCSrc;
    reg clk;
    reg datahazard;
    reg reset;
    wire [31:0] PC;
    wire [31:0] PCplusout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOut(ALUOut),
        .ConBA(ConBA),
        .DatabusA(DatabusA),
        .JT(JT),
        .PCSrc(PCSrc),
        .clk(clk),
        .datahazard(datahazard),
        .reset(reset),
        .PC(PC),
        .PCplusout(PCplusout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            datahazard = 0;
            PCSrc = 3'b000;
            ALUOut = 0;
            ConBA = 32'h0;
            DatabusA = 32'h0;
            JT = 26'h0;
            @(posedge clk);
            #2 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge clk);
            #2 #1;
 check_outputs(32'h00000000, 32'h00000004);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            PCSrc = 3'b000;
            @(posedge clk);
            @(posedge clk);
            #2 #1;
 check_outputs(32'h00000004, 32'h00000008);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            PCSrc = 3'b000;
            @(posedge clk);
            #1 datahazard = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'h00000000, 32'h00000004);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            PCSrc = 3'b001;
            ConBA = 32'h0000ABCD;
            @(posedge clk);
            @(posedge clk);
            #2 #1;
 check_outputs(32'h0000ABCD, 32'h0000ABD1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            PCSrc = 3'b010;
            DatabusA = 32'h12345678;
            @(posedge clk);
            @(posedge clk);
            #2 #1;
 check_outputs(32'h12345678, 32'h1234567C);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            PCSrc = 3'b011;
            JT = 26'h0000001;


            @(posedge clk);
            @(posedge clk);
            #2 #1;
 check_outputs(32'h00000004, 32'h00000008);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            PCSrc = 3'b000;
            @(posedge clk);
            @(posedge clk);
            datahazard = 1;
            @(posedge clk);
            #1 datahazard = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(32'h00000008, 32'h0000000C);
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
        input [31:0] expected_PC;
        input [31:0] expected_PCplusout;
        begin
            if (expected_PC === (expected_PC ^ PC ^ expected_PC) &&
                expected_PCplusout === (expected_PCplusout ^ PCplusout ^ expected_PCplusout)) begin
                $display("PASS");
                $display("  Outputs: PC=%h, PCplusout=%h",
                         PC, PCplusout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC=%h, PCplusout=%h",
                         expected_PC, expected_PCplusout);
                $display("  Got:      PC=%h, PCplusout=%h",
                         PC, PCplusout);
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
        $dumpvars(0,ALUOut, ConBA, DatabusA, JT, PCSrc, clk, datahazard, reset, PC, PCplusout);
    end

endmodule
