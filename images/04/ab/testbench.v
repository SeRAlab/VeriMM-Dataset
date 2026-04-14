`timescale 1ns/1ps

module pitch_detection_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] frequency;
    reg rst;
    reg [9:0] threshold;
    wire pitch_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detection dut (
        .clk(clk),
        .frequency(frequency),
        .rst(rst),
        .threshold(threshold),
        .pitch_detected(pitch_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        frequency = 0;
        threshold = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        frequency = 10'd150;
        threshold = 10'd400;

        @(posedge clk);
        #1;
        $display("Testcase %03d: Frequency (%0d) < Threshold (%0d)", test_num, frequency, threshold);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        frequency = 10'd750;
        threshold = 10'd400;
        @(posedge clk);
        #1;
        $display("Testcase %02d: Frequency (%0d) > Threshold (%0d)", test_num, frequency, threshold);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        frequency = 10'd500;
        threshold = 10'd500;
        @(posedge clk);
        #1;
        $display("Testcase %03d: Frequency (%0d) == Threshold (%0d)", test_num, frequency, threshold);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        frequency = 10'd1023;
        threshold = 10'd1022;
        @(posedge clk);
        #1;
        $display("Testcase %03d: Max Values - Frequency (%0d) > Threshold (%0d)", test_num, frequency, threshold);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        frequency = 10'd800;
        threshold = 10'd200;
        @(posedge clk);
        #1;

        rst = 1;
        @(posedge clk);
        #1;
        $display("Testcase %03d: Verification of Reset clearing output", test_num);
        #1;

        check_outputs(1'b0);
        rst = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detection Testbench");
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
        input expected_pitch_detected;
        begin
            if (expected_pitch_detected === (expected_pitch_detected ^ pitch_detected ^ expected_pitch_detected)) begin
                $display("PASS");
                $display("  Outputs: pitch_detected=%b",
                         pitch_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_detected=%b",
                         expected_pitch_detected);
                $display("  Got:      pitch_detected=%b",
                         pitch_detected);
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
        $dumpvars(0,clk, frequency, rst, threshold, pitch_detected);
    end

endmodule
