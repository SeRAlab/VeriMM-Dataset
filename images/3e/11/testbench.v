`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] audio_in;
    reg clk;
    reg [1:0] gain_factor;
    reg [11:0] threshold;
    wire [11:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .clk(clk),
        .gain_factor(gain_factor),
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
            audio_in = 12'b0;
            gain_factor = 2'b0;
            threshold = 12'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            audio_in = 12'd500;
            threshold = 12'd1000;
            gain_factor = 2'd2;
            @(posedge clk);
            #2;
            $display("Test %0d: Input below threshold", test_num);
            #1;

            check_outputs(12'd500);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            audio_in = 12'd1000;
            threshold = 12'd1000;
            gain_factor = 2'd1;
            @(posedge clk);
            #2;
            $display("Test %0d: Input at threshold", test_num);
            #1;

            check_outputs(12'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            audio_in = 12'd2000;
            threshold = 12'd1000;
            gain_factor = 2'd0;
            @(posedge clk);
            #2;
            $display("Test %0d: Above threshold, Gain 0", test_num);
            #1;

            check_outputs(12'd2000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            audio_in = 12'd2000;
            threshold = 12'd1000;
            gain_factor = 2'd1;
            @(posedge clk);
            #2;
            $display("Test %0d: Above threshold, Gain 1", test_num);
            #1;

            check_outputs(12'd1500);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            audio_in = 12'd2000;
            threshold = 12'd1000;
            gain_factor = 2'd2;
            @(posedge clk);
            #2;
            $display("Test %0d: Above threshold, Gain 2", test_num);
            #1;

            check_outputs(12'd1250);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            audio_in = 12'd3048;
            threshold = 12'd1000;
            gain_factor = 2'd3;
            @(posedge clk);
            #2;
            $display("Test %0d: Above threshold, Gain 3", test_num);
            #1;

            check_outputs(12'd1256);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            audio_in = 12'd0;
            threshold = 12'd500;
            gain_factor = 2'd1;
            @(posedge clk);
            #2;
            $display("Test %0d: Zero input", test_num);
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            audio_in = 12'hFFF;
            threshold = 12'd0;
            gain_factor = 2'd2;
            @(posedge clk);
            #2;
            $display("Test %0d: Max input, zero threshold", test_num);
            #1;

            check_outputs(12'd1023);
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
        input [11:0] expected_audio_out;
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
        $dumpvars(0,audio_in, clk, gain_factor, threshold, audio_out);
    end

endmodule
