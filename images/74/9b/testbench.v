`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg rst;
    wire [7:0] out;
    wire [7:0] outP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .out(out),
        .outP(outP)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase 002: Shift 0xFF");
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                in = 1'b1;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase 003: Shift 0x00");
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                in = 1'b1;
                @(posedge clk);
                #1;
            end

            for (i = 0; i < 8; i = i + 1) begin
                in = 1'b0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        reg [7:0] data;
        integer i;
        begin
            test_num = 4;
            data = 8'hA5;
            $display("Testcase 004: Shift 0x%h", data);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                in = data[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase005;

        reg [7:0] data;
        integer i;
        begin
            test_num = 5;
            data = 8'h3C;
            $display("Testcase 005: Shift 0x%h", data);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                in = data[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h3C, 8'h3C);
        end
        endtask

    task testcase006;

        reg [7:0] data1;
        reg [7:0] data2;
        integer i;
        begin
            test_num = 6;
            data1 = 8'hAA;
            data2 = 8'h55;
            $display("Testcase 006: Continuous Shift (0xAA then 0x55)");
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                in = data1[i];
                @(posedge clk);
                #1;
            end

            for (i = 0; i < 8; i = i + 1) begin
                in = data2[i];
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase 007: Partial Shift and Reset");
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                in = 1'b1;
                @(posedge clk);
                #1;
            end

            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            #1;

            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_out;
        input [7:0] expected_outP;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_outP === (expected_outP ^ outP ^ expected_outP)) begin
                $display("PASS");
                $display("  Outputs: out=%h, outP=%h",
                         out, outP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, outP=%h",
                         expected_out, expected_outP);
                $display("  Got:      out=%h, outP=%h",
                         out, outP);
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
        $dumpvars(0,clk, in, rst, out, outP);
    end

endmodule
