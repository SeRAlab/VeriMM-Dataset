`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_in;
    reg reset;
    reg scan_in;
    wire [1:0] binary_out;
    wire scan_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .reset(reset),
        .scan_in(scan_in),
        .binary_out(binary_out),
        .scan_out(scan_out)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            reset = 1;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase001: Input 1011, Scan 0 - Expect MSB 10, Scan 0");
            reset_dut();
            binary_in = 4'b1011;
            scan_in = 1'b0;
            #10;
            #1;

            check_outputs(2'b10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase002: Input 0110, Scan 1 - Expect MSB 01, Scan 1");
            reset_dut();
            binary_in = 4'b0110;
            scan_in = 1'b1;
            #10;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase003: Input 1100, Scan 0 - Expect MSB 11, Scan 0");
            reset_dut();
            binary_in = 4'b1100;
            scan_in = 1'b0;
            #10;
            #1;

            check_outputs(2'b11, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase004: Input 0001, Scan 1 - Expect MSB 00, Scan 1");
            reset_dut();
            binary_in = 4'b0001;
            scan_in = 1'b1;
            #10;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase005: Reset Override - Input 1111, Reset 1, Scan 1 - Expect 00, Scan 1");
            reset_dut();
            binary_in = 4'b1111;
            scan_in = 1'b1;
            reset = 1;
            #10;
            #1;

            check_outputs(2'b00, 1'b1);
            reset = 0;
            #10;
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
        input [1:0] expected_binary_out;
        input expected_scan_out;
        begin
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out) &&
                expected_scan_out === (expected_scan_out ^ scan_out ^ expected_scan_out)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h, scan_out=%b",
                         binary_out, scan_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h, scan_out=%b",
                         expected_binary_out, expected_scan_out);
                $display("  Got:      binary_out=%h, scan_out=%b",
                         binary_out, scan_out);
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
        $dumpvars(0,binary_in, reset, scan_in, binary_out, scan_out);
    end

endmodule
