`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IF_IDWrite_i;
    reg IF_IDflush_i;
    reg clk_i;
    reg [31:0] instr_i;
    reg [31:0] pc_i;
    reg rst_i;
    reg start_i;
    wire [31:0] instr_o;
    wire [31:0] pc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IF_IDWrite_i(IF_IDWrite_i),
        .IF_IDflush_i(IF_IDflush_i),
        .clk_i(clk_i),
        .instr_i(instr_i),
        .pc_i(pc_i),
        .rst_i(rst_i),
        .start_i(start_i),
        .instr_o(instr_o),
        .pc_o(pc_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 0;
            start_i = 0;
            IF_IDWrite_i = 0;
            IF_IDflush_i = 0;
            pc_i = 32'h0;
            instr_i = 32'h0;
            #15;
            rst_i = 1;
            start_i = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Write Operation", test_num);
            reset_dut();

            IF_IDWrite_i = 1;
            pc_i = 32'h0000_0004;
            instr_i = 32'h00A0_0013;

            @(posedge clk_i);
            #2;
            #1;

            check_outputs(32'h00A0_0013, 32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Disable (Stall)", test_num);
            reset_dut();


            IF_IDWrite_i = 1;
            pc_i = 32'h0000_0008;
            instr_i = 32'hDEAD_BEEF;
            @(posedge clk_i);
            #2;


            IF_IDWrite_i = 0;
            pc_i = 32'h0000_000C;
            instr_i = 32'hCAFE_BABE;
            @(posedge clk_i);
            #2;


            #1;



            check_outputs(32'hDEAD_BEEF, 32'h0000_0008);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Flush Logic", test_num);
            reset_dut();


            IF_IDWrite_i = 1;
            pc_i = 32'h0000_0010;
            instr_i = 32'h1234_5678;
            @(posedge clk_i);
            #2;


            IF_IDflush_i = 1;
            @(posedge clk_i);
            #2;


            #1;



            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Flush Priority over Write", test_num);
            reset_dut();


            IF_IDWrite_i = 1;
            IF_IDflush_i = 1;
            pc_i = 32'h0000_1000;
            instr_i = 32'hFFFF_FFFF;

            @(posedge clk_i);
            #2;


            #1;



            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Updates", test_num);
            reset_dut();

            IF_IDWrite_i = 1;

            pc_i = 32'h4; instr_i = 32'hA;
            @(posedge clk_i);
            #1;

            pc_i = 32'h8; instr_i = 32'hB;
            @(posedge clk_i);
            #1;

            pc_i = 32'hC; instr_i = 32'hC;
            @(posedge clk_i);
            #2;

            #1;


            check_outputs(32'hC, 32'hC);
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
        input [31:0] expected_instr_o;
        input [31:0] expected_pc_o;
        begin
            if (expected_instr_o === (expected_instr_o ^ instr_o ^ expected_instr_o) &&
                expected_pc_o === (expected_pc_o ^ pc_o ^ expected_pc_o)) begin
                $display("PASS");
                $display("  Outputs: instr_o=%h, pc_o=%h",
                         instr_o, pc_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr_o=%h, pc_o=%h",
                         expected_instr_o, expected_pc_o);
                $display("  Got:      instr_o=%h, pc_o=%h",
                         instr_o, pc_o);
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
        $dumpvars(0,IF_IDWrite_i, IF_IDflush_i, clk_i, instr_i, pc_i, rst_i, start_i, instr_o, pc_o);
    end

endmodule
