`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg data;
    reg enable;
    reg rst;
    reg shift;
    wire [31:0] crc_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .data(data),
        .enable(enable),
        .rst(rst),
        .shift(shift),
        .crc_out(crc_out),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clr = 0;
            data = 0;
            enable = 0;
            shift = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Enable Signal Logic", test_num);
            reset_dut();
            data = 1;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Single Bit Processing (Data=0)", test_num);
            reset_dut();
            data = 0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFB3EE249, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Clear Signal Verification", test_num);
            reset_dut();

            data = 0;
            enable = 1;
            @(posedge clk);
            #1;

            clr = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Shift Operation and Serial Out", test_num);
            reset_dut();

            data = 0;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            shift = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hF67DC492, 1'b1);
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
        input [31:0] expected_crc_out;
        input expected_serial_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, serial_out=%b",
                         crc_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, serial_out=%b",
                         expected_crc_out, expected_serial_out);
                $display("  Got:      crc_out=%h, serial_out=%b",
                         crc_out, serial_out);
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
        $dumpvars(0,clk, clr, data, enable, rst, shift, crc_out, serial_out);
    end

endmodule
