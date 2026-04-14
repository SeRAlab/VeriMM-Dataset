`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg reset;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .clk(clk),
        .reset(reset),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_in = 16'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            audio_in = 16'h0000;
            @(posedge clk);
            #2;
            $display("Testcase 001: Zero Input");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            audio_in = 16'h2000;
            @(posedge clk);
            #2;
            $display("Testcase 002: Signal Below Threshold (0x2000)");
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            audio_in = THRESHOLD;
            @(posedge clk);
            #2;
            $display("Testcase 003: Signal Exactly At Threshold (0x4000)");
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            audio_in = 16'h5000;
            @(posedge clk);
            #2;
            $display("Testcase 004: Signal Slightly Above Threshold (0x5000)");
            #1;

            check_outputs(16'h4800);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            audio_in = 16'h8000;
            @(posedge clk);
            #2;
            $display("Testcase 005: High Amplitude Signal (0x8000)");
            #1;

            check_outputs(16'h6000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        input [15:0] expected_audio_out;
        begin
            if (expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out)) begin
                $display("PASS");
                $display("  Outputs: audio_out=%h",
                         audio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_out=%h",
                         expected_audio_out);
                $display("  Got:      audio_out=%h",
                         audio_out);
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
        $dumpvars(0,audio_in, clk, reset, audio_out);
    end

endmodule
