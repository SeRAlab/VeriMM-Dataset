`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] addr0_i;
    reg [10:0] addr1_i;
    reg clk0_i;
    reg clk1_i;
    reg [31:0] data0_i;
    reg [31:0] data1_i;
    reg rst0_i;
    reg rst1_i;
    reg [3:0] wr0_i;
    reg [3:0] wr1_i;
    wire [31:0] data0_o;
    wire [31:0] data1_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0_i(addr0_i),
        .addr1_i(addr1_i),
        .clk0_i(clk0_i),
        .clk1_i(clk1_i),
        .data0_i(data0_i),
        .data1_i(data1_i),
        .rst0_i(rst0_i),
        .rst1_i(rst1_i),
        .wr0_i(wr0_i),
        .wr1_i(wr1_i),
        .data0_o(data0_o),
        .data1_o(data1_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk0_i = 0;
        forever #5 clk0_i = ~clk0_i;
    end

        task reset_dut;

    begin
        rst0_i = 1;
        rst1_i = 1;
        addr0_i = 0;
        addr1_i = 0;
        data0_i = 0;
        data1_i = 0;
        wr0_i = 0;
        wr1_i = 0;
        #20;
        rst0_i = 0;
        rst1_i = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Write to Port 0, Read from Port 0");
        reset_dut();
        @(posedge clk0_i);
        addr0_i = 11'h0A5;
        data0_i = 32'hDEADBEEF;
        wr0_i = 4'hF;
        @(posedge clk0_i);
        wr0_i = 4'h0;
        addr0_i = 11'h0A5;
        @(posedge clk0_i);
        #1;
        #1;

        check_outputs(32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Write to Port 1, Read from Port 1");
        reset_dut();
        @(posedge clk1_i);
        addr1_i = 11'h7FE;
        data1_i = 32'hCAFEBABE;
        wr1_i = 4'hF;
        @(posedge clk1_i);
        wr1_i = 4'h0;
        addr1_i = 11'h7FE;
        @(posedge clk1_i);
        #1;
        #1;

        check_outputs(32'h0, 32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Byte-wise Write Enable on Port 0");
        reset_dut();

        @(posedge clk0_i);
        addr0_i = 11'h100;
        data0_i = 32'h0;
        wr0_i = 4'hF;
        @(posedge clk0_i);

        addr0_i = 11'h100;
        data0_i = 32'h11223344;
        wr0_i = 4'h5;
        @(posedge clk0_i);

        addr0_i = 11'h100;
        data0_i = 32'hAABBCCDD;
        wr0_i = 4'hA;
        @(posedge clk0_i);
        wr0_i = 4'h0;
        @(posedge clk0_i);
        #1;

        #1;


        check_outputs(32'hAA22CC44, 32'h0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Port 0 Write, Port 1 Read same address");
        reset_dut();
        @(posedge clk0_i);
        addr0_i = 11'h200;
        data0_i = 32'h12345678;
        wr0_i = 4'hF;
        @(posedge clk0_i);
        wr0_i = 4'h0;
        addr1_i = 11'h200;
        @(posedge clk1_i);
        #1;
        #1;

        check_outputs(32'h0, 32'h12345678);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Independent operations on both ports");
        reset_dut();
        @(posedge clk0_i);
        addr0_i = 11'h001;
        data0_i = 32'hAAAA_AAAA;
        wr0_i = 4'hF;
        addr1_i = 11'h002;
        data1_i = 32'hBBBB_BBBB;
        wr1_i = 4'hF;
        @(posedge clk0_i);
        wr0_i = 0;
        wr1_i = 0;
        addr0_i = 11'h002;
        addr1_i = 11'h001;
        @(posedge clk0_i);
        #1;
        #1;

        check_outputs(32'hBBBB_BBBB, 32'hAAAA_AAAA);
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
        input [31:0] expected_data0_o;
        input [31:0] expected_data1_o;
        begin
            if (expected_data0_o === (expected_data0_o ^ data0_o ^ expected_data0_o) &&
                expected_data1_o === (expected_data1_o ^ data1_o ^ expected_data1_o)) begin
                $display("PASS");
                $display("  Outputs: data0_o=%h, data1_o=%h",
                         data0_o, data1_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data0_o=%h, data1_o=%h",
                         expected_data0_o, expected_data1_o);
                $display("  Got:      data0_o=%h, data1_o=%h",
                         data0_o, data1_o);
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
        $dumpvars(0,addr0_i, addr1_i, clk0_i, clk1_i, data0_i, data1_i, rst0_i, rst1_i, wr0_i, wr1_i, data0_o, data1_o);
    end

endmodule
