`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [255:0] audio_in;
    reg clk;
    wire speech_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio_in(audio_in),
        .clk(clk),
        .speech_detected(speech_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            audio_in = 256'd0;
            repeat (10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Silence", test_num);
            reset_dut();
            audio_in = 256'd0;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Persistent Speech Signal", test_num);
            reset_dut();

            audio_in = {64{4'hA}};
            repeat (50) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Short Noise Spike (Persistence Check)", test_num);
            reset_dut();

            audio_in = {256{1'b1}};
            @(posedge clk);
            @(posedge clk);

            audio_in = 256'd0;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fluctuating Speech Energy", test_num);
            reset_dut();

            repeat (10) begin
                audio_in = {32{8'hFF}}; @(posedge clk);
                audio_in = {32{8'h7F}}; @(posedge clk);
                audio_in = {32{8'hAA}}; @(posedge clk);
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Speech Termination", test_num);
            reset_dut();

            audio_in = {256{1'b1}};
            repeat (30) @(posedge clk);

            audio_in = 256'd0;
            repeat (50) @(posedge clk);
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
        $dumpvars(0,audio_in, clk, speech_detected);
    end

endmodule
