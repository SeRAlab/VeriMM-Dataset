`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] DATA;
    reg [7:0] I_char;
    reg LD_KBSR;
    reg LD_char;
    reg RD_KBDR;
    reg clk;
    reg reset;
    wire [15:0] KBDR;
    wire [15:0] KBSR;
    wire KB_INT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA(DATA),
        .I_char(I_char),
        .LD_KBSR(LD_KBSR),
        .LD_char(LD_char),
        .RD_KBDR(RD_KBDR),
        .clk(clk),
        .reset(reset),
        .KBDR(KBDR),
        .KBSR(KBSR),
        .KB_INT(KB_INT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            DATA = 0;
            I_char = 0;
            LD_KBSR = 0;
            LD_char = 0;
            RD_KBDR = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge clk);
            I_char = 8'h41;
            LD_char = 1;
            @(negedge clk);
            LD_char = 0;
            #5;

            #1;


            check_outputs(16'h0041, 16'h8000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            I_char = 8'h5A;
            LD_char = 1;
            @(negedge clk);
            LD_char = 0;
            RD_KBDR = 1;
            @(negedge clk);
            RD_KBDR = 0;
            #5;

            #1;


            check_outputs(16'h005A, 16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            DATA = 16'h4000;
            LD_KBSR = 1;
            @(negedge clk);
            LD_KBSR = 0;
            I_char = 8'h62;
            LD_char = 1;
            @(negedge clk);
            LD_char = 0;
            #5;

            #1;


            check_outputs(16'h0062, 16'hC000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            I_char = 8'h21;
            LD_char = 1;
            @(negedge clk);
            LD_char = 0;
            DATA = 16'h4000;
            LD_KBSR = 1;
            @(negedge clk);
            LD_KBSR = 0;
            #5;
            #1;

            check_outputs(16'h0021, 16'hC000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clk);
            I_char = 8'hFF;
            LD_char = 1;
            DATA = 16'h4000;
            LD_KBSR = 1;
            @(negedge clk);
            reset = 1;
            #20;
            reset = 0;
            #5;
            #1;

            check_outputs(16'h0000, 16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            DATA = 16'h4000;
            LD_KBSR = 1;
            I_char = 8'h31;
            LD_char = 1;
            @(negedge clk);
            LD_char = 0;
            DATA = 16'h0000;
            @(negedge clk);
            LD_KBSR = 0;
            #5;
            #1;

            check_outputs(16'h0031, 16'h8000, 1'b0);
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
        input [15:0] expected_KBDR;
        input [15:0] expected_KBSR;
        input expected_KB_INT;
        begin
            if (expected_KBDR === (expected_KBDR ^ KBDR ^ expected_KBDR) &&
                expected_KBSR === (expected_KBSR ^ KBSR ^ expected_KBSR) &&
                expected_KB_INT === (expected_KB_INT ^ KB_INT ^ expected_KB_INT)) begin
                $display("PASS");
                $display("  Outputs: KBDR=%h, KBSR=%h, KB_INT=%b",
                         KBDR, KBSR, KB_INT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: KBDR=%h, KBSR=%h, KB_INT=%b",
                         expected_KBDR, expected_KBSR, expected_KB_INT);
                $display("  Got:      KBDR=%h, KBSR=%h, KB_INT=%b",
                         KBDR, KBSR, KB_INT);
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
        $dumpvars(0,DATA, I_char, LD_KBSR, LD_char, RD_KBDR, clk, reset, KBDR, KBSR, KB_INT);
    end

endmodule
