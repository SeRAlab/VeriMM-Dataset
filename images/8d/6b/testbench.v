`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control;
    reg [7:0] data_in;
    reg rst_n;
    wire [7:0] data_out;
    wire [3:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .rst_n(rst_n),
        .data_out(data_out),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1;
            #2 rst_n = 0;
            #10 rst_n = 1;
            control = 4'h0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift Left");
            reset_dut();
            data_in = 8'h01;
            control = 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02, 4'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Right");
            reset_dut();
            data_in = 8'h80;
            control = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h40, 4'h2);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise Inversion");
            reset_dut();
            data_in = 8'hAA;
            control = 4'h3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Set All Ones");
            reset_dut();
            data_in = 8'h00;
            control = 4'h4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 4'h4);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Left Overflow");
            reset_dut();
            data_in = 8'h80;
            control = 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 4'h1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift Right Underflow");
            reset_dut();
            data_in = 8'h01;
            control = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 4'h2);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Invert All Ones");
            reset_dut();
            data_in = 8'hFF;
            control = 4'h3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 4'h3);
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
        testcase008();
        
        
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
        input [7:0] expected_data_out;
        input [3:0] expected_status;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, status=%h",
                         data_out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, status=%h",
                         expected_data_out, expected_status);
                $display("  Got:      data_out=%h, status=%h",
                         data_out, status);
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
        $dumpvars(0,clk, control, data_in, rst_n, data_out, status);
    end

endmodule
