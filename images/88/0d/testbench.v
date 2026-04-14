`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg enable;
    reg reset;
    wire [7:0] crc_out;
    wire [7:0] data_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .crc_out(crc_out),
        .data_out(data_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            @(posedge enable);
            #1;
            reset = 0;
            @(posedge enable);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset and Initial State");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Single Data Word 0x01");
            test_num = 2;
            reset_dut();
            data_in = 8'h01;
            @(posedge enable);
            #1;

            #1;


            check_outputs(8'h07, 8'h01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Data Transparency Check");
            test_num = 3;
            reset_dut();
            data_in = 8'hA5;
            @(posedge enable);
            #1;

            if (data_out === 8'hA5) begin
                $display("Data Transparency: PASS");
            end else begin
                $display("Data Transparency: FAIL");
            end


            #1;



            check_outputs(8'hBC, 8'hA5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Multiple Data Words (0x01 -> 0x02)");
            test_num = 4;
            reset_dut();


            data_in = 8'h01;
            @(posedge enable);
            #1;


            data_in = 8'h02;
            @(posedge enable);
            #1;


            #1;



            check_outputs(8'h0F, 8'h02, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Zero Data Input");
            test_num = 5;
            reset_dut();
            data_in = 8'h00;
            @(posedge enable);
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Reset Mid-Operation");
            test_num = 6;
            reset_dut();

            data_in = 8'hFF;
            @(posedge enable);
            #1;

            reset = 1;
            @(posedge enable);
            #1;
            reset = 0;


            #1;



            check_outputs(8'h00, 8'h00, 1'b0);
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
        input [7:0] expected_crc_out;
        input [7:0] expected_data_out;
        input expected_error;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, data_out=%h, error=%b",
                         crc_out, data_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, data_out=%h, error=%b",
                         expected_crc_out, expected_data_out, expected_error);
                $display("  Got:      crc_out=%h, data_out=%h, error=%b",
                         crc_out, data_out, error);
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
        $dumpvars(0,data_in, enable, reset, crc_out, data_out, error);
    end

endmodule
