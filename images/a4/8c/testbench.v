`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg select;
    reg [7:0] write_addr;
    reg write_en;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .read_addr(read_addr),
        .read_en(read_en),
        .rst_n(rst_n),
        .select(select),
        .write_addr(write_addr),
        .write_en(write_en),
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
        write_en = 0;
        read_en = 0;
        write_addr = 0;
        read_addr = 0;
        in1 = 0;
        in2 = 0;
        select = 0;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        read_en = 1;
        read_addr = 8'hA5;
        @(posedge clk);
        #1;
        $display("Testcase 001: Reset Check");
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        write_en = 1;
        write_addr = 8'h10;
        in1 = 4'b1101;
        select = 0;
        @(posedge clk);


        write_en = 0;
        read_en = 1;
        read_addr = 8'h10;
        @(posedge clk);
        #1;
        $display("Testcase 002: Write in1 (select=0) and Mask Check");
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        write_en = 1;
        write_addr = 8'h20;
        in2 = 4'b0111;
        select = 1;
        @(posedge clk);


        write_en = 0;
        read_en = 1;
        read_addr = 8'h20;
        @(posedge clk);
        #1;
        $display("Testcase 003: Write in2 (select=1) and Mask Check");
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        write_en = 1;
        write_addr = 8'h30;
        in1 = 4'b1011;
        select = 0;
        @(posedge clk);


        write_addr = 8'h40;
        in1 = 4'b1111;
        read_en = 1;
        read_addr = 8'h30;
        @(posedge clk);
        #1;

        $display("Testcase 004: Simultaneous Access");
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        write_en = 0;
        write_addr = 8'h50;
        in1 = 4'b1100;
        @(posedge clk);

        read_en = 1;
        read_addr = 8'h50;
        @(posedge clk);
        #1;

        $display("Testcase 005: Write Enable Check");
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, in1, in2, read_addr, read_en, rst_n, select, write_addr, write_en, read_data);
    end

endmodule
