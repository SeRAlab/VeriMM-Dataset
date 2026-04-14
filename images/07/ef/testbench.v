`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] audio_sample;
    reg clk;
    reg reset;
    reg sample_valid;
    wire [15:0] detected_pitch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .audio_sample(audio_sample),
        .clk(clk),
        .reset(reset),
        .sample_valid(sample_valid),
        .detected_pitch(detected_pitch)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_sample = 0;
            sample_valid = 0;
            repeat(10) @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task send_waveform;

        input [15:0] period_samples;
        input [15:0] num_cycles;
        integer i, j;
        begin
            for (i = 0; i < num_cycles; i = i + 1) begin
                for (j = 0; j < period_samples; j = j + 1) begin
                    @(posedge clk);
                    sample_valid = 1;

                    if (j < (period_samples >> 1))
                        audio_sample = 2048 + (j * 100);
                    else
                        audio_sample = 4095 - ((j - (period_samples >> 1)) * 100);

                    @(posedge clk);
                    sample_valid = 0;
                    repeat(2) @(posedge clk);
                end
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 440Hz Frequency Detection", test_num);
            reset_dut();


            send_waveform(100, 10);


            repeat(100) @(posedge clk);
            #1;

            check_outputs(16'd440);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 880Hz Frequency Detection", test_num);
            reset_dut();


            send_waveform(50, 20);

            repeat(100) @(posedge clk);
            #1;

            check_outputs(16'd880);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Silence / DC Input", test_num);
            reset_dut();


            for (i = 0; i < 200; i = i + 1) begin
                @(posedge clk);
                sample_valid = 1;
                audio_sample = 12'h800;
                @(posedge clk);
                sample_valid = 0;
                repeat(2) @(posedge clk);
            end

            repeat(100) @(posedge clk);

            #1;


            check_outputs(16'd0);
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
        input [15:0] expected_detected_pitch;
        begin
            if (expected_detected_pitch === (expected_detected_pitch ^ detected_pitch ^ expected_detected_pitch)) begin
                $display("PASS");
                $display("  Outputs: detected_pitch=%h",
                         detected_pitch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detected_pitch=%h",
                         expected_detected_pitch);
                $display("  Got:      detected_pitch=%h",
                         detected_pitch);
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
        $dumpvars(0,audio_sample, clk, reset, sample_valid, detected_pitch);
    end

endmodule
