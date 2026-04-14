`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ifClear;
    reg ifkeep;
    reg [15:0] instr_in;
    reg [15:0] pc_in;
    reg rst;
    wire [15:0] instr_out;
    wire [15:0] pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ifClear(ifClear),
        .ifkeep(ifkeep),
        .instr_in(instr_in),
        .pc_in(pc_in),
        .rst(rst),
        .instr_out(instr_out),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ifClear = 0;
            ifkeep = 0;
            pc_in = 16'h0000;
            instr_in = 16'h0000;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Reset and Initialization");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Normal Data Capture");
            test_num = 2;
            reset_dut();

            pc_in = 16'h1234;
            instr_in = 16'hABCD;
            ifkeep = 0;
            ifClear = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hABCD, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Maintain State with ifkeep (Stall)");
            test_num = 3;
            reset_dut();


            pc_in = 16'hA0A0;
            instr_in = 16'hB0B0;
            @(posedge clk);
            #2;


            ifkeep = 1;
            pc_in = 16'hFFFF;
            instr_in = 16'hFFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hB0B0, 16'hA0A0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Synchronous Clear with ifClear (Flush)");
            test_num = 4;
            reset_dut();


            pc_in = 16'h8888;
            instr_in = 16'h9999;
            @(posedge clk);
            #2;


            ifClear = 1;
            pc_in = 16'h1111;
            instr_in = 16'h2222;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Priority Test - ifClear over ifkeep");
            test_num = 5;
            reset_dut();


            pc_in = 16'h5555;
            instr_in = 16'h6666;
            @(posedge clk);
            #2;



            ifClear = 1;
            ifkeep = 1;
            pc_in = 16'hAAAA;
            instr_in = 16'hBBBB;
            @(posedge clk);
            #2;



            #1;




            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Continuous Operation");
            test_num = 6;
            reset_dut();

            pc_in = 16'h0001; instr_in = 16'hE001;
            @(posedge clk); #2;
            pc_in = 16'h0002; instr_in = 16'hE002;
            @(posedge clk); #2;
            pc_in = 16'h0003; instr_in = 16'hE003;
            @(posedge clk); #2;


            #1;



            check_outputs(16'hE003, 16'h0003);
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
        input [15:0] expected_instr_out;
        input [15:0] expected_pc_out;
        begin
            if (expected_instr_out === (expected_instr_out ^ instr_out ^ expected_instr_out) &&
                expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out)) begin
                $display("PASS");
                $display("  Outputs: instr_out=%h, pc_out=%h",
                         instr_out, pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr_out=%h, pc_out=%h",
                         expected_instr_out, expected_pc_out);
                $display("  Got:      instr_out=%h, pc_out=%h",
                         instr_out, pc_out);
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
        $dumpvars(0,clk, ifClear, ifkeep, instr_in, pc_in, rst, instr_out, pc_out);
    end

endmodule
