`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg [2:0] compression_ratio;
    reg rst;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .clk(clk),
        .compression_ratio(compression_ratio),
        .rst(rst),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_in = 16'd0;
            compression_ratio = 3'd0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Zero Input Signal");
            reset_dut();
            audio_in = 16'h0000;
            compression_ratio = 3'b010;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Low Amplitude Signal (Below Threshold)");
            reset_dut();
            audio_in = 16'h0100;
            compression_ratio = 3'b111;
            @(posedge clk);

            #1 #1;
 check_outputs(16'h0100);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Large Signal, Ratio 0 (1:1)");
            reset_dut();
            audio_in = 16'h4000;
            compression_ratio = 3'b000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Large Positive Signal, Ratio 2");
            reset_dut();
            audio_in = 16'h6000;
            compression_ratio = 3'b010;
            @(posedge clk);



            #1 #1;
 check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Large Negative Signal, Ratio 2");
            reset_dut();
            audio_in = 16'hA000;
            compression_ratio = 3'b010;
            @(posedge clk);


            #1 #1;
 check_outputs(16'hC000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max Positive Scale, Max Compression");
            reset_dut();
            audio_in = 16'h7FFF;
            compression_ratio = 3'b111;
            @(posedge clk);

            #1 #1;
 check_outputs(16'h3FFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Max Negative Scale, Max Compression");
            reset_dut();
            audio_in = 16'h8000;
            compression_ratio = 3'b111;
            @(posedge clk);

            #1 #1;
 check_outputs(16'hC000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Small Negative Value (Below Threshold)");
            reset_dut();
            audio_in = 16'hFF00;
            compression_ratio = 3'b101;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFF00);
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
        $dumpvars(0,audio_in, clk, compression_ratio, rst, audio_out);
    end

endmodule
