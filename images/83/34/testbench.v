`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] rd0_addr;
    reg [9:0] rd1_addr;
    reg [9:0] rd2_addr;
    reg [9:0] wr0_addr;
    reg [31:0] wr0_data;
    reg [3:0] wr0_en;
    wire [31:0] rd0_data;
    wire [31:0] rd1_data;
    wire [31:0] rd2_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd0_addr(rd0_addr),
        .rd1_addr(rd1_addr),
        .rd2_addr(rd2_addr),
        .wr0_addr(wr0_addr),
        .wr0_data(wr0_data),
        .wr0_en(wr0_en),
        .rd0_data(rd0_data),
        .rd1_data(rd1_data),
        .rd2_data(rd2_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rd0_addr = 0;
            rd1_addr = 0;
            rd2_addr = 0;
            wr0_addr = 0;
            wr0_data = 0;
            wr0_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write and Triple Read...");
            reset_dut();


            wr0_addr = 10'd50;
            wr0_data = 32'hDEADBEEF;
            wr0_en = 4'b1111;
            @(posedge clk);
            #1;
            wr0_en = 4'b0000;


            rd0_addr = 10'd50;
            rd1_addr = 10'd50;
            rd2_addr = 10'd50;
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Byte Enable (Lower 16 bits)...");
            reset_dut();


            wr0_addr = 10'd100;
            wr0_data = 32'h00000000;
            wr0_en = 4'b1111;
            @(posedge clk);
            #1;


            wr0_data = 32'hFFFFABCD;
            wr0_en = 4'b0011;
            @(posedge clk);
            #1;
            wr0_en = 0;

            rd0_addr = 10'd100;
            rd1_addr = 10'd0;
            rd2_addr = 10'd0;
            #2;

            #1;


            check_outputs(32'h0000ABCD, 32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Simultaneous Read from Different Addresses...");
            reset_dut();


            wr0_addr = 10'd1; wr0_data = 32'h11111111; wr0_en = 4'b1111;
            @(posedge clk); #1;

            wr0_addr = 10'd2; wr0_data = 32'h22222222; wr0_en = 4'b1111;
            @(posedge clk); #1;

            wr0_addr = 10'd3; wr0_data = 32'h33333333; wr0_en = 4'b1111;
            @(posedge clk); #1;
            wr0_en = 0;

            rd0_addr = 10'd1;
            rd1_addr = 10'd2;
            rd2_addr = 10'd3;
            #2;

            #1;


            check_outputs(32'h11111111, 32'h22222222, 32'h33333333);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Selective Byte Update...");
            reset_dut();


            wr0_addr = 10'd500;
            wr0_data = 32'hAAAAAAAA;
            wr0_en = 4'b1111;
            @(posedge clk); #1;


            wr0_data = 32'h00555500;
            wr0_en = 4'b0110;
            @(posedge clk); #1;
            wr0_en = 0;

            rd0_addr = 10'd500;
            #2;

            #1;


            check_outputs(32'hAA5555AA, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Maximum Address Boundary...");
            reset_dut();

            wr0_addr = 10'd1023;
            wr0_data = 32'hA5A5A5A5;
            wr0_en = 4'b1111;
            @(posedge clk); #1;
            wr0_en = 0;

            rd2_addr = 10'd1023;
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'hA5A5A5A5);
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
        input [31:0] expected_rd0_data;
        input [31:0] expected_rd1_data;
        input [31:0] expected_rd2_data;
        begin
            if (expected_rd0_data === (expected_rd0_data ^ rd0_data ^ expected_rd0_data) &&
                expected_rd1_data === (expected_rd1_data ^ rd1_data ^ expected_rd1_data) &&
                expected_rd2_data === (expected_rd2_data ^ rd2_data ^ expected_rd2_data)) begin
                $display("PASS");
                $display("  Outputs: rd0_data=%h, rd1_data=%h, rd2_data=%h",
                         rd0_data, rd1_data, rd2_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd0_data=%h, rd1_data=%h, rd2_data=%h",
                         expected_rd0_data, expected_rd1_data, expected_rd2_data);
                $display("  Got:      rd0_data=%h, rd1_data=%h, rd2_data=%h",
                         rd0_data, rd1_data, rd2_data);
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
        $dumpvars(0,clk, rd0_addr, rd1_addr, rd2_addr, wr0_addr, wr0_data, wr0_en, rd0_data, rd1_data, rd2_data);
    end

endmodule
