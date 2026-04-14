`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] audio_in;
    reg clk;
    reg reset;
    wire [3:0] audio_out;

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
            audio_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            audio_in = 4'd0;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input = 0 (Expected = 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            audio_in = 4'd5;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input = 5 (Expected = 2)", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            audio_in = 4'd7;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input = 7 (Expected = 3)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            audio_in = 4'd8;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input = 8 (Expected = 8)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            audio_in = 4'd12;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input = 12 (Expected = 8)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            audio_in = 4'd15;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input = 15 (Expected = 8)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            audio_in = 4'd6;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input = 6 (Expected = 3)", test_num);
            #1;

            check_outputs(4'd3);
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
        $dumpvars(0,audio_in, clk, reset, audio_out);
    end

endmodule
