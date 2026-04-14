`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [3:0] SSDdigitchoice;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .SSDdigitchoice(SSDdigitchoice)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            test_num = test_num + 1;
            $display("--- Testcase %03d ---", test_num);



            force dut.SSDdigitchoice = 4'b0111;
            @(posedge clk);
            #1;
            release dut.SSDdigitchoice;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'b1110);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1011);
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
        input [3:0] expected_SSDdigitchoice;
        begin
            if (expected_SSDdigitchoice === (expected_SSDdigitchoice ^ SSDdigitchoice ^ expected_SSDdigitchoice)) begin
                $display("PASS");
                $display("  Outputs: SSDdigitchoice=%h",
                         SSDdigitchoice);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SSDdigitchoice=%h",
                         expected_SSDdigitchoice);
                $display("  Got:      SSDdigitchoice=%h",
                         SSDdigitchoice);
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
        $dumpvars(0,clk, SSDdigitchoice);
    end

endmodule
