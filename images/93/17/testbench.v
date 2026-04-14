`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg [31:0] din;
    reg enable;
    reg read_write;
    reg reset;
    reg [1:0] size;
    wire [31:0] dout;
    wire [31:0] lighting;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .din(din),
        .enable(enable),
        .read_write(read_write),
        .reset(reset),
        .size(size),
        .dout(dout),
        .lighting(lighting)
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
            address = 0;
            din = 0;
            read_write = 0;
            size = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset and Initial Read");
            reset_dut();
            enable = 1;
            read_write = 0;
            address = 32'h0000_0010;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Word Write and Read");
            reset_dut();
            enable = 1;
            read_write = 1;
            size = 2'b00;
            address = 32'h0000_0020;
            din = 32'hAAAA_BBBB;
            @(posedge clk); #1;

            read_write = 0;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'hAAAA_BBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Double Word Write");
            reset_dut();
            enable = 1;
            read_write = 1;
            size = 2'b01;
            address = 32'h0000_0030;
            din = 32'h1234_5678;
            @(posedge clk); #1;


            read_write = 0;
            address = 32'h0000_0031;
            #1;

            check_outputs(32'h1234_5678, 32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Quad Word Write");
            reset_dut();
            enable = 1;
            read_write = 1;
            size = 2'b10;
            address = 32'h0000_0040;
            din = 32'hDEAF_BEEF;
            @(posedge clk); #1;


            read_write = 0;
            address = 32'h0000_0043;
            #1;

            check_outputs(32'hDEAF_BEEF, 32'hDEAF_BEEF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable Signal Check");
            reset_dut();
            enable = 0;
            read_write = 1;
            address = 32'h0000_0050;
            din = 32'hFFFF_FFFF;
            @(posedge clk); #1;

            enable = 1;
            read_write = 0;
            #1;

            check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_dout;
        input [31:0] expected_lighting;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_lighting === (expected_lighting ^ lighting ^ expected_lighting)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, lighting=%h",
                         dout, lighting);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, lighting=%h",
                         expected_dout, expected_lighting);
                $display("  Got:      dout=%h, lighting=%h",
                         dout, lighting);
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
        $dumpvars(0,address, clk, din, enable, read_write, reset, size, dout, lighting);
    end

endmodule
