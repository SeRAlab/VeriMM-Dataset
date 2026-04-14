`timescale 1ns/1ps

module pitch_detection_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] audio_signal;
    reg clk;
    reg reset;
    wire [2:0] pitch_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detection dut (
        .audio_signal(audio_signal),
        .clk(clk),
        .reset(reset),
        .pitch_output(pitch_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            audio_signal = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Silence (Input 0)", test_num);
            reset_dut();


            repeat(5) begin
                audio_signal = 4'd0;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low Amplitude (Input 3)", test_num);
            reset_dut();


            repeat(10) begin
                audio_signal = 4'd3;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Medium Amplitude (Input 8)", test_num);
            reset_dut();


            repeat(10) begin
                audio_signal = 4'd8;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Amplitude (Input 15)", test_num);
            reset_dut();


            repeat(10) begin
                audio_signal = 4'd15;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rising Signal Pattern", test_num);
            reset_dut();


            audio_signal = 4'd2; @(posedge clk);
            audio_signal = 4'd5; @(posedge clk);
            audio_signal = 4'd9; @(posedge clk);
            audio_signal = 4'd12; @(posedge clk);
            audio_signal = 4'd14; @(posedge clk);

            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fluctuating Signal", test_num);
            reset_dut();


            audio_signal = 4'd10; @(posedge clk);
            audio_signal = 4'd11; @(posedge clk);
            audio_signal = 4'd9;  @(posedge clk);
            audio_signal = 4'd10; @(posedge clk);
            audio_signal = 4'd11; @(posedge clk);

            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detection Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [2:0] expected_pitch_output;
        begin
            if (expected_pitch_output === (expected_pitch_output ^ pitch_output ^ expected_pitch_output)) begin
                $display("PASS");
                $display("  Outputs: pitch_output=%h",
                         pitch_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_output=%h",
                         expected_pitch_output);
                $display("  Got:      pitch_output=%h",
                         pitch_output);
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
        $dumpvars(0,audio_signal, clk, reset, pitch_output);
    end

endmodule
