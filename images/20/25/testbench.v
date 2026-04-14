`timescale 1ns/1ps

module EchoCancellation_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg [15:0] echo_ref;
    reg reset;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    EchoCancellation dut (
        .audio_in(audio_in),
        .clk(clk),
        .echo_ref(echo_ref),
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
        echo_ref = 16'h0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Zero Input", test_num);
        reset_dut();
        audio_in = 16'h0000;
        echo_ref = 16'h0000;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Pass-through (No Echo Reference)", test_num);
        reset_dut();
        audio_in = 16'h1234;
        echo_ref = 16'h0000;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Simple Echo Cancellation Convergence", test_num);
        reset_dut();

        audio_in = 16'h2000;
        echo_ref = 16'h2000;

        repeat(200) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Signal Recovery from Echo", test_num);
        reset_dut();

        audio_in = 16'h1500;
        echo_ref = 16'h0500;

        repeat(500) @(posedge clk);
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Reset Mid-Operation", test_num);
        reset_dut();
        audio_in = 16'h4444;
        echo_ref = 16'h4444;
        repeat(100) @(posedge clk);

        reset = 1;
        @(posedge clk);
        reset = 0;
        audio_in = 16'h1111;
        echo_ref = 16'h0000;



        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Negative Values Cancellation", test_num);
        reset_dut();

        audio_in = 16'hF830;
        echo_ref = 16'hF830;
        repeat(500) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("EchoCancellation Testbench");
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
        $dumpvars(0,audio_in, clk, echo_ref, reset, audio_out);
    end

endmodule
