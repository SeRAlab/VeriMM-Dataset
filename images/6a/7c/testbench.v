`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [5:0] final_output;
    wire [1:0] pos;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .read_addr(read_addr),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .final_output(final_output),
        .pos(pos),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        in = 0;
        write_en = 0;
        write_addr = 0;
        write_data = 0;
        read_en = 0;
        read_addr = 0;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset Verification");
        reset_dut();

        #1;


        check_outputs(6'b000000, 2'b00, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Priority 3 and RAM Access");
        reset_dut();


        @(posedge clk);
        write_en = 1;
        write_addr = 8'h05;
        write_data = 4'hA;
        in = 4'b1000;

        @(posedge clk);
        write_en = 0;
        read_en = 1;
        read_addr = 8'h05;

        @(posedge clk);
        #1;

        #1;


        check_outputs(6'h2A, 2'b11, 4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Priority 2 and RAM Access");
        reset_dut();

        @(posedge clk);
        write_en = 1;
        write_addr = 8'h02;
        write_data = 4'h5;
        in = 4'b0110;

        @(posedge clk);
        write_en = 0;
        read_en = 1;
        read_addr = 8'h02;

        @(posedge clk);
        #1;

        #1;


        check_outputs(6'h35, 2'b10, 4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Priority 1 and RAM Access");
        reset_dut();

        @(posedge clk);
        write_en = 1;
        write_addr = 8'h07;
        write_data = 4'hF;
        in = 4'b0011;

        @(posedge clk);
        write_en = 0;
        read_en = 1;
        read_addr = 8'h07;

        @(posedge clk);
        #1;

        #1;


        check_outputs(6'h1F, 2'b01, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Priority 0 and RAM Access");
        reset_dut();

        @(posedge clk);
        write_en = 1;
        write_addr = 8'h00;
        write_data = 4'h3;
        in = 4'b0001;

        @(posedge clk);
        write_en = 0;
        read_en = 1;
        read_addr = 8'h00;

        @(posedge clk);
        #1;

        #1;


        check_outputs(6'h03, 2'b00, 4'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Simultaneous Update");
        reset_dut();


        @(posedge clk);
        write_en = 1; write_addr = 8'h01; write_data = 4'hB;


        @(posedge clk);
        write_en = 1; write_addr = 8'h04; write_data = 4'hE;
        read_en = 1; read_addr = 8'h01;
        in = 4'b1100;

        @(posedge clk);
        #1;

        #1;


        check_outputs(6'h2B, 2'b11, 4'hB);
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
        input [5:0] expected_final_output;
        input [1:0] expected_pos;
        input [3:0] expected_read_data;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, pos=%h, read_data=%h",
                         final_output, pos, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, pos=%h, read_data=%h",
                         expected_final_output, expected_pos, expected_read_data);
                $display("  Got:      final_output=%h, pos=%h, read_data=%h",
                         final_output, pos, read_data);
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
        $dumpvars(0,clk, in, read_addr, read_en, rst_n, write_addr, write_data, write_en, final_output, pos, read_data);
    end

endmodule
