`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_sample;
    reg clk;
    reg rst;
    wire [15:0] pitch_frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .audio_sample(audio_sample),
        .clk(clk),
        .rst(rst),
        .pitch_frequency(pitch_frequency)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_sample = 8'h80;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                audio_sample = 8'd128;
                @(posedge clk);
            end
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                if ((i % 8) < 4)
                    audio_sample = 8'd160;
                else
                    audio_sample = 8'd90;
                @(posedge clk);
            end
            #1;

            check_outputs(16'd5512);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                if ((i % 4) < 2)
                    audio_sample = 8'd200;
                else
                    audio_sample = 8'd50;
                @(posedge clk);
            end
            #1;

            check_outputs(16'd11025);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                audio_sample = 8'd200;
                @(posedge clk);
            end
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                if ((i % 102) < 51)
                    audio_sample = 8'd140;
                else
                    audio_sample = 8'd110;
                @(posedge clk);
            end
            #1;

            check_outputs(16'd430);
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
        input [15:0] expected_pitch_frequency;
        begin
            if (expected_pitch_frequency === (expected_pitch_frequency ^ pitch_frequency ^ expected_pitch_frequency)) begin
                $display("PASS");
                $display("  Outputs: pitch_frequency=%h",
                         pitch_frequency);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_frequency=%h",
                         expected_pitch_frequency);
                $display("  Got:      pitch_frequency=%h",
                         pitch_frequency);
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
        $dumpvars(0,audio_sample, clk, rst, pitch_frequency);
    end

endmodule
