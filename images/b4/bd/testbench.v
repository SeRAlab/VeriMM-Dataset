`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg go;
    reg halt;
    wire en;
    wire [2:0] pattern;
    wire [17:0] sram_addr;
    wire we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .go(go),
        .halt(halt),
        .en(en),
        .pattern(pattern),
        .sram_addr(sram_addr),
        .we(we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            go = 0;
            halt = 0;
            @(posedge clk);
            #1;
            clr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset/Idle State Check");
            reset_dut();

            #1;


            check_outputs(0, 3'b000, 18'h00000, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Start Operation (Go)");
            reset_dut();
            go = 1;
            @(posedge clk);
            #1;
            go = 0;

            #1;


            check_outputs(1, 3'b000, 18'h00000, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Address Increment Check");
            reset_dut();
            go = 1;
            @(posedge clk);
            #1;
            go = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 3'b000, 18'h00005, 1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Halt Check");
            reset_dut();
            go = 1;
            @(posedge clk);
            #1;
            go = 0;
            repeat (2) @(posedge clk);
            #1;
            halt = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 3'b000, 18'h00002, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Resume After Halt");
            reset_dut();
            go = 1;
            @(posedge clk); #1; go = 0;
            repeat (2) @(posedge clk); #1;
            halt = 1;
            @(posedge clk); #1;
            halt = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(1, 3'b000, 18'h00003, 1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Clear During Operation");
            reset_dut();
            go = 1;
            @(posedge clk); #1; go = 0;
            repeat (10) @(posedge clk); #1;
            clr = 1;
            @(posedge clk); #1;
            clr = 0;

            #1;


            check_outputs(0, 3'b000, 18'h00000, 0);
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
        input expected_en;
        input [2:0] expected_pattern;
        input [17:0] expected_sram_addr;
        input expected_we;
        begin
            if (expected_en === (expected_en ^ en ^ expected_en) &&
                expected_pattern === (expected_pattern ^ pattern ^ expected_pattern) &&
                expected_sram_addr === (expected_sram_addr ^ sram_addr ^ expected_sram_addr) &&
                expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: en=%b, pattern=%h, sram_addr=%h, we=%b",
                         en, pattern, sram_addr, we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en=%b, pattern=%h, sram_addr=%h, we=%b",
                         expected_en, expected_pattern, expected_sram_addr, expected_we);
                $display("  Got:      en=%b, pattern=%h, sram_addr=%h, we=%b",
                         en, pattern, sram_addr, we);
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
        $dumpvars(0,clk, clr, go, halt, en, pattern, sram_addr, we);
    end

endmodule
