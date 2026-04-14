`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] ACC_next;
    reg Clk;
    reg [15:0] IR_next;
    reg [7:0] MAR_next;
    reg [15:0] MDR_next;
    reg [7:0] PC_next;
    reg Rst;
    reg Zflag_next;
    wire [15:0] ACC_reg;
    wire [15:0] IR_reg;
    wire [7:0] MAR_reg;
    wire [15:0] MDR_reg;
    wire [7:0] PC_reg;
    wire Zflag_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACC_next(ACC_next),
        .Clk(Clk),
        .IR_next(IR_next),
        .MAR_next(MAR_next),
        .MDR_next(MDR_next),
        .PC_next(PC_next),
        .Rst(Rst),
        .Zflag_next(Zflag_next),
        .ACC_reg(ACC_reg),
        .IR_reg(IR_reg),
        .MAR_reg(MAR_reg),
        .MDR_reg(MDR_reg),
        .PC_reg(PC_reg),
        .Zflag_reg(Zflag_reg)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Rst = 1;
        ACC_next = 0;
        IR_next = 0;
        MAR_next = 0;
        MDR_next = 0;
        PC_next = 0;
        Zflag_next = 0;
        #15;
        Rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        PC_next    = 8'h12;
        IR_next    = 16'hABCD;
        ACC_next   = 16'h55AA;
        MDR_next   = 16'hE0E0;
        MAR_next   = 8'hF0;
        Zflag_next = 1'b1;


        @(posedge Clk);
        #2;

        $display("Testcase 001: Basic Update");
        #1;

        check_outputs(16'h55AA, 16'hABCD, 8'hF0, 16'hE0E0, 8'h12, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        PC_next    = 8'hFF;
        IR_next    = 16'hFFFF;
        ACC_next   = 16'hFFFF;
        MDR_next   = 16'hFFFF;
        MAR_next   = 8'hFF;
        Zflag_next = 1'b1;

        @(posedge Clk);
        #2;

        $display("Testcase 002: Maximum Values");
        #1;

        check_outputs(16'hFFFF, 16'hFFFF, 8'hFF, 16'hFFFF, 8'hFF, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        PC_next    = 8'h01;
        IR_next    = 16'h1111;
        ACC_next   = 16'hAAAA;
        MDR_next   = 16'hBBBB;
        MAR_next   = 8'h11;
        Zflag_next = 1'b0;
        @(posedge Clk);


        PC_next    = 8'h02;
        IR_next    = 16'h2222;
        ACC_next   = 16'hCCCC;
        MDR_next   = 16'hDDDD;
        MAR_next   = 8'h22;
        Zflag_next = 1'b1;
        @(posedge Clk);
        #2;

        $display("Testcase 003: Sequential Updates");
        #1;

        check_outputs(16'hCCCC, 16'h2222, 8'h22, 16'hDDDD, 8'h02, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        PC_next    = 8'hA5;
        IR_next    = 16'hDEAD;
        ACC_next   = 16'hBEEF;
        MDR_next   = 16'h1234;
        MAR_next   = 8'h44;
        Zflag_next = 1'b1;
        @(posedge Clk);
        #2;


        Rst = 1;
        #3;

        $display("Testcase 004: Asynchronous Reset Mid-Operation");
        #1;

        check_outputs(16'h0000, 16'h0000, 8'h00, 16'h0000, 8'h00, 1'b0);
        Rst = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        PC_next    = 8'hAA;
        IR_next    = 16'h5555;
        ACC_next   = 16'hAAAA;
        MDR_next   = 16'h5555;
        MAR_next   = 8'hAA;
        Zflag_next = 1'b0;

        @(posedge Clk);
        #2;

        $display("Testcase 005: Alternating Bit Patterns");
        #1;

        check_outputs(16'hAAAA, 16'h5555, 8'hAA, 16'h5555, 8'hAA, 1'b0);
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
        input [15:0] expected_ACC_reg;
        input [15:0] expected_IR_reg;
        input [7:0] expected_MAR_reg;
        input [15:0] expected_MDR_reg;
        input [7:0] expected_PC_reg;
        input expected_Zflag_reg;
        begin
            if (expected_ACC_reg === (expected_ACC_reg ^ ACC_reg ^ expected_ACC_reg) &&
                expected_IR_reg === (expected_IR_reg ^ IR_reg ^ expected_IR_reg) &&
                expected_MAR_reg === (expected_MAR_reg ^ MAR_reg ^ expected_MAR_reg) &&
                expected_MDR_reg === (expected_MDR_reg ^ MDR_reg ^ expected_MDR_reg) &&
                expected_PC_reg === (expected_PC_reg ^ PC_reg ^ expected_PC_reg) &&
                expected_Zflag_reg === (expected_Zflag_reg ^ Zflag_reg ^ expected_Zflag_reg)) begin
                $display("PASS");
                $display("  Outputs: ACC_reg=%h, IR_reg=%h, MAR_reg=%h, MDR_reg=%h, PC_reg=%h, Zflag_reg=%b",
                         ACC_reg, IR_reg, MAR_reg, MDR_reg, PC_reg, Zflag_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACC_reg=%h, IR_reg=%h, MAR_reg=%h, MDR_reg=%h, PC_reg=%h, Zflag_reg=%b",
                         expected_ACC_reg, expected_IR_reg, expected_MAR_reg, expected_MDR_reg, expected_PC_reg, expected_Zflag_reg);
                $display("  Got:      ACC_reg=%h, IR_reg=%h, MAR_reg=%h, MDR_reg=%h, PC_reg=%h, Zflag_reg=%b",
                         ACC_reg, IR_reg, MAR_reg, MDR_reg, PC_reg, Zflag_reg);
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
        $dumpvars(0,ACC_next, Clk, IR_next, MAR_next, MDR_next, PC_next, Rst, Zflag_next, ACC_reg, IR_reg, MAR_reg, MDR_reg, PC_reg, Zflag_reg);
    end

endmodule
