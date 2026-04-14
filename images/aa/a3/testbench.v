`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg [4:0] shift_amount;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 32'b0;
            shift_amount = 5'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 32'hFFFFFFFF;
            shift_amount = 5'd5;
            reset = 1;
            @(posedge clk);
            #1;
            $display("Testcase 001: Reset logic check");
            #1;

            check_outputs(32'h00000000);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 32'h12345678;
            shift_amount = 5'b00000;
            @(posedge clk);
            #1;
            $display("Testcase 002: Shift by 0");
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 32'h00000001;
            shift_amount = 5'b00001;
            @(posedge clk);
            #1;
            $display("Testcase 003: Left Shift by 1");
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 32'h00000001;
            shift_amount = 5'b01111;
            @(posedge clk);
            #1;
            $display("Testcase 004: Left Shift by 15");
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 32'h80000000;
            shift_amount = 5'b11111;
            @(posedge clk);
            #1;
            $display("Testcase 005: Arithmetic Right Shift -1 (Negative data)");
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 32'h000000F0;
            shift_amount = 5'b11100;
            @(posedge clk);
            #1;
            $display("Testcase 006: Arithmetic Right Shift -4 (Positive data)");
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_in = 32'h80000000;
            shift_amount = 5'b10000;
            @(posedge clk);
            #1;
            $display("Testcase 007: Arithmetic Right Shift -16 (Max negative amount)");
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data_in = 32'hAAAA_AAAA;
            shift_amount = 5'b00100;
            @(posedge clk);
            #1;
            $display("Testcase 008: Left Shift 4 of Pattern AAAA_AAAA");
            #1;

            check_outputs(32'hAAAA_AAA0);
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, shift_amount, data_out);
    end

endmodule
