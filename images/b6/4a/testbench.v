`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_data;
    reg clk;
    reg [3:0] ctrl;
    wire [15:0] encoded_data;
    wire [1:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio_data(audio_data),
        .clk(clk),
        .ctrl(ctrl),
        .encoded_data(encoded_data),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            audio_data = 16'h0;
            ctrl = 4'h0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: MP3 Encoding Mode");
            reset_dut();
            audio_data = 16'hA5A5;
            ctrl = 4'b1000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: AAC Encoding Mode");
            reset_dut();
            audio_data = 16'h1234;
            ctrl = 4'b1001;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234, 2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: WMA Encoding Mode");
            reset_dut();
            audio_data = 16'hFFFF;
            ctrl = 4'b1010;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF, 2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: MP3 Decoding Mode");
            reset_dut();
            audio_data = 16'h55AA;
            ctrl = 4'b0000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Invalid Control Signal Error Handling");
            reset_dut();
            audio_data = 16'hBEEF;
            ctrl = 4'b1111;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 2'b11);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Zero Data Input");
            reset_dut();
            audio_data = 16'h0000;
            ctrl = 4'b1000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Rapid Control Switching");
            reset_dut();
            audio_data = 16'h7777;
            ctrl = 4'b1001;
            @(posedge clk);
            ctrl = 4'b0001;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7777, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_encoded_data;
        input [1:0] expected_status;
        begin
            if (expected_encoded_data === (expected_encoded_data ^ encoded_data ^ expected_encoded_data) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: encoded_data=%h, status=%h",
                         encoded_data, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_data=%h, status=%h",
                         expected_encoded_data, expected_status);
                $display("  Got:      encoded_data=%h, status=%h",
                         encoded_data, status);
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
        $dumpvars(0,audio_data, clk, ctrl, encoded_data, status);
    end

endmodule
