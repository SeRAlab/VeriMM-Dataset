`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg load;
    reg [7:0] parallel_data_in;
    reg parallel_load;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .parallel_data_in(parallel_data_in),
        .parallel_load(parallel_load),
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
            parallel_data_in = 8'h00;
            load = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            parallel_load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Parallel Load 0xA5 (10100101)");
            reset_dut();
            parallel_load = 1;
            parallel_data_in = 8'hA5;
            @(posedge clk);
            #1;
            parallel_load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Parallel Load 0x5A (01011010)");
            reset_dut();
            parallel_load = 1;
            parallel_data_in = 8'h5A;
            @(posedge clk);
            #1;
            parallel_load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Load High - Shift 1 into MSB");
            reset_dut();
            load = 1;
            data_in = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Load High - Shift 0 into MSB of 0xFF");

            parallel_load = 1;
            parallel_data_in = 8'hFF;
            @(posedge clk);
            #1;
            parallel_load = 0;

            load = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Default Shift - Shift 1 from LSB to MSB");
            reset_dut();
            load = 0;
            parallel_load = 0;
            data_in = 1;
            @(posedge clk);
            #1;
            data_in = 0;

            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Parallel Load Priority over Load");
            reset_dut();
            parallel_data_in = 8'h80;
            parallel_load = 1;
            load = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            parallel_load = 0;
            load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Shift Left Sequence");
            reset_dut();
            parallel_data_in = 8'h40;
            parallel_load = 1;
            @(posedge clk);
            #1;
            parallel_load = 0;

            load = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        $dumpvars(0,clk, data_in, load, parallel_data_in, parallel_load, serial_out);
    end

endmodule
