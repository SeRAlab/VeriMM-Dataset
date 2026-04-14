`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    wire [4:0] str;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .str(str)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 16'hFFFF;
            @(posedge clk);
            data = 16'h0000;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task send_dot;

        input integer duration;
        begin
            repeat(duration) begin
                data = 16'h0001;
                @(posedge clk);
            end
            data = 16'h0000;
            @(posedge clk);
        end
        endtask

    task send_pause;

        input integer duration;
        begin
            repeat(duration) begin
                data = 16'h0000;
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: 5 Standard Dots");
            reset_dut();
            send_dot(1);
            send_dot(1);
            send_dot(1);
            send_dot(1);
            send_dot(1);


            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Incomplete sequence (3 Dots)");
            reset_dut();
            send_dot(1);
            send_dot(1);
            send_dot(1);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: 5 Long Duration Dots");
            reset_dut();
            send_dot(3);
            send_dot(3);
            send_dot(3);
            send_dot(3);
            send_dot(3);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Interrupted and Restarted sequence");
            reset_dut();
            send_dot(1);
            send_dot(1);


            reset_dut();


            send_dot(1);
            send_dot(1);
            send_dot(1);
            send_dot(1);
            send_dot(1);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Sequence with extended pauses");
            reset_dut();
            send_dot(1);
            send_pause(5);
            send_dot(1);
            send_pause(5);
            send_dot(1);
            send_pause(5);
            send_dot(1);
            send_pause(5);
            send_dot(1);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'h1F);
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
        input [4:0] expected_str;
        begin
            if (expected_str === (expected_str ^ str ^ expected_str)) begin
                $display("PASS");
                $display("  Outputs: str=%h",
                         str);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: str=%h",
                         expected_str);
                $display("  Got:      str=%h",
                         str);
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
        $dumpvars(0,clk, data, str);
    end

endmodule
