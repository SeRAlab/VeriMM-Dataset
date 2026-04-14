`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce_n;
    reg [7:0] data;
    reg read_n;
    reg reset_n;
    reg write_n;
    wire [7:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce_n(ce_n),
        .data(data),
        .read_n(read_n),
        .reset_n(reset_n),
        .write_n(write_n),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        ce_n = 0;
        forever #5 ce_n = ~ce_n;
    end

        task reset_dut;

        begin
            reset_n = 0;
            write_n = 1;
            read_n = 1;
            data = 8'h00;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            wait(ce_n == 0);
            #1;
            $display("Testcase 001: Reset State (ce_n=0)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 8'hAA;
            write_n = 0;
            #10;
            write_n = 1;

            wait(ce_n == 0);
            #1;
            $display("Testcase 002: Write 0xAA, check inverted output");
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 8'h55;
            write_n = 0;
            #10;
            write_n = 1;

            wait(ce_n == 0);
            #1;
            $display("Testcase 003: Write 0x55, check inverted output");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 8'h12;
            write_n = 0;
            #10;
            write_n = 1;

            wait(ce_n == 1);
            #1;
            $display("Testcase 004: ce_n=1 (Active) overrides output to 0xFF");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 8'hFF;
            write_n = 0;
            #10;
            write_n = 1;

            wait(ce_n == 0);
            #1;
            $display("Testcase 005: Write 0xFF, check inverted output (0x00)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 8'h00;
            write_n = 0;
            #10;
            write_n = 1;

            wait(ce_n == 1);
            #1;
            $display("Testcase 006: Write 0x00, check ce_n=1 logic");
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_leds;
        begin
            if (expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: leds=%h",
                         leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h",
                         expected_leds);
                $display("  Got:      leds=%h",
                         leds);
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
        $dumpvars(0,ce_n, data, read_n, reset_n, write_n, leds);
    end

endmodule
