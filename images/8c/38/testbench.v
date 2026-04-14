`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] io_rd_addr;
    reg [31:0] io_rd_data;
    reg io_rd_enable;
    reg [1:0] io_rd_thread;
    reg [4:0] io_rs1_addr;
    reg [1:0] io_rs1_thread;
    reg [4:0] io_rs2_addr;
    reg [1:0] io_rs2_thread;
    wire [31:0] io_rs1_data;
    wire [31:0] io_rs2_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_rd_addr(io_rd_addr),
        .io_rd_data(io_rd_data),
        .io_rd_enable(io_rd_enable),
        .io_rd_thread(io_rd_thread),
        .io_rs1_addr(io_rs1_addr),
        .io_rs1_thread(io_rs1_thread),
        .io_rs2_addr(io_rs2_addr),
        .io_rs2_thread(io_rs2_thread),
        .io_rs1_data(io_rs1_data),
        .io_rs2_data(io_rs2_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            io_rd_addr = 0;
            io_rd_data = 0;
            io_rd_enable = 0;
            io_rd_thread = 0;
            io_rs1_addr = 0;
            io_rs1_thread = 0;
            io_rs2_addr = 0;
            io_rs2_thread = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Register 0 Special Handling");
            reset_dut();

            io_rd_thread = 2'b00;
            io_rd_addr = 5'd0;
            io_rd_data = 32'hFFFFFFFF;
            io_rd_enable = 1;
            @(posedge clk);
            #1;
            io_rd_enable = 0;


            io_rs1_thread = 2'b00;
            io_rs1_addr = 5'd0;
            io_rs2_thread = 2'b00;
            io_rs2_addr = 5'd1;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Thread Isolation");
            reset_dut();


            io_rd_thread = 2'b01;
            io_rd_addr = 5'd5;
            io_rd_data = 32'hAAAA_AAAA;
            io_rd_enable = 1;
            @(posedge clk);
            #1;


            io_rd_thread = 2'b10;
            io_rd_addr = 5'd5;
            io_rd_data = 32'hBBBB_BBBB;
            io_rd_enable = 1;
            @(posedge clk);
            #1;
            io_rd_enable = 0;


            io_rs1_thread = 2'b01;
            io_rs1_addr = 5'd5;
            io_rs2_thread = 2'b10;
            io_rs2_addr = 5'd5;
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Logic");
            reset_dut();


            io_rd_thread = 2'b00;
            io_rd_addr = 5'd10;
            io_rd_data = 32'h1234_5678;
            io_rd_enable = 1;
            @(posedge clk);
            #1;


            io_rd_data = 32'hDEAD_BEEF;
            io_rd_enable = 0;
            @(posedge clk);
            #1;

            io_rs1_thread = 2'b00;
            io_rs1_addr = 5'd10;
            io_rs2_thread = 2'b00;
            io_rs2_addr = 5'd0;
            #1;
            #1;

            check_outputs(32'h1234_5678, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Dual Port Read");
            reset_dut();


            io_rd_thread = 2'b11;
            io_rd_addr = 5'd20;
            io_rd_data = 32'hCCCC_0000;
            io_rd_enable = 1;
            @(posedge clk);
            #1;


            io_rd_thread = 2'b11;
            io_rd_addr = 5'd21;
            io_rd_data = 32'h0000_DDDD;
            io_rd_enable = 1;
            @(posedge clk);
            #1;
            io_rd_enable = 0;

            io_rs1_thread = 2'b11;
            io_rs1_addr = 5'd20;
            io_rs2_thread = 2'b11;
            io_rs2_addr = 5'd21;
            #1;
            #1;

            check_outputs(32'hCCCC_0000, 32'h0000_DDDD);
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
        input [31:0] expected_io_rs1_data;
        input [31:0] expected_io_rs2_data;
        begin
            if (expected_io_rs1_data === (expected_io_rs1_data ^ io_rs1_data ^ expected_io_rs1_data) &&
                expected_io_rs2_data === (expected_io_rs2_data ^ io_rs2_data ^ expected_io_rs2_data)) begin
                $display("PASS");
                $display("  Outputs: io_rs1_data=%h, io_rs2_data=%h",
                         io_rs1_data, io_rs2_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_rs1_data=%h, io_rs2_data=%h",
                         expected_io_rs1_data, expected_io_rs2_data);
                $display("  Got:      io_rs1_data=%h, io_rs2_data=%h",
                         io_rs1_data, io_rs2_data);
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
        $dumpvars(0,clk, io_rd_addr, io_rd_data, io_rd_enable, io_rd_thread, io_rs1_addr, io_rs1_thread, io_rs2_addr, io_rs2_thread, io_rs1_data, io_rs2_data);
    end

endmodule
