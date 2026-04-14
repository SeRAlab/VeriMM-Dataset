`timescale 1ns/1ps

module PLL_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    reg signal_in;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PLL dut (
        .clk_in(clk_in),
        .reset(reset),
        .signal_in(signal_in),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            signal_in = 0;
            #(CLK_PERIOD * 10);
            reset = 0;
            #(CLK_PERIOD * 5);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Lock to 10MHz nominal signal...");
            reset_dut();
            test_num = 1;


            repeat(200) begin
                signal_in = 1; #50;
                signal_in = 0; #50;
            end



            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Lock to 20MHz (Fast) signal...");
            reset_dut();
            test_num = 2;

            repeat(400) begin
                signal_in = 1; #25;
                signal_in = 0; #25;
            end

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Lock to 5MHz (Slow) signal...");
            reset_dut();
            test_num = 3;

            repeat(100) begin
                signal_in = 1; #100;
                signal_in = 0; #100;
            end

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Frequency Step Response (10MHz -> 12.5MHz)...");
            reset_dut();
            test_num = 4;


            repeat(100) begin
                signal_in = 1; #50;
                signal_in = 0; #50;
            end


            repeat(200) begin
                signal_in = 1; #40;
                signal_in = 0; #40;
            end

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Phase Shift tracking...");
            reset_dut();
            test_num = 5;


            repeat(100) begin
                signal_in = 1; #50;
                signal_in = 0; #50;
            end


            #25;

            repeat(200) begin
                signal_in = 1; #50;
                signal_in = 0; #50;
            end

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PLL Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, reset, signal_in, clk_out);
    end

endmodule
