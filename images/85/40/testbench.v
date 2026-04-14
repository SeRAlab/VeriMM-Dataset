`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bts;
    reg clk;
    reg [3:0] curFlr;
    wire dir;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bts(bts),
        .clk(clk),
        .curFlr(curFlr),
        .dir(dir)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bts = 4'b0000;
            curFlr = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            curFlr = 4'b0000;
            bts = 4'b1000;
            @(posedge clk);
            #2;
            $display("Test Case 001: Target 3, Current 0");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            curFlr = 4'd3;
            bts = 4'b0001;
            @(posedge clk);
            #2;
            $display("Test Case 002: Target 0, Current 3");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            curFlr = 4'd2;
            bts = 4'b0100;
            @(posedge clk);
            #2;
            $display("Test Case 003: Target 2, Current 2");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            curFlr = 4'd1;
            bts = 4'b1100;
            @(posedge clk);
            #2;
            $display("Test Case 004: Target 2/3, Current 1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            curFlr = 4'd2;
            bts = 4'b0011;
            @(posedge clk);
            #2;
            $display("Test Case 005: Target 0/1, Current 2");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            curFlr = 4'd0;
            bts = 4'b0000;
            @(posedge clk);
            #2;
            $display("Test Case 006: No buttons, Current 0");
            #1;

            check_outputs(1'b0);
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
        input expected_dir;
        begin
            if (expected_dir === (expected_dir ^ dir ^ expected_dir)) begin
                $display("PASS");
                $display("  Outputs: dir=%b",
                         dir);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dir=%b",
                         expected_dir);
                $display("  Got:      dir=%b",
                         dir);
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
        $dumpvars(0,bts, clk, curFlr, dir);
    end

endmodule
