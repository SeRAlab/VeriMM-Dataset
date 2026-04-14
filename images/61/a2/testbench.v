`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg rst;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        dir = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking reset value", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Incrementing 10 times", test_num);
        reset_dut();
        dir = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing up-counter wrap-around (256 clocks)", test_num);
        reset_dut();
        dir = 1;
        repeat(256) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing down-counter wrap-around from 0", test_num);
        reset_dut();
        dir = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Decrementing 50 times from 0", test_num);
        reset_dut();
        dir = 0;
        repeat(50) @(posedge clk);
        #1;

        #1;


        check_outputs(8'd206);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Increment 20 times then decrement 5 times", test_num);
        reset_dut();
        dir = 1;
        repeat(20) @(posedge clk);
        dir = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Incrementing to near max (250)", test_num);
        reset_dut();
        dir = 1;
        repeat(250) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd250);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Checking reset priority over increment", test_num);
        reset_dut();
        dir = 1;
        repeat(5) @(posedge clk);
        rst = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
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
        testcase008();
        
        
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, dir, rst, count);
    end

endmodule
