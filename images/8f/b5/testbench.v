`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BJ;
    reg clk;
    reg [31:0] if_instr;
    reg [31:0] if_pc;
    reg [31:0] if_pcplus4;
    reg rst;
    reg stall;
    wire [31:0] id_instr;
    wire [31:0] id_pc;
    wire [31:0] id_pcplus4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BJ(BJ),
        .clk(clk),
        .if_instr(if_instr),
        .if_pc(if_pc),
        .if_pcplus4(if_pcplus4),
        .rst(rst),
        .stall(stall),
        .id_instr(id_instr),
        .id_pc(id_pc),
        .id_pcplus4(id_pcplus4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            BJ = 0;
            stall = 0;
            if_instr = 32'h0;
            if_pc = 32'h0;
            if_pcplus4 = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Normal Data Propagation", test_num);

            if_instr = 32'hAABBCCDD;
            if_pc = 32'h00001000;
            if_pcplus4 = 32'h00001004;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAABBCCDD, 32'h00001000, 32'h00001004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Pipeline Stall", test_num);


            if_instr = 32'h11111111;
            if_pc = 32'h00002000;
            if_pcplus4 = 32'h00002004;
            @(posedge clk);
            #1;


            stall = 1;
            if_instr = 32'hEEEEEEEE;
            if_pc = 32'h00003000;
            if_pcplus4 = 32'h00003004;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h11111111, 32'h00002000, 32'h00002004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Branch/Jump Flush", test_num);

            BJ = 1;
            if_instr = 32'hADD01234;
            if_pc = 32'h00004000;
            if_pcplus4 = 32'h00004004;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: BJ and Stall Priority", test_num);


            if_instr = 32'h55555555;
            if_pc = 32'h00005000;
            if_pcplus4 = 32'h00005004;
            @(posedge clk);
            #1;


            stall = 1;
            BJ = 1;
            if_instr = 32'hFFFFFFFF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Multi-cycle Sequence", test_num);


            if_instr = 32'hAAAA_AAAA; if_pc = 32'hA0; if_pcplus4 = 32'hA4;
            @(posedge clk); #1;


            stall = 1;
            if_instr = 32'hBBBB_BBBB; if_pc = 32'hB0; if_pcplus4 = 32'hB4;
            @(posedge clk); #1;


            stall = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(32'hBBBB_BBBB, 32'hB0, 32'hB4);
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
        input [31:0] expected_id_instr;
        input [31:0] expected_id_pc;
        input [31:0] expected_id_pcplus4;
        begin
            if (expected_id_instr === (expected_id_instr ^ id_instr ^ expected_id_instr) &&
                expected_id_pc === (expected_id_pc ^ id_pc ^ expected_id_pc) &&
                expected_id_pcplus4 === (expected_id_pcplus4 ^ id_pcplus4 ^ expected_id_pcplus4)) begin
                $display("PASS");
                $display("  Outputs: id_instr=%h, id_pc=%h, id_pcplus4=%h",
                         id_instr, id_pc, id_pcplus4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id_instr=%h, id_pc=%h, id_pcplus4=%h",
                         expected_id_instr, expected_id_pc, expected_id_pcplus4);
                $display("  Got:      id_instr=%h, id_pc=%h, id_pcplus4=%h",
                         id_instr, id_pc, id_pcplus4);
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
        $dumpvars(0,BJ, clk, if_instr, if_pc, if_pcplus4, rst, stall, id_instr, id_pc, id_pcplus4);
    end

endmodule
