`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_flush;
    reg [31:0] i_if_instr;
    reg [31:0] i_if_p4;
    reg [31:0] i_if_pc;
    reg i_resetn;
    reg i_we;
    wire [31:0] o_id_instr;
    wire [31:0] o_id_p4;
    wire [31:0] o_id_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_flush(i_flush),
        .i_if_instr(i_if_instr),
        .i_if_p4(i_if_p4),
        .i_if_pc(i_if_pc),
        .i_resetn(i_resetn),
        .i_we(i_we),
        .o_id_instr(o_id_instr),
        .o_id_p4(o_id_p4),
        .o_id_pc(o_id_pc)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

    begin
        i_resetn = 0;
        i_we = 0;
        i_flush = 0;
        i_if_p4 = 32'h0;
        i_if_pc = 32'h0;
        i_if_instr = 32'h0;
        #15;
        i_resetn = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Reset Check", test_num);
        reset_dut();


        #1;



        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Enable Capture", test_num);
        reset_dut();

        @(posedge i_clk);
        i_we = 1;
        i_if_pc = 32'h00001000;
        i_if_p4 = 32'h00001004;
        i_if_instr = 32'hDEADBEEF;

        @(posedge i_clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF, 32'h00001004, 32'h00001000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Enable Low (Stall)", test_num);
        reset_dut();


        @(posedge i_clk);
        i_we = 1;
        i_if_pc = 32'h00002000;
        i_if_p4 = 32'h00002004;
        i_if_instr = 32'h11223344;

        @(posedge i_clk);

        i_we = 0;
        i_if_pc = 32'hFFFFFFFF;
        i_if_p4 = 32'hFFFFFFFF;
        i_if_instr = 32'hFFFFFFFF;

        @(posedge i_clk);
        #1;

        #1;


        check_outputs(32'h11223344, 32'h00002004, 32'h00002000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Flush", test_num);
        reset_dut();


        @(posedge i_clk);
        i_we = 1;
        i_if_pc = 32'h00003000;
        i_if_p4 = 32'h00003004;
        i_if_instr = 32'hABCDEF01;

        @(posedge i_clk);

        i_flush = 1;

        @(posedge i_clk);
        #1;

        #1;


        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Flush Priority over Write Enable", test_num);
        reset_dut();

        @(posedge i_clk);
        i_we = 1;
        i_flush = 1;
        i_if_pc = 32'h00004000;
        i_if_p4 = 32'h00004004;
        i_if_instr = 32'h55667788;

        @(posedge i_clk);
        #1;

        #1;


        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Back-to-back Sequential Updates", test_num);
        reset_dut();

        @(posedge i_clk);
        i_we = 1;
        i_if_pc = 32'hA0; i_if_p4 = 32'hA4; i_if_instr = 32'hAAAA_AAAA;

        @(posedge i_clk);
        i_if_pc = 32'hB0; i_if_p4 = 32'hB4; i_if_instr = 32'hBBBB_BBBB;

        @(posedge i_clk);
        i_if_pc = 32'hC0; i_if_p4 = 32'hC4; i_if_instr = 32'hCCCC_CCCC;

        @(posedge i_clk);
        #1;

        #1;


        check_outputs(32'hCCCC_CCCC, 32'hC4, 32'hC0);
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
        input [31:0] expected_o_id_instr;
        input [31:0] expected_o_id_p4;
        input [31:0] expected_o_id_pc;
        begin
            if (expected_o_id_instr === (expected_o_id_instr ^ o_id_instr ^ expected_o_id_instr) &&
                expected_o_id_p4 === (expected_o_id_p4 ^ o_id_p4 ^ expected_o_id_p4) &&
                expected_o_id_pc === (expected_o_id_pc ^ o_id_pc ^ expected_o_id_pc)) begin
                $display("PASS");
                $display("  Outputs: o_id_instr=%h, o_id_p4=%h, o_id_pc=%h",
                         o_id_instr, o_id_p4, o_id_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_id_instr=%h, o_id_p4=%h, o_id_pc=%h",
                         expected_o_id_instr, expected_o_id_p4, expected_o_id_pc);
                $display("  Got:      o_id_instr=%h, o_id_p4=%h, o_id_pc=%h",
                         o_id_instr, o_id_p4, o_id_pc);
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
        $dumpvars(0,i_clk, i_flush, i_if_instr, i_if_p4, i_if_pc, i_resetn, i_we, o_id_instr, o_id_p4, o_id_pc);
    end

endmodule
