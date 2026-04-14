`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] cop_addr;
    reg [31:0] din;
    reg [31:0] ins;
    reg [31:0] npc_out;
    reg [4:0] regNum;
    reg [2:0] sel;
    reg [1:0] wEn;
    wire [31:0] cop_data;
    wire [31:0] dout;
    wire [31:0] expiaddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cop_addr(cop_addr),
        .din(din),
        .ins(ins),
        .npc_out(npc_out),
        .regNum(regNum),
        .sel(sel),
        .wEn(wEn),
        .cop_data(cop_data),
        .dout(dout),
        .expiaddr(expiaddr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        cop_addr = 5'b0;
        din = 32'b0;
        ins = 32'b0;
        npc_out = 32'b0;
        regNum = 5'b0;
        sel = 3'b0;
        wEn = 2'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Initial state check");

        #1;


        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Write to regular register via wEn[0]");
        regNum = 5'd5;
        din = 32'hDEADBEEF;
        wEn = 2'b01;
        @(posedge clk);
        #1;
        wEn = 2'b00;
        #1;

        check_outputs(32'h0, 32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Write to CP0 Status register (Reg 12)");
        regNum = 5'd12;
        sel = 3'd0;
        din = 32'h00000001;
        wEn = 2'b10;
        @(posedge clk);
        #1;
        wEn = 2'b00;
        #1;

        check_outputs(32'h0, 32'h00000001, 32'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: SYSCALL Exception Handling");
        ins = 32'h0000000c;
        npc_out = 32'h00400008;
        @(posedge clk);
        #1;


        regNum = 5'd14;
        sel = 3'd0;
        #1;

        check_outputs(32'h0, 32'h00400008, 32'h40000004);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Reading via cop_addr port");

        regNum = 5'd14;
        din = 32'h88887777;
        wEn = 2'b10;
        @(posedge clk);
        #1;
        wEn = 2'b00;
        cop_addr = 5'd14;
        #1;
        #1;

        check_outputs(32'h88887777, 32'h88887777, 32'h0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: ERET operation check");

        ins = 32'h0000000c;
        @(posedge clk);
        #1;

        ins = 32'h42000018;
        @(posedge clk);
        #1;
        ins = 0;

        #1;


        check_outputs(32'h0, 32'h0, 32'h0);
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
        input [31:0] expected_cop_data;
        input [31:0] expected_dout;
        input [31:0] expected_expiaddr;
        begin
            if (expected_cop_data === (expected_cop_data ^ cop_data ^ expected_cop_data) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_expiaddr === (expected_expiaddr ^ expiaddr ^ expected_expiaddr)) begin
                $display("PASS");
                $display("  Outputs: cop_data=%h, dout=%h, expiaddr=%h",
                         cop_data, dout, expiaddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cop_data=%h, dout=%h, expiaddr=%h",
                         expected_cop_data, expected_dout, expected_expiaddr);
                $display("  Got:      cop_data=%h, dout=%h, expiaddr=%h",
                         cop_data, dout, expiaddr);
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
        $dumpvars(0,clk, cop_addr, din, ins, npc_out, regNum, sel, wEn, cop_data, dout, expiaddr);
    end

endmodule
