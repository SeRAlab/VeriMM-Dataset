`timescale 1ns/1ps

module up_down_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg reset;
    reg up;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_3bit dut (
        .clk(clk),
        .down(down),
        .reset(reset),
        .up(up),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        up = 0;
        down = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Basic Increment");
        reset_dut();
        up = 1;
        down = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Upward Wrap-around");
        reset_dut();
        up = 1;
        down = 0;
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Downward Wrap-around");
        reset_dut();
        up = 0;
        down = 1;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Hold Logic (Both Low)");
        reset_dut();
        up = 1;
        down = 0;
        repeat(2) @(posedge clk);
        up = 0;
        down = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Hold Logic (Both High)");
        reset_dut();
        up = 1;
        down = 0;
        repeat(4) @(posedge clk);
        up = 1;
        down = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Testcase 006: Downward Sequence");
        reset_dut();
        up = 1;
        down = 0;
        repeat(5) @(posedge clk);
        up = 0;
        down = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning Testcase 007: Reset Priority");
        reset_dut();
        up = 1;
        down = 0;
        repeat(4) @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd0);
        reset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_3bit Testbench");
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
        input [2:0] expected_count;
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
        $dumpvars(0,clk, down, reset, up, count);
    end

endmodule
