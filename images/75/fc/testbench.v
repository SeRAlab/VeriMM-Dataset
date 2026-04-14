`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d_mux_1;
    reg reset;
    reg selpc;
    wire [14:0] pc_4;
    wire [14:0] pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_mux_1(d_mux_1),
        .reset(reset),
        .selpc(selpc),
        .pc_4(pc_4),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            selpc = 0;
            d_mux_1 = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset check");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(15'd4, 15'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single increment check");
            test_num = 2;
            reset_dut();
            selpc = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(15'd8, 15'd4);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple increments check");
            test_num = 3;
            reset_dut();
            selpc = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(15'd16, 15'd12);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load from d_mux_1 check");
            test_num = 4;
            reset_dut();
            selpc = 1;
            d_mux_1 = 32'h0000_1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(15'h1234 + 15'd4, 15'h1234);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load then increment check");
            test_num = 5;
            reset_dut();

            selpc = 1;
            d_mux_1 = 32'h0000_2000;
            @(posedge clk);

            #1 selpc = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(15'h2004 + 15'd4, 15'h2004);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bit truncation and wrap-around check");
            test_num = 6;
            reset_dut();
            selpc = 1;

            d_mux_1 = 32'hFFFF_7FFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(15'd3, 15'h7FFF);
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
        input [14:0] expected_pc_4;
        input [14:0] expected_pc_out;
        begin
            if (expected_pc_4 === (expected_pc_4 ^ pc_4 ^ expected_pc_4) &&
                expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out)) begin
                $display("PASS");
                $display("  Outputs: pc_4=%h, pc_out=%h",
                         pc_4, pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_4=%h, pc_out=%h",
                         expected_pc_4, expected_pc_out);
                $display("  Got:      pc_4=%h, pc_out=%h",
                         pc_4, pc_out);
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
        $dumpvars(0,clk, d_mux_1, reset, selpc, pc_4, pc_out);
    end

endmodule
