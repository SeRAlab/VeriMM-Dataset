`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] alu_out;
    reg clk;
    reg [1:0] ld_pc;
    reg [15:0] memdata;
    reg memload;
    reg reset;
    reg stall;
    reg [5:0] state;
    wire [15:0] forcast_pc;
    wire [15:0] inst;
    wire memapply;
    wire [15:0] npc;
    wire [15:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_out(alu_out),
        .clk(clk),
        .ld_pc(ld_pc),
        .memdata(memdata),
        .memload(memload),
        .reset(reset),
        .stall(stall),
        .state(state),
        .forcast_pc(forcast_pc),
        .inst(inst),
        .memapply(memapply),
        .npc(npc),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        stall = 0;
        state = 6'b0;
        memdata = 16'h0;
        memload = 0;
        ld_pc = 2'b00;
        alu_out = 16'h0;
        @(posedge clk);
        #1;
        reset = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset State");
        reset_dut();

        #1;


        check_outputs(16'h0001, 16'h0000, 1'b0, 16'h0001, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: PC Increment");
        reset_dut();
        ld_pc = 2'b00;
        stall = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0002, 16'h0000, 1'b0, 16'h0002, 16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: PC from ALU");
        reset_dut();
        alu_out = 16'h1234;
        ld_pc = 2'b01;
        stall = 0;
        @(posedge clk);
        #1;

        ld_pc = 2'b00;
        #1;
        #1;

        check_outputs(16'h1235, 16'h0000, 1'b0, 16'h1235, 16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: PC from Memory Data");
        reset_dut();
        memdata = 16'hABCD;
        ld_pc = 2'b10;
        stall = 0;
        @(posedge clk);
        #1;

        ld_pc = 2'b00;
        #1;
        #1;

        check_outputs(16'hABCE, 16'h0000, 1'b0, 16'hABCE, 16'hABCD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Stall PC Update");
        reset_dut();
        stall = 1;
        ld_pc = 2'b00;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0001, 16'h0000, 1'b0, 16'h0001, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Instruction Load and memapply");
        reset_dut();
        memdata = 16'h4321;
        memload = 1;
        state = 6'b000001;
        stall = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(16'h0002, 16'h4321, 1'b1, 16'h0002, 16'h0001);
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
        input [15:0] expected_forcast_pc;
        input [15:0] expected_inst;
        input expected_memapply;
        input [15:0] expected_npc;
        input [15:0] expected_pc;
        begin
            if (expected_forcast_pc === (expected_forcast_pc ^ forcast_pc ^ expected_forcast_pc) &&
                expected_inst === (expected_inst ^ inst ^ expected_inst) &&
                expected_memapply === (expected_memapply ^ memapply ^ expected_memapply) &&
                expected_npc === (expected_npc ^ npc ^ expected_npc) &&
                expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: forcast_pc=%h, inst=%h, memapply=%b, npc=%h, pc=%h",
                         forcast_pc, inst, memapply, npc, pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forcast_pc=%h, inst=%h, memapply=%b, npc=%h, pc=%h",
                         expected_forcast_pc, expected_inst, expected_memapply, expected_npc, expected_pc);
                $display("  Got:      forcast_pc=%h, inst=%h, memapply=%b, npc=%h, pc=%h",
                         forcast_pc, inst, memapply, npc, pc);
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
        $dumpvars(0,alu_out, clk, ld_pc, memdata, memload, reset, stall, state, forcast_pc, inst, memapply, npc, pc);
    end

endmodule
