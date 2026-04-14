`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_in;
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
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Silence (Zero Input)");

            rst_n = 0; audio_in = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;


            repeat(32) begin
                audio_in = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Sustained Loud Speech");
            rst_n = 0; audio_in = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;


            repeat(32) begin
                audio_in = 16000;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Sustained Negative Speech Signal");
            rst_n = 0; audio_in = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;


            repeat(32) begin
                audio_in = -16000;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Low-Level Noise (Below Threshold)");
            rst_n = 0; audio_in = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;


            repeat(32) begin
                audio_in = 100;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Speech ending (Transition to Silence)");
            rst_n = 0; audio_in = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;


            repeat(20) begin
                audio_in = 20000;
                @(posedge clk);
            end


            repeat(64) begin
                audio_in = 0;
                @(posedge clk);
            end

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
            #1; // Small delay for combinational logic to settle
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

endmodule
