`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    wire [11:0] Data_A;
    wire [11:0] Data_B;
    wire [11:0] Data_C;
    wire [11:0] Data_D;
    wire [11:0] Data_E;
    wire [11:0] Data_F;
    wire [11:0] Data_G;
    wire [11:0] Data_H;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .Data_A(Data_A),
        .Data_B(Data_B),
        .Data_C(Data_C),
        .Data_D(Data_D),
        .Data_E(Data_E),
        .Data_F(Data_F),
        .Data_G(Data_G),
        .Data_H(Data_H)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            @(posedge clk);
            #1 reset_n = 1;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(12'd0, 12'd1, 12'd2, 12'd3, 12'd4, 12'd5, 12'd6, 12'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Counter after 10 clock cycles", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd10, 12'd11, 12'd12, 12'd13, 12'd14, 12'd15, 12'd16, 12'd17);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Counter at max value 511", test_num);
            reset_dut();
            repeat(511) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd511, 12'd512, 12'd513, 12'd514, 12'd515, 12'd516, 12'd517, 12'd518);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Counter wrap around (512 cycles)", test_num);
            reset_dut();
            repeat(512) @(posedge clk);
            #1;

            #1;


            check_outputs(12'd0, 12'd1, 12'd2, 12'd3, 12'd4, 12'd5, 12'd6, 12'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multiple wrap arounds (1025 cycles)", test_num);
            reset_dut();
            repeat(1025) @(posedge clk);
            #1;

            #1;


            check_outputs(12'd1, 12'd2, 12'd3, 12'd4, 12'd5, 12'd6, 12'd7, 12'd8);
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
        input [11:0] expected_Data_A;
        input [11:0] expected_Data_B;
        input [11:0] expected_Data_C;
        input [11:0] expected_Data_D;
        input [11:0] expected_Data_E;
        input [11:0] expected_Data_F;
        input [11:0] expected_Data_G;
        input [11:0] expected_Data_H;
        begin
            if (expected_Data_A === (expected_Data_A ^ Data_A ^ expected_Data_A) &&
                expected_Data_B === (expected_Data_B ^ Data_B ^ expected_Data_B) &&
                expected_Data_C === (expected_Data_C ^ Data_C ^ expected_Data_C) &&
                expected_Data_D === (expected_Data_D ^ Data_D ^ expected_Data_D) &&
                expected_Data_E === (expected_Data_E ^ Data_E ^ expected_Data_E) &&
                expected_Data_F === (expected_Data_F ^ Data_F ^ expected_Data_F) &&
                expected_Data_G === (expected_Data_G ^ Data_G ^ expected_Data_G) &&
                expected_Data_H === (expected_Data_H ^ Data_H ^ expected_Data_H)) begin
                $display("PASS");
                $display("  Outputs: Data_A=%h, Data_B=%h, Data_C=%h, Data_D=%h, Data_E=%h, Data_F=%h, Data_G=%h, Data_H=%h",
                         Data_A, Data_B, Data_C, Data_D, Data_E, Data_F, Data_G, Data_H);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_A=%h, Data_B=%h, Data_C=%h, Data_D=%h, Data_E=%h, Data_F=%h, Data_G=%h, Data_H=%h",
                         expected_Data_A, expected_Data_B, expected_Data_C, expected_Data_D, expected_Data_E, expected_Data_F, expected_Data_G, expected_Data_H);
                $display("  Got:      Data_A=%h, Data_B=%h, Data_C=%h, Data_D=%h, Data_E=%h, Data_F=%h, Data_G=%h, Data_H=%h",
                         Data_A, Data_B, Data_C, Data_D, Data_E, Data_F, Data_G, Data_H);
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
        $dumpvars(0,clk, reset_n, Data_A, Data_B, Data_C, Data_D, Data_E, Data_F, Data_G, Data_H);
    end

endmodule
