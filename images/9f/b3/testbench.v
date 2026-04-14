`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dec;
    reg inc;
    reg [7:0] wiper;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dec(dec),
        .inc(inc),
        .wiper(wiper),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        dec = 0;
        forever #5 dec = ~dec;
    end

        task reset_dut;

        begin
            wiper = 8'd128;
            inc = 0;

            @(posedge dec);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Decrement");
            test_num = 1;
            reset_dut();
            inc = 0;


            repeat(10) @(posedge dec);
            #2;
            #1;

            check_outputs(8'd118);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Increment");
            test_num = 2;
            reset_dut();
            inc = 1;


            repeat(20) @(posedge dec);
            #2;
            #1;

            check_outputs(8'd148);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Saturation at Max");
            test_num = 3;
            reset_dut();
            wiper = 8'd250;
            inc = 1;

            repeat(10) @(posedge dec);
            #2;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Saturation at Min");
            test_num = 4;
            reset_dut();
            wiper = 8'd5;
            inc = 0;

            repeat(10) @(posedge dec);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load New Value");
            test_num = 5;
            reset_dut();
            wiper = 8'hA5;


            @(posedge dec);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Direction Switch");
            test_num = 6;
            reset_dut();
            inc = 1;
            repeat(10) @(posedge dec);
            inc = 0;
            repeat(5) @(posedge dec);
            #2;
            #1;

            check_outputs(8'd133);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,dec, inc, wiper, out);
    end

endmodule
