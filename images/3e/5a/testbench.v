`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_signal;
    reg clk;
    reg [15:0] echo_signal;
    reg reset;
    reg [15:0] scaling_factor;
    wire [15:0] processed_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .audio_signal(audio_signal),
        .clk(clk),
        .echo_signal(echo_signal),
        .reset(reset),
        .scaling_factor(scaling_factor),
        .processed_signal(processed_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        audio_signal = 0;
        echo_signal = 0;
        scaling_factor = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Audio pass-through (Zero Echo)", test_num);
        audio_signal = 16'd1000;
        echo_signal = 16'd0;
        scaling_factor = 16'h4000;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'd1000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 50%% Echo Reduction", test_num);
        audio_signal = 16'd2000;
        echo_signal = 16'd2000;
        scaling_factor = 16'h4000;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'd1000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 25%% Echo Reduction", test_num);
        audio_signal = 16'd5000;
        echo_signal = 16'd10000;
        scaling_factor = 16'h2000;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'd2500);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Negative Output Result", test_num);
        audio_signal = 16'd0;
        echo_signal = 16'd4000;
        scaling_factor = 16'h4000;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'hF830);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Signal Processing", test_num);
        audio_signal = 16'hF830;
        echo_signal = 16'hF830;
        scaling_factor = 16'h4000;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(16'hFC18);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancellation Testbench");
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
        input [15:0] expected_processed_signal;
        begin
            if (expected_processed_signal === (expected_processed_signal ^ processed_signal ^ expected_processed_signal)) begin
                $display("PASS");
                $display("  Outputs: processed_signal=%h",
                         processed_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: processed_signal=%h",
                         expected_processed_signal);
                $display("  Got:      processed_signal=%h",
                         processed_signal);
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
        $dumpvars(0,audio_signal, clk, echo_signal, reset, scaling_factor, processed_signal);
    end

endmodule
