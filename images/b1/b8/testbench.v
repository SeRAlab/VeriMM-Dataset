`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg clk;
    reg [3:0] in_port;
    reg reset_n;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .in_port(in_port),
        .reset_n(reset_n),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        address = 0;
        in_port = 0;
        @(posedge clk);
        #1;
        reset_n = 1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Verifying Reset State");
        reset_dut();
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Address 00, in_port 4'hA");
        reset_dut();
        address = 2'b00;
        in_port = 4'hA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000000A);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Address 01, in_port 4'h5");
        reset_dut();
        address = 2'b01;
        in_port = 4'h5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h00000005);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Address 10, in_port 4'hF");
        reset_dut();
        address = 2'b10;
        in_port = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000000F);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Address 11, in_port 4'h6");
        reset_dut();
        address = 2'b11;
        in_port = 4'h6;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000006);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Multiple sequential updates");
        reset_dut();

        address = 2'b00;
        in_port = 4'h3;
        @(posedge clk);
        #1;

        address = 2'b00;
        in_port = 4'hC;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000000C);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Reset override during active data");
        reset_dut();
        address = 2'b00;
        in_port = 4'hF;
        reset_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_readdata;
        begin
            if (expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: readdata=%h",
                         readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readdata=%h",
                         expected_readdata);
                $display("  Got:      readdata=%h",
                         readdata);
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
        $dumpvars(0,address, clk, in_port, reset_n, readdata);
    end

endmodule
