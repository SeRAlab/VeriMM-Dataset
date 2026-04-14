`timescale 1ns/1ps

module up_down_counter_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg en;
    reg rst;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_16bit dut (
        .clk(clk),
        .dir(dir),
        .en(en),
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
            en = 0;
            dir = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic Up-Counting");
            test_num = 1;
            reset_dut();
            en = 1;
            dir = 1;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(16'h000A);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Basic Down-Counting (Underflow)");
            test_num = 2;
            reset_dut();
            en = 1;
            dir = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFD);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Enable Signal Check");
            test_num = 3;
            reset_dut();
            en = 1;
            dir = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'h0005);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Direction Switching");
            test_num = 4;
            reset_dut();
            en = 1;
            dir = 1;
            repeat(10) @(posedge clk);
            dir = 0;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(16'h0006);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Synchronous Reset Check");
            test_num = 5;
            reset_dut();
            en = 1;
            dir = 1;
            repeat(20) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Counting up 100 times");
            test_num = 6;
            reset_dut();
            en = 1;
            dir = 1;
            repeat(100) @(posedge clk);
            #1 #1;
 check_outputs(16'd100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_16bit Testbench");
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
        $dumpvars(0,clk, dir, en, rst, count);
    end

endmodule
