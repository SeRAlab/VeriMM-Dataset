`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dac_clk;
    wire [9:0] dac_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dac_clk(dac_clk),
        .dac_data(dac_data)
    );

    // Clock generation (10ns period)
    initial begin
        dac_clk = 0;
        forever #5 dac_clk = ~dac_clk;
    end

        task reset_dut;

        begin


            $display("System stabilized...");
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking initial 10 clock cycles...", test_num);
            reset_dut();
            repeat(10) @(posedge dac_clk);
            total_edges = total_edges + 10;
            #1;
            #1;

            check_outputs(total_edges[9:0]);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking rollover at 1024 edges...", test_num);
            reset_dut();

            repeat(1014) @(posedge dac_clk);
            total_edges = total_edges + 1014;
            #1;
            #1;

            check_outputs(total_edges[9:0]);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking value 1025...", test_num);
            reset_dut();
            repeat(1) @(posedge dac_clk);
            total_edges = total_edges + 1;
            #1;
            #1;

            check_outputs(total_edges[9:0]);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking second rollover at 2048...", test_num);
            reset_dut();
            repeat(1023) @(posedge dac_clk);
            total_edges = total_edges + 1023;
            #1;
            #1;

            check_outputs(total_edges[9:0]);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking value 512 (mid-ramp)...", test_num);
            reset_dut();
            repeat(512) @(posedge dac_clk);
            total_edges = total_edges + 512;
            #1;
            #1;

            check_outputs(total_edges[9:0]);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking wrap-around of the full 16-bit internal counter...", test_num);
            reset_dut();


            repeat(65536) @(posedge dac_clk);
            total_edges = total_edges + 65536;
            #1;
            #1;

            check_outputs(total_edges[9:0]);
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
        input [9:0] expected_dac_data;
        begin
            if (expected_dac_data === (expected_dac_data ^ dac_data ^ expected_dac_data)) begin
                $display("PASS");
                $display("  Outputs: dac_data=%h",
                         dac_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_data=%h",
                         expected_dac_data);
                $display("  Got:      dac_data=%h",
                         dac_data);
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
        $dumpvars(0,dac_clk, dac_data);
    end

endmodule
