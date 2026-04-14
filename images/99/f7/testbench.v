`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in0;
    reg clk_in1;
    reg reset;
    reg scan_mode;
    reg select;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in0(clk_in0),
        .clk_in1(clk_in1),
        .reset(reset),
        .scan_mode(scan_mode),
        .select(select),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in0 = 0;
        forever #5 clk_in0 = ~clk_in0;
    end

        task reset_dut;

        begin
            reset = 1;
            scan_mode = 0;
            select = 0;
            #25;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select clk_in0 (Normal Mode)", test_num);
            reset_dut();
            select = 0;
            scan_mode = 0;


            repeat(10) @(posedge clk_in0);


            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switch to clk_in1 (Glitch-free)", test_num);
            reset_dut();
            select = 0;
            #50;


            select = 1;


            repeat(10) @(posedge clk_in1);


            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Scan Mode Bypass (Select clk_in1)", test_num);
            reset_dut();
            scan_mode = 1;
            select = 1;

            #10;

            if (clk_out === clk_in1) begin
                pass_count = pass_count + 1;
                $display("PASS");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Scan mode did not bypass immediately");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rapid Toggle Stability", test_num);
            reset_dut();

            select = 1;
            #5;
            select = 0;
            #5;
            select = 1;


            repeat(15) @(posedge clk_in1);
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in0, clk_in1, reset, scan_mode, select, clk_out);
    end

endmodule
