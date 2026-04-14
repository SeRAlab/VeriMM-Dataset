`timescale 1ns/1ps

module PitchDetector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] voice_signal;
    wire [6:0] detected_pitch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PitchDetector dut (
        .clk(clk),
        .reset(reset),
        .voice_signal(voice_signal),
        .detected_pitch(detected_pitch)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            voice_signal = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input Sequence [1, 2, 3, 4]", test_num);
            reset_dut();

            voice_signal = 4'd1; @(posedge clk);
            voice_signal = 4'd2; @(posedge clk);
            voice_signal = 4'd3; @(posedge clk);
            voice_signal = 4'd4; @(posedge clk);


            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input Sequence [5, 10, 5, 10]", test_num);
            reset_dut();

            voice_signal = 4'd5;  @(posedge clk);
            voice_signal = 4'd10; @(posedge clk);
            voice_signal = 4'd5;  @(posedge clk);
            voice_signal = 4'd10; @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Silent Signal [0, 0, 0, 0]", test_num);
            reset_dut();

            voice_signal = 4'd0; @(posedge clk);
            voice_signal = 4'd0; @(posedge clk);
            voice_signal = 4'd0; @(posedge clk);
            voice_signal = 4'd0; @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: High Frequency Pattern [15, 0, 15, 0]", test_num);
            reset_dut();

            voice_signal = 4'd15; @(posedge clk);
            voice_signal = 4'd0;  @(posedge clk);
            voice_signal = 4'd15; @(posedge clk);
            voice_signal = 4'd0;  @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Undefined Sequence [1, 7, 2, 12]", test_num);
            reset_dut();

            voice_signal = 4'd1;  @(posedge clk);
            voice_signal = 4'd7;  @(posedge clk);
            voice_signal = 4'd2;  @(posedge clk);
            voice_signal = 4'd12; @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PitchDetector Testbench");
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
        input [6:0] expected_detected_pitch;
        begin
            if (expected_detected_pitch === (expected_detected_pitch ^ detected_pitch ^ expected_detected_pitch)) begin
                $display("PASS");
                $display("  Outputs: detected_pitch=%h",
                         detected_pitch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detected_pitch=%h",
                         expected_detected_pitch);
                $display("  Got:      detected_pitch=%h",
                         detected_pitch);
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
        $dumpvars(0,clk, reset, voice_signal, detected_pitch);
    end

endmodule
