`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    reg write;
    reg [15:0] writeData;
    wire [15:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .write(write),
        .writeData(writeData),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            write = 0;
            writeData = 0;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial Reset Check");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Write 0xABCD");
            reset_dut();
            write = 1;
            writeData = 16'hABCD;
            @(posedge clock);
            #1;
            write = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Hold data when write is 0");
            reset_dut();

            write = 1;
            writeData = 16'h1234;
            @(posedge clock);
            #1;

            write = 0;
            writeData = 16'hFFFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Successive Writes (0x0001 -> 0x8000)");
            reset_dut();
            write = 1;
            writeData = 16'h0001;
            @(posedge clock);
            #1;
            writeData = 16'h8000;
            @(posedge clock);
            #1;
            write = 0;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Writing 0xFFFF");
            reset_dut();
            write = 1;
            writeData = 16'hFFFF;
            @(posedge clock);
            #1;
            write = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Reset priority over Write");
            reset_dut();
            write = 1;
            writeData = 16'h5555;
            @(posedge clock);
            #1;
            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;
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
        input [15:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,clock, reset, write, writeData, data);
    end

endmodule
