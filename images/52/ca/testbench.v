`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg SW2;
    reg clk;
    reg rst;
    wire Clk_CPU;
    wire [31:0] clkdiv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW2(SW2),
        .clk(clk),
        .rst(rst),
        .Clk_CPU(Clk_CPU),
        .clkdiv(clkdiv)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            SW2 = 0;
            #20;
            @(posedge clk);
            #2 rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking counter and Clk_CPU (SW2=0) after 4 cycles...", test_num);
            reset_dut();
            SW2 = 0;
            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking counter and Clk_CPU (SW2=1) after 2 cycles...", test_num);
            reset_dut();
            SW2 = 1;
            repeat(2) @(posedge clk);
            #2;



            #1;




            check_outputs(1'b0, 32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking counter after 15 cycles...", test_num);
            reset_dut();
            SW2 = 0;
            repeat(15) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h0000000F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking SW2 toggle after 1 cycle...", test_num);
            reset_dut();
            @(posedge clk);
            #1 SW2 = 1;
            #1;

            #1;


            check_outputs(1'b1, 32'h00000001);
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
        input expected_Clk_CPU;
        input [31:0] expected_clkdiv;
        begin
            if (expected_Clk_CPU === (expected_Clk_CPU ^ Clk_CPU ^ expected_Clk_CPU) &&
                expected_clkdiv === (expected_clkdiv ^ clkdiv ^ expected_clkdiv)) begin
                $display("PASS");
                $display("  Outputs: Clk_CPU=%b, clkdiv=%h",
                         Clk_CPU, clkdiv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Clk_CPU=%b, clkdiv=%h",
                         expected_Clk_CPU, expected_clkdiv);
                $display("  Got:      Clk_CPU=%b, clkdiv=%h",
                         Clk_CPU, clkdiv);
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
        $dumpvars(0,SW2, clk, rst, Clk_CPU, clkdiv);
    end

endmodule
