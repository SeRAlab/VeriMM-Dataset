`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg select;
    reg slowena;
    reg up_down;
    reg [2:0] value;
    wire [3:0] count;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .select(select),
        .slowena(slowena),
        .up_down(up_down),
        .value(value),
        .count(count),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up_down = 0;
            value = 0;
            slowena = 0;
            select = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Increment", test_num);
            up_down = 1;
            slowena = 1;
            select = 1;
            value = 3'd0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'd5, 4'bz);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Decrement (Underflow)", test_num);
            up_down = 0;
            slowena = 1;
            select = 1;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'd13, 4'bz);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Slow Enable Inactive", test_num);
            up_down = 1;
            slowena = 0;
            select = 1;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(4'd0, 4'bz);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Summation and Select Toggle", test_num);
            up_down = 1;
            slowena = 1;
            value = 3'd3;
            select = 1;
            repeat(4) @(posedge clk);


            select = 0;
            #1 #1;
 check_outputs(4'bz, 4'd7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Counter Overflow (15 to 0)", test_num);
            up_down = 1;
            slowena = 1;
            select = 1;
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(4'd0, 4'bz);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Summation Overflow", test_num);
            up_down = 1;
            slowena = 1;
            repeat(15) @(posedge clk);

            value = 3'd7;
            select = 0;
            #1 #1;
 check_outputs(4'bz, 4'd6);
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
        input [3:0] expected_count;
        input [3:0] expected_sum;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: count=%h, sum=%h",
                         count, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, sum=%h",
                         expected_count, expected_sum);
                $display("  Got:      count=%h, sum=%h",
                         count, sum);
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
        $dumpvars(0,clk, reset, select, slowena, up_down, value, count, sum);
    end

endmodule
