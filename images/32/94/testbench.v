`timescale 1ns/1ps

module audio_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg reset;
    wire [7:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compressor dut (
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
            audio_in = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Zero Input");
            reset_dut();
            audio_in = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Maximum Input");
            reset_dut();
            audio_in = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: High Byte Extraction");
            reset_dut();
            audio_in = 16'hA5C3;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Truncation Check (LSBs set)");
            reset_dut();
            audio_in = 16'h00FF;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Mid-Range Value");
            reset_dut();
            audio_in = 16'h1234;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Alternating Bits Pattern");
            reset_dut();
            audio_in = 16'h55AA;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Half-scale Value");
            reset_dut();
            audio_in = 16'h8000;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h80);
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
        input [7:0] expected_audio_out;
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
