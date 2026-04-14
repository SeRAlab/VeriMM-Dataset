`timescale 1ns/1ps

module audio_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] audio_sample;
    reg control_signal;
    wire [3:0] compressed_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compressor dut (
        .audio_sample(audio_sample),
        .control_signal(control_signal),
        .compressed_audio(compressed_audio)
    );

    // Clock generation (10ns period)
    initial begin
        control_signal = 0;
        forever #5 control_signal = ~control_signal;
    end

        task reset_dut;

    begin
        audio_sample = 0;
        control_signal = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        audio_sample = 4'b0000;
        control_signal = 1'b0;
        #10;
        $display("Test %0d: Passthrough - Zero Input", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        audio_sample = 4'd10;
        control_signal = 1'b0;
        #10;
        $display("Test %0d: Passthrough - Mid Input (10)", test_num);
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        audio_sample = 4'd15;
        control_signal = 1'b0;
        #10;
        $display("Test %0d: Passthrough - Max Input (15)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        audio_sample = 4'b0000;
        control_signal = 1'b1;
        #10;
        $display("Test %0d: Compression - Zero Input", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        audio_sample = 4'd8;
        control_signal = 1'b1;
        #10;
        $display("Test %0d: Compression - Even Input (8 -> 4)", test_num);
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        audio_sample = 4'd9;
        control_signal = 1'b1;
        #10;
        $display("Test %0d: Compression - Odd Input (9 -> 4)", test_num);
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        audio_sample = 4'd15;
        control_signal = 1'b1;
        #10;
        $display("Test %0d: Compression - Max Input (15 -> 7)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        audio_sample = 4'd12;
        control_signal = 1'b1;
        #10;
        control_signal = 1'b0;
        #10;
        $display("Test %0d: Dynamic Toggle - Switching to Passthrough (12)", test_num);
        #1;

        check_outputs(4'd12);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_compressed_audio;
        begin
            if (expected_compressed_audio === (expected_compressed_audio ^ compressed_audio ^ expected_compressed_audio)) begin
                $display("PASS");
                $display("  Outputs: compressed_audio=%h",
                         compressed_audio);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_audio=%h",
                         expected_compressed_audio);
                $display("  Got:      compressed_audio=%h",
                         compressed_audio);
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
        $dumpvars(0,audio_sample, control_signal, compressed_audio);
    end

endmodule
