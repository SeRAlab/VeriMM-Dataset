`timescale 1ns/1ps

module audio_compression_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_sample;
    reg clk;
    reg reset;
    reg valid_in;
    wire [15:0] compressed_data;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compression dut (
        .audio_sample(audio_sample),
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .compressed_data(compressed_data),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_sample = 16'h0;
            valid_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Short Run (2 samples)");
            reset_dut();
            audio_sample = 16'hAAAA; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'hAAAA; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'hBBBB; valid_in = 1; @(posedge clk); #1;
            valid_in = 0;
            #1;

            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Long Run (4 samples)");
            reset_dut();
            audio_sample = 16'h5555; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'h5555; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'h5555; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'h5555; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'h1234; valid_in = 1; @(posedge clk); #1;
            valid_in = 0;
            #1;

            check_outputs(16'h5555, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Single Sample Run");
            reset_dut();
            audio_sample = 16'h1111; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'h2222; valid_in = 1; @(posedge clk); #1;
            valid_in = 0;
            #1;

            check_outputs(16'h1111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Reset during sequence");
            reset_dut();
            audio_sample = 16'hFFFF; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'hFFFF; valid_in = 1; @(posedge clk); #1;
            reset = 1; @(posedge clk); #1;
            reset = 0; valid_in = 0;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Zero value run");
            reset_dut();
            audio_sample = 16'h0000; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'h0000; valid_in = 1; @(posedge clk); #1;
            audio_sample = 16'hFFFF; valid_in = 1; @(posedge clk); #1;
            valid_in = 0;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compression Testbench");
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
        input [15:0] expected_compressed_data;
        input expected_valid_out;
        begin
            if (expected_compressed_data === (expected_compressed_data ^ compressed_data ^ expected_compressed_data) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_data=%h, valid_out=%b",
                         compressed_data, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_data=%h, valid_out=%b",
                         expected_compressed_data, expected_valid_out);
                $display("  Got:      compressed_data=%h, valid_out=%b",
                         compressed_data, valid_out);
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
        $dumpvars(0,audio_sample, clk, reset, valid_in, compressed_data, valid_out);
    end

endmodule
