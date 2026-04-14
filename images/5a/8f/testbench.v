`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg parallel_load;
    reg serial_in;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .parallel_load(parallel_load),
        .serial_in(serial_in),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            parallel_load = 1;
            data_in = 4'b0000;
            serial_in = 0;
            @(posedge clk);
            #1;
            parallel_load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            parallel_load = 1;
            data_in = 4'b1011;
            @(posedge clk);
            #1;
            $display("Testcase 001: Load 4'b1011");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            parallel_load = 1;
            data_in = 4'b1100;
            @(posedge clk);
            #1;
            $display("Testcase 002: Load 4'b1100");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            parallel_load = 0;
            serial_in = 1;
            @(posedge clk);
            #1;
            $display("Testcase 003: Shift In 1 (Reg 0000 -> 0001)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            parallel_load = 1;
            data_in = 4'b1111;
            @(posedge clk);
            #1;
            parallel_load = 0;
            serial_in = 0;
            @(posedge clk);
            #1;
            $display("Testcase 004: Load 1111 then Shift In 0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            parallel_load = 0;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 0; @(posedge clk); #1;
            $display("Testcase 005: Multi-shift (In 1, 1, 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            parallel_load = 1;
            data_in = 4'b1010;
            serial_in = 1;
            @(posedge clk);
            #1;
            $display("Testcase 006: Load Priority Check");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, data_in, parallel_load, serial_in, serial_out);
    end

endmodule
