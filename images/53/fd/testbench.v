`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] data;
    reg ena;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ena = 0;
            data = 12'h000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 12'h001;
            ena = 0;
            @(posedge clk);
            #1;
            ena = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h002);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 12'h800;
            ena = 0;
            @(posedge clk);
            #1;
            ena = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 12'h00F;
            ena = 0;
            @(posedge clk);
            #1;
            ena = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 12'hABC;
            ena = 0;
            @(posedge clk);
            #1;
            ena = 1;
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 12'hFFF;
            ena = 0;
            @(posedge clk);
            #1;
            ena = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF);
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, ena, q);
    end

endmodule
