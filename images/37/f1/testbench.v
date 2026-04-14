`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg signal;
    wire falling_edge;
    wire rising_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .rst(rst),
        .signal(signal),
        .falling_edge(falling_edge),
        .rising_edge(rising_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            signal = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Rising Edge Detection");
            reset_dut();
            signal = 0;
            @(posedge clk);
            #1 signal = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Falling Edge Detection");
            reset_dut();
            signal = 1;
            @(posedge clk);
            #1 signal = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Steady Low (No Crossing)");
            reset_dut();
            signal = 0;
            repeat(3) @(posedge clk);
            #2 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Steady High (No Crossing)");
            reset_dut();
            signal = 1;
            repeat(3) @(posedge clk);
            #2 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Multiple Crossings");
            reset_dut();

            signal = 0; @(posedge clk);
            signal = 1; @(posedge clk);

            signal = 0; @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zero_crossing_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_falling_edge;
        input expected_rising_edge;
        begin
            if (expected_falling_edge === (expected_falling_edge ^ falling_edge ^ expected_falling_edge) &&
                expected_rising_edge === (expected_rising_edge ^ rising_edge ^ expected_rising_edge)) begin
                $display("PASS");
                $display("  Outputs: falling_edge=%b, rising_edge=%b",
                         falling_edge, rising_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: falling_edge=%b, rising_edge=%b",
                         expected_falling_edge, expected_rising_edge);
                $display("  Got:      falling_edge=%b, rising_edge=%b",
                         falling_edge, rising_edge);
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
        $dumpvars(0,clk, rst, signal, falling_edge, rising_edge);
    end

endmodule
