`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg clk;
    reg rst;
    wire [7:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .clk(clk),
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
        audio_in1 = 0;
        audio_in2 = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Minimum values (0, 0)", test_num);
        reset_dut();
        audio_in1 = 8'd0;
        audio_in2 = 8'd0;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Maximum values (255, 255)", test_num);
        reset_dut();
        audio_in1 = 8'd255;
        audio_in2 = 8'd255;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd255);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Simple average (100, 200)", test_num);
        reset_dut();
        audio_in1 = 8'd100;
        audio_in2 = 8'd200;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd150);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Odd sum truncation (0, 255)", test_num);
        reset_dut();
        audio_in1 = 8'd0;
        audio_in2 = 8'd255;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd127);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Power of two values (64, 128)", test_num);
        reset_dut();
        audio_in1 = 8'd64;
        audio_in2 = 8'd128;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd96);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Values near limit (254, 255)", test_num);
        reset_dut();
        audio_in1 = 8'd254;
        audio_in2 = 8'd255;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd254);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: One zero value (128, 0)", test_num);
        reset_dut();
        audio_in1 = 8'd128;
        audio_in2 = 8'd0;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd64);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mixer Testbench");
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
        input [7:0] expected_audio_out;
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
        $dumpvars(0,audio_in1, audio_in2, clk, rst, audio_out);
    end

endmodule
