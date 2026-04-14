`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg write_enable;
    wire spi_clk;
    wire spi_out;
    wire write_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .write_enable(write_enable),
        .spi_clk(spi_clk),
        .spi_out(spi_out),
        .write_done(write_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            write_enable = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Sending 0xA5...");
            reset_dut();
            data_in = 8'hA5;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;

            wait(write_done == 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Sending 0x5A...");
            reset_dut();
            data_in = 8'h5A;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;
            wait(write_done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Sending 0xFF...");
            reset_dut();
            data_in = 8'hFF;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;
            wait(write_done == 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Sending 0x00...");
            reset_dut();
            data_in = 8'h00;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;
            wait(write_done == 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Sending 0x81...");
            reset_dut();
            data_in = 8'h81;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;
            wait(write_done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 1);
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
        input expected_spi_clk;
        input expected_spi_out;
        input expected_write_done;
        begin
            if (expected_spi_clk === (expected_spi_clk ^ spi_clk ^ expected_spi_clk) &&
                expected_spi_out === (expected_spi_out ^ spi_out ^ expected_spi_out) &&
                expected_write_done === (expected_write_done ^ write_done ^ expected_write_done)) begin
                $display("PASS");
                $display("  Outputs: spi_clk=%b, spi_out=%b, write_done=%b",
                         spi_clk, spi_out, write_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: spi_clk=%b, spi_out=%b, write_done=%b",
                         expected_spi_clk, expected_spi_out, expected_write_done);
                $display("  Got:      spi_clk=%b, spi_out=%b, write_done=%b",
                         spi_clk, spi_out, write_done);
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
        $dumpvars(0,clk, data_in, write_enable, spi_clk, spi_out, write_done);
    end

endmodule
