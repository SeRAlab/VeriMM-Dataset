`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] read_addr1;
    reg [7:0] read_addr2;
    reg read_en1;
    reg read_en2;
    reg rst_n;
    reg [7:0] write_addr;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .read_en1(read_en1),
        .read_en2(read_en2),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_en(write_en),
        .data_out(data_out)
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
            write_addr = 0;
            data_in = 0;
            read_en1 = 0;
            read_addr1 = 0;
            read_en2 = 0;
            read_addr2 = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: RAM Write and Port 1 Read");
            reset_dut();


            write_en = 1;
            write_addr = 8'h05;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en1 = 1;
            read_addr1 = 8'h05;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Memory Boundary Test (Address 15)");
            reset_dut();


            write_en = 1;
            write_addr = 8'h0F;
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en1 = 1;
            read_addr1 = 8'h0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Write Disable Verification");
            reset_dut();


            write_en = 0;
            write_addr = 8'h02;
            data_in = 8'h77;
            @(posedge clk);
            #1;


            read_en1 = 1;
            read_addr1 = 8'h02;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Shift Register Continuity");
            reset_dut();


            data_in = 8'h01;
            repeat(8) @(posedge clk);
            #1;



            if (data_out !== 8'h00) begin
                $display("PASS: Shift register is active.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Shift register remains zero.");
                fail_count = fail_count + 1;
            end
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, read_addr1, read_addr2, read_en1, read_en2, rst_n, write_addr, write_en, data_out);
    end

endmodule
