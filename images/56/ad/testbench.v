`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg col_n;
    reg [7:0] cycle;
    reg [7:0] duty;
    reg rst_n;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .col_n(col_n),
        .cycle(cycle),
        .duty(duty),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            col_n = 1;
            cycle = 8'd0;
            duty = 8'd0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Cycle 10, Duty 5, col_n=0 - Checking High phase", test_num);
            reset_dut();
            cycle = 8'd10;
            duty = 8'd5;
            col_n = 1'b0;
            repeat(2) @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Cycle 10, Duty 5, col_n=0 - Checking Low phase", test_num);
            reset_dut();
            cycle = 8'd10;
            duty = 8'd5;
            col_n = 1'b0;
            repeat(8) @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: 100%% Duty Cycle", test_num);
            reset_dut();
            cycle = 8'd10;
            duty = 8'd10;
            col_n = 1'b0;
            repeat(9) @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: 0%% Duty Cycle", test_num);
            reset_dut();
            cycle = 8'd10;
            duty = 8'd0;
            col_n = 1'b0;
            repeat(5) @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Control col_n disabled", test_num);
            reset_dut();
            cycle = 8'd10;
            duty = 8'd8;
            col_n = 1'b1;
            repeat(4) @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Large Cycle check", test_num);
            reset_dut();
            cycle = 8'd100;
            duty = 8'd80;
            col_n = 1'b0;
            repeat(50) @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Small Duty check", test_num);
            reset_dut();
            cycle = 8'd20;
            duty = 8'd2;
            col_n = 1'b0;
            repeat(10) @(posedge clk);
            #2 #1;
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,clk, col_n, cycle, duty, rst_n, out);
    end

endmodule
