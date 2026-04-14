`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] audio_in;
    reg clk;
    reg [2:0] compression_ratio;
    reg reset;
    reg [3:0] threshold;
    wire [3:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .clk(clk),
        .compression_ratio(compression_ratio),
        .reset(reset),
        .threshold(threshold),
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
            audio_in = 0;
            compression_ratio = 0;
            threshold = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Behavior", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Below Threshold Passthrough", test_num);
            reset_dut();
            threshold = 4'sb0101;
            compression_ratio = 3'd2;
            audio_in = 4'sb0010;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'sb0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Positive Compression Active", test_num);
            reset_dut();
            threshold = 4'sb0010;
            compression_ratio = 3'd2;
            audio_in = 4'sb0110;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'sb0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Negative Compression Active", test_num);
            reset_dut();
            threshold = 4'sb0010;
            compression_ratio = 3'd2;
            audio_in = 4'sb1010;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'sb1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: High Ratio Compression", test_num);
            reset_dut();
            threshold = 4'sb0001;
            compression_ratio = 3'd7;
            audio_in = 4'sb0111;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'sb0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Zero Input Stability", test_num);
            reset_dut();
            threshold = 4'sb0010;
            compression_ratio = 3'd2;
            audio_in = 4'sb0000;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'sb0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Max Negative Input Compression", test_num);
            reset_dut();
            threshold = 4'sb0000;
            compression_ratio = 3'd4;
            audio_in = 4'sb1000;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'sb1110);
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
        input [3:0] expected_audio_out;
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
        $dumpvars(0,audio_in, clk, compression_ratio, reset, threshold, audio_out);
    end

endmodule
