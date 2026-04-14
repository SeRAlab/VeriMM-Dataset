`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_A;
    reg [15:0] in_B;
    reg reset;
    reg select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_A(in_A),
        .in_B(in_B),
        .reset(reset),
        .select(select),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_A = 0;
            in_B = 0;
            select = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        in_A = 16'hFFFF;
        in_B = 16'hFFFF;
        select = 0;

        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        in_A = 16'h00AA;
        @(posedge clk);
        #1;
        in_A = 16'h00FF;
        select = 0;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        in_A = 16'h0055;
        @(posedge clk);
        #1;
        in_B = 16'h00FF;
        select = 1;


        #1;



        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        in_A = 16'h00F0;
        @(posedge clk);
        #1;
        in_A = 16'h000F;
        select = 0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        in_A = 16'h00CC;
        @(posedge clk);
        #1;
        in_A = 16'h0033;
        select = 0;

        #1;


        check_outputs(8'h00);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in_A, in_B, reset, select, out);
    end

endmodule
