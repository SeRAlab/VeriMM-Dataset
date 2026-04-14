`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg load_enable;
    reg reset;
    wire [31:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load_enable(load_enable),
        .reset(reset),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load_enable = 0;
        data_in = 32'h0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset Check", test_num);
        reset_dut();


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Load Enable High", test_num);
        reset_dut();

        data_in = 32'hA5A5A5A5;
        load_enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Load Enable Low (Data Retention)", test_num);
        reset_dut();


        data_in = 32'h12345678;
        load_enable = 1;
        @(posedge clk);
        #1;


        load_enable = 0;
        data_in = 32'hFFFFFFFF;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Reset Priority over Load Enable", test_num);
        reset_dut();


        data_in = 32'hDEADBEEF;
        load_enable = 1;
        reset = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Load Full Bit Pattern", test_num);
        reset_dut();

        data_in = 32'hFFFFFFFF;
        load_enable = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Consecutive Loads", test_num);
        reset_dut();

        load_enable = 1;
        data_in = 32'h11111111;
        @(posedge clk);
        #1;
        data_in = 32'h22222222;
        @(posedge clk);
        #1;
        data_in = 32'h33333333;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h33333333);
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
        input [31:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, data_in, load_enable, reset, reg_out);
    end

endmodule
