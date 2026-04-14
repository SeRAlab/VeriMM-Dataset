`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [2:0] gray_out;
    wire max_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .gray_out(gray_out),
        .max_reached(max_reached)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            @(negedge clk);
            reset = 1;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking reset state (Binary 0)", test_num);
            reset_dut();
            @(negedge clk);

            #1;


            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking Binary 1", test_num);
            reset_dut();
            @(posedge clk);
            @(negedge clk);

            #1;


            check_outputs(3'b001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking Binary 3", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            @(negedge clk);

            #1;


            check_outputs(3'b010, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking Binary 6 (Max Reached)", test_num);
            reset_dut();
            repeat(6) @(posedge clk);
            @(negedge clk);

            #1;


            check_outputs(3'b101, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking Binary 7", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            @(negedge clk);

            #1;


            check_outputs(3'b100, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking Wrap-around (Binary 0)", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            @(negedge clk);

            #1;


            check_outputs(3'b000, 1'b0);
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
        input [2:0] expected_gray_out;
        input expected_max_reached;
        begin
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out) &&
                expected_max_reached === (expected_max_reached ^ max_reached ^ expected_max_reached)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h, max_reached=%b",
                         gray_out, max_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h, max_reached=%b",
                         expected_gray_out, expected_max_reached);
                $display("  Got:      gray_out=%h, max_reached=%b",
                         gray_out, max_reached);
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
        $dumpvars(0,clk, reset, gray_out, max_reached);
    end

endmodule
