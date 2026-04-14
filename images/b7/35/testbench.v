`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] immediate;
    reg pb_clk_debounced;
    reg rst_general;
    reg [7:0] take_branch;
    wire [7:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .immediate(immediate),
        .pb_clk_debounced(pb_clk_debounced),
        .rst_general(rst_general),
        .take_branch(take_branch),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        pb_clk_debounced = 0;
        forever #5 pb_clk_debounced = ~pb_clk_debounced;
    end

        task reset_dut;

        begin
            rst_general = 1;
            immediate = 0;
            take_branch = 0;
            @(posedge pb_clk_debounced);
            #1;
            rst_general = 0;
            @(posedge pb_clk_debounced);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial Reset...");
            reset_dut();


            #1;



            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Normal Increment...");
            reset_dut();
            repeat(4) @(posedge pb_clk_debounced);
            #1;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Simple Branching...");
            reset_dut();
            immediate = 8'd15;
            take_branch = 8'hFF;
            @(posedge pb_clk_debounced);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Increment then Branch...");
            reset_dut();
            repeat(2) @(posedge pb_clk_debounced);
            immediate = 8'd10;
            take_branch = 8'h01;
            @(posedge pb_clk_debounced);
            #1;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: 8-bit Overflow...");
            reset_dut();
            immediate = 8'd250;
            take_branch = 8'hFF;
            @(posedge pb_clk_debounced);
            take_branch = 0;
            repeat(10) @(posedge pb_clk_debounced);
            #1;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Branch Overflow...");
            reset_dut();
            immediate = 8'd200;
            take_branch = 8'hFF;
            @(posedge pb_clk_debounced);
            immediate = 8'd100;
            @(posedge pb_clk_debounced);
            #1;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Reset Priority...");
            reset_dut();
            repeat(5) @(posedge pb_clk_debounced);
            immediate = 8'd50;
            take_branch = 8'hFF;
            rst_general = 1;
            @(posedge pb_clk_debounced);
            #1;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_pc;
        begin
            if (expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: pc=%h",
                         pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc=%h",
                         expected_pc);
                $display("  Got:      pc=%h",
                         pc);
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
        $dumpvars(0,immediate, pb_clk_debounced, rst_general, take_branch, pc);
    end

endmodule
