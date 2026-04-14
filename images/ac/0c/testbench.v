`timescale 1ns/1ps

module sync_down_counter_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] load_val;
    reg rst_n;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_down_counter_16bit dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        load = 0;
        load_val = 16'h0000;
        #15;
        rst_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Asynchronous Reset Check");
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Synchronous Load Operation");
        test_num = 2;
        reset_dut();
        @(negedge clk);
        load = 1;
        load_val = 16'hA5A5;
        @(negedge clk);
        load = 0;

        #1;


        check_outputs(16'hA5A5);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Down-Counting Logic (3 steps)");
        test_num = 3;
        reset_dut();
        @(negedge clk);
        load = 1;
        load_val = 16'h0005;
        @(negedge clk);
        load = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Wrap-around Check (0000 -> FFFF)");
        test_num = 4;
        reset_dut();
        @(negedge clk);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Priority Check (Load vs Count)");
        test_num = 5;
        reset_dut();
        @(negedge clk);
        load = 1;
        load_val = 16'h1234;
        @(negedge clk);
        load_val = 16'h5678;
        @(negedge clk);
        load = 0;

        #1;


        check_outputs(16'h5678);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: Down-counting to Zero");
        test_num = 6;
        reset_dut();
        @(negedge clk);
        load = 1;
        load_val = 16'h000A;
        @(negedge clk);
        load = 0;
        repeat(10) @(negedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        $display("\nTestcase 007: Mid-operation Asynchronous Reset");
        test_num = 7;
        reset_dut();
        @(negedge clk);
        load = 1;
        load_val = 16'hFFFF;
        @(negedge clk);
        load = 0;
        repeat(5) @(negedge clk);

        #3; rst_n = 0;
        #5;
        #1;

        check_outputs(16'h0000);
        rst_n = 1;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_down_counter_16bit Testbench");
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
        input [15:0] expected_count;
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
        $dumpvars(0,clk, load, load_val, rst_n, count);
    end

endmodule
