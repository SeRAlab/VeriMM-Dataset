`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] din_data;
    reg din_last;
    reg din_valid;
    reg dout_ready;
    wire din_ready;
    wire [63:0] dout_data;
    wire dout_last;
    wire dout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_data(din_data),
        .din_last(din_last),
        .din_valid(din_valid),
        .dout_ready(dout_ready),
        .din_ready(din_ready),
        .dout_data(dout_data),
        .dout_last(dout_last),
        .dout_valid(dout_valid)
    );

    // Clock generation (10ns period)
    initial begin
        din_valid = 0;
        forever #5 din_valid = ~din_valid;
    end

        task reset_dut;

        begin
            din_data = 64'h0;
            din_last = 1'b0;
            dout_ready = 1'b0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase 001: Basic Data Capture...");
            din_data = 64'hCAFE_BABE_DEAD_BEEF;
            din_last = 1'b0;
            dout_ready = 1'b1;
            #10;

            #1;


            check_outputs(1'b0, 64'hCAFE_BABE_DEAD_BEEF, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase 002: Last Signal Propagation...");
            din_data = 64'hAAAA_BBBB_CCCC_DDDD;
            din_last = 1'b1;
            dout_ready = 1'b1;
            #10;

            #1;


            check_outputs(1'b0, 64'hAAAA_BBBB_CCCC_DDDD, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase 003: Clearing Valid Signal...");

            din_data = 64'h5555_AAAA_5555_AAAA;
            dout_ready = 1'b1;
            #10;

            dout_ready = 1'b1;
            #10;

            #1;


            check_outputs(1'b1, 64'h5555_AAAA_5555_AAAA, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase 004: Buffer Blocking (dout_ready=0)...");
            din_data = 64'hEEEE_EEEE_EEEE_EEEE;
            din_last = 1'b0;
            dout_ready = 1'b0;
            #20;

            #1;


            check_outputs(1'b1, 64'h0, 1'b0, 1'b0);
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
        input expected_din_ready;
        input [63:0] expected_dout_data;
        input expected_dout_last;
        input expected_dout_valid;
        begin
            if (expected_din_ready === (expected_din_ready ^ din_ready ^ expected_din_ready) &&
                expected_dout_data === (expected_dout_data ^ dout_data ^ expected_dout_data) &&
                expected_dout_last === (expected_dout_last ^ dout_last ^ expected_dout_last) &&
                expected_dout_valid === (expected_dout_valid ^ dout_valid ^ expected_dout_valid)) begin
                $display("PASS");
                $display("  Outputs: din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b",
                         din_ready, dout_data, dout_last, dout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b",
                         expected_din_ready, expected_dout_data, expected_dout_last, expected_dout_valid);
                $display("  Got:      din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b",
                         din_ready, dout_data, dout_last, dout_valid);
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
        $dumpvars(0,din_data, din_last, din_valid, dout_ready, din_ready, dout_data, dout_last, dout_valid);
    end

endmodule
