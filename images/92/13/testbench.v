`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I_clk;
    reg I_enable;
    reg [15:0] I_in;
    reg I_reset;
    reg I_write;
    wire [15:0] O_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_clk(I_clk),
        .I_enable(I_enable),
        .I_in(I_in),
        .I_reset(I_reset),
        .I_write(I_write),
        .O_out(O_out)
    );

    // Clock generation (10ns period)
    initial begin
        I_clk = 0;
        forever #5 I_clk = ~I_clk;
    end

        task reset_dut;

    begin
        I_reset = 1;
        I_enable = 0;
        I_write = 0;
        I_in = 0;
        @(posedge I_clk);
        #1 I_reset = 0;
        @(posedge I_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load Value (Write)", test_num);
        reset_dut();
        I_in = 16'hABCD;
        I_write = 1;
        I_enable = 1;
        @(posedge I_clk);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Increment Check (3 cycles)", test_num);
        reset_dut();
        I_enable = 1;
        I_write = 0;
        @(posedge I_clk);
        @(posedge I_clk);
        @(posedge I_clk);
        #1;
        #1;

        check_outputs(16'h0006);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable Gating Check", test_num);
        reset_dut();
        I_enable = 0;
        I_write = 0;
        @(posedge I_clk);
        @(posedge I_clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load followed by Increment", test_num);
        reset_dut();

        I_in = 16'h1000;
        I_write = 1;
        I_enable = 1;
        @(posedge I_clk);

        #1 I_write = 0;
        @(posedge I_clk);
        #1;
        #1;

        check_outputs(16'h1002);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overflow Increment Check", test_num);
        reset_dut();

        I_in = 16'hFFFE;
        I_write = 1;
        I_enable = 1;
        @(posedge I_clk);

        #1 I_write = 0;
        @(posedge I_clk);
        #1;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_O_out;
        begin
            if (expected_O_out === (expected_O_out ^ O_out ^ expected_O_out)) begin
                $display("PASS");
                $display("  Outputs: O_out=%h",
                         O_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_out=%h",
                         expected_O_out);
                $display("  Got:      O_out=%h",
                         O_out);
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
        $dumpvars(0,I_clk, I_enable, I_in, I_reset, I_write, O_out);
    end

endmodule
