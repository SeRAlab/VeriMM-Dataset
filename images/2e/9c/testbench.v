`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] audio_signal;
    reg clk;
    reg reset;
    reg [3:0] threshold;
    wire pitch_high;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .audio_signal(audio_signal),
        .clk(clk),
        .reset(reset),
        .threshold(threshold),
        .pitch_high(pitch_high)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_signal = 4'b0000;
            threshold = 4'b0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Audio Signal (10) > Threshold (5)", test_num);
            reset_dut();
            audio_signal = 4'd10;
            threshold = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Audio Signal (3) < Threshold (8)", test_num);
            reset_dut();
            audio_signal = 4'd3;
            threshold = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Audio Signal (7) == Threshold (7)", test_num);
            reset_dut();
            audio_signal = 4'd7;
            threshold = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Audio (15) > Min Threshold (0)", test_num);
            reset_dut();
            audio_signal = 4'd15;
            threshold = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min Audio (0) < Max Threshold (15)", test_num);
            reset_dut();
            audio_signal = 4'd0;
            threshold = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Audio Signal (9) > Threshold (8)", test_num);
            reset_dut();
            audio_signal = 4'd9;
            threshold = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Audio Signal (7) < Threshold (8)", test_num);
            reset_dut();
            audio_signal = 4'd7;
            threshold = 4'd8;
            @(posedge clk);
            #1;
            #1;

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
        $display("pitch_detector Testbench");
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
        input expected_pitch_high;
        begin
            if (expected_pitch_high === (expected_pitch_high ^ pitch_high ^ expected_pitch_high)) begin
                $display("PASS");
                $display("  Outputs: pitch_high=%b",
                         pitch_high);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_high=%b",
                         expected_pitch_high);
                $display("  Got:      pitch_high=%b",
                         pitch_high);
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
        $dumpvars(0,audio_signal, clk, reset, threshold, pitch_high);
    end

endmodule
