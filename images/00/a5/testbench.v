`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_signal;
    reg clk;
    reg rst;
    wire [3:0] detected_pitch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .audio_signal(audio_signal),
        .clk(clk),
        .rst(rst),
        .detected_pitch(detected_pitch)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_signal = 8'h80;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("\nTest Case %0d: High Frequency Signal Detection", test_num);
            reset_dut();

            for (i = 0; i < 100; i = i + 1) begin
                audio_signal = 8'd64;
                repeat(2) @(posedge clk);
                audio_signal = 8'd192;
                repeat(2) @(posedge clk);
            end

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTest Case %0d: Medium Frequency Signal Detection", test_num);
            reset_dut();

            for (i = 0; i < 50; i = i + 1) begin
                audio_signal = 8'd64;
                repeat(5) @(posedge clk);
                audio_signal = 8'd192;
                repeat(5) @(posedge clk);
            end

            #1;


            check_outputs(4'h8);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTest Case %0d: Low Frequency Signal Detection", test_num);
            reset_dut();

            for (i = 0; i < 20; i = i + 1) begin
                audio_signal = 8'd64;
                repeat(15) @(posedge clk);
                audio_signal = 8'd192;
                repeat(15) @(posedge clk);
            end

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Silence Detection", test_num);
            reset_dut();
            audio_signal = 8'h80;
            repeat(200) @(posedge clk);

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Static DC Offset Detection", test_num);
            reset_dut();
            audio_signal = 8'hFF;
            repeat(200) @(posedge clk);

            #1;


            check_outputs(4'h0);
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
        input [3:0] expected_detected_pitch;
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
        $dumpvars(0,audio_signal, clk, rst, detected_pitch);
    end

endmodule
