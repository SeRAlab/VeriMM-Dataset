`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] framesize;
    reg in;
    reg reset;
    wire complete;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .framesize(framesize),
        .in(in),
        .reset(reset),
        .complete(complete),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        framesize = 0;
        in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task send_serial_data;

        input [31:0] data;
        input [7:0] len;
        integer i;
        begin
            for (i = 0; i < len; i = i + 1) begin
                enable = 1;
                in = data[i];
                @(posedge clk);
                #1;
            end
            enable = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: 8-bit deserialization (Data: 0xA5)");
        reset_dut();
        framesize = 8;
        send_serial_data(32'h000000A5, 8);

        #1;


        check_outputs(1'b1, 32'h000000A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: 16-bit deserialization (Data: 0x1234)");
        reset_dut();
        framesize = 16;
        send_serial_data(32'h00001234, 16);
        #1;

        check_outputs(1'b1, 32'h00001234);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: 32-bit deserialization (Data: 0xDEADBEEF)");
        reset_dut();
        framesize = 32;
        send_serial_data(32'hDEADBEEF, 32);
        #1;

        check_outputs(1'b1, 32'hDEADBEEF);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase 004: Enable signal suspension mid-stream");
        reset_dut();
        framesize = 4;


        enable = 1;
        in = 1; @(posedge clk); #1;
        in = 0; @(posedge clk); #1;


        enable = 0;
        in = 1;
        repeat(3) @(posedge clk);
        #1;


        enable = 1;
        in = 1; @(posedge clk); #1;
        in = 1; @(posedge clk); #1;
        enable = 0;


        #1;



        check_outputs(1'b1, 32'h0000000D);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Reset during operation");
        reset_dut();
        framesize = 8;


        enable = 1;
        in = 1; @(posedge clk); #1;
        in = 1; @(posedge clk); #1;


        reset = 1;
        @(posedge clk);
        #1 reset = 0;


        framesize = 2;
        send_serial_data(32'h2, 2);
        #1;

        check_outputs(1'b1, 32'h00000002);
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
        input expected_complete;
        input [31:0] expected_out;
        begin
            if (expected_complete === (expected_complete ^ complete ^ expected_complete) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: complete=%b, out=%h",
                         complete, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: complete=%b, out=%h",
                         expected_complete, expected_out);
                $display("  Got:      complete=%b, out=%h",
                         complete, out);
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
        $dumpvars(0,clk, enable, framesize, in, reset, complete, out);
    end

endmodule
