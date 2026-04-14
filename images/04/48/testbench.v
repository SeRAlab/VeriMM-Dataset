`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_sample;
    reg clk;
    reg reset;
    wire [15:0] pitch_frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .audio_sample(audio_sample),
        .clk(clk),
        .reset(reset),
        .pitch_frequency(pitch_frequency)
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
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %03d: Silence (All Zeros)", test_num);
            reset_dut();


            repeat (100) begin
                audio_sample = 8'd0;
                @(posedge clk);
            end


            #1;



            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %03d: DC Offset (Constant Positive)", test_num);
            reset_dut();

            repeat (100) begin
                audio_sample = 8'd50;
                @(posedge clk);
            end

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %03d: High Frequency Signal", test_num);
            reset_dut();

            for (i = 0; i < 50; i = i + 1) begin
                audio_sample = 8'd100;
                @(posedge clk);
                audio_sample = 8'sb10011100;
                @(posedge clk);
            end



            #1;




            check_outputs(16'd99);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %03d: Low Frequency Signal", test_num);
            reset_dut();

            repeat (25) begin audio_sample = 8'd60; @(posedge clk); end
            repeat (25) begin audio_sample = 8'sb11000100; @(posedge clk); end
            repeat (25) begin audio_sample = 8'd60; @(posedge clk); end
            repeat (25) begin audio_sample = 8'sb11000100; @(posedge clk); end

            #1;


            check_outputs(16'd3);
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
        $dumpvars(0,audio_sample, clk, reset, pitch_frequency);
    end

endmodule
