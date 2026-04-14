`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dir;
    reg reset_n;
    wire [2:0] dirOut;
    wire lockVal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .reset_n(reset_n),
        .dirOut(dirOut),
        .lockVal(lockVal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset_n = 0;
            dir = 4'b0000;
            @(negedge clk);
            reset_n = 1;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: All Zeros (Idle)", test_num);
            reset_dut();
            dir = 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Direction Bit 0", test_num);
            reset_dut();
            dir = 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Direction Bit 1", test_num);
            reset_dut();
            dir = 4'b0010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b010, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Direction Bit 2", test_num);
            reset_dut();
            dir = 4'b0100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b100, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Lock Bit Only", test_num);
            reset_dut();
            dir = 4'b1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Direction + Lock Combined", test_num);
            reset_dut();
            dir = 4'b1101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b101, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %03d: All Bits Active", test_num);
            reset_dut();
            dir = 4'b1111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b111, 1'b1);
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
        testcase007();
        
        
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
        input [2:0] expected_dirOut;
        input expected_lockVal;
        begin
            if (expected_dirOut === (expected_dirOut ^ dirOut ^ expected_dirOut) &&
                expected_lockVal === (expected_lockVal ^ lockVal ^ expected_lockVal)) begin
                $display("PASS");
                $display("  Outputs: dirOut=%h, lockVal=%b",
                         dirOut, lockVal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dirOut=%h, lockVal=%b",
                         expected_dirOut, expected_lockVal);
                $display("  Got:      dirOut=%h, lockVal=%b",
                         dirOut, lockVal);
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
        $dumpvars(0,clk, dir, reset_n, dirOut, lockVal);
    end

endmodule
