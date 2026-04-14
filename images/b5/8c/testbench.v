`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg audio_in;
    wire speech_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio_in(audio_in),
        .speech_detected(speech_detected)
    );

    // Clock generation (10ns period)
    initial begin
        audio_in = 0;
        forever #5 audio_in = ~audio_in;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Silence Test", test_num);

            repeat (50) @(posedge clk) audio_in <= 0;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Sustained Speech Test", test_num);

            repeat (50) @(posedge clk) audio_in <= 1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Noise Spike Test", test_num);

            repeat (2) @(posedge clk) audio_in <= 1;
            repeat (20) @(posedge clk) audio_in <= 0;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Intermittent Activity Test", test_num);

            repeat (40) begin
                @(posedge clk) audio_in <= 1;
                @(posedge clk) audio_in <= 0;
            end

            #1;


            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Speech Ending Test", test_num);


            repeat (40) @(posedge clk) audio_in <= 1;

            repeat (100) @(posedge clk) audio_in <= 0;

            #1;


            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_speech_detected;
        begin
            if (expected_speech_detected === (expected_speech_detected ^ speech_detected ^ expected_speech_detected)) begin
                $display("PASS");
                $display("  Outputs: speech_detected=%b",
                         speech_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speech_detected=%b",
                         expected_speech_detected);
                $display("  Got:      speech_detected=%b",
                         speech_detected);
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
        $dumpvars(0,audio_in, speech_detected);
    end

endmodule
