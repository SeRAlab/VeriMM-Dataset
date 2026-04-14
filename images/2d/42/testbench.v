`timescale 1ns/1ps

module audio_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg reset;
    wire [15:0] audio_out;

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
        audio_in = 16'h0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %03d: Basic 2-sample check...", test_num);
        reset_dut();
        audio_in = 16'hAAAA; @(posedge clk);
        audio_in = 16'hBBBB; @(posedge clk);
        #1 #1;
 check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %03d: 4-sample sequence check...", test_num);
        reset_dut();
        audio_in = 16'h1111; @(posedge clk);
        audio_in = 16'h2222; @(posedge clk);
        audio_in = 16'h3333; @(posedge clk);
        audio_in = 16'h4444; @(posedge clk);
        #1 #1;
 check_outputs(16'h3333);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %03d: 8-sample stream check...", test_num);
        reset_dut();
        audio_in = 16'h1; @(posedge clk);
        audio_in = 16'h2; @(posedge clk);
        audio_in = 16'h3; @(posedge clk);
        audio_in = 16'h4; @(posedge clk);
        audio_in = 16'h5; @(posedge clk);
        audio_in = 16'h6; @(posedge clk);
        audio_in = 16'h7; @(posedge clk);
        audio_in = 16'h8; @(posedge clk);
        #1 #1;
 check_outputs(16'h7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %03d: Boundary values (0x0000 and 0xFFFF)...", test_num);
        reset_dut();
        audio_in = 16'h0000; @(posedge clk);
        audio_in = 16'hFFFF; @(posedge clk);
        audio_in = 16'hFFFF; @(posedge clk);
        audio_in = 16'h0000; @(posedge clk);
        #1 #1;
 check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %03d: Constant input stability check...", test_num);
        reset_dut();
        audio_in = 16'h1234;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(16'h1234);
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
        $dumpvars(0,audio_in, clk, reset, audio_out);
    end

endmodule
