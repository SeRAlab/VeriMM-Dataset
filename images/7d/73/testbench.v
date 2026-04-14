`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] rd_addr;
    reg [1:0] wr_addr;
    reg wr_clk;
    reg [103:0] wr_data;
    reg wr_write;
    wire [103:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .wr_clk(wr_clk),
        .wr_data(wr_data),
        .wr_write(wr_write),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

        task reset_dut;

        begin
            wr_write = 0;
            wr_addr = 0;
            rd_addr = 0;
            wr_data = 0;
            @(posedge wr_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            wr_addr = 2'b00;
            wr_data = 104'hAAAAAAAAAAAAAAAAAAAAAAAAAA;
            wr_write = 1;
            @(posedge wr_clk);
            #1;
            wr_write = 0;
            rd_addr = 2'b00;
            #1;
            $display("Testcase 001: Write to Addr 0");
            #1;

            check_outputs(104'hAAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            wr_addr = 2'b11;
            wr_data = 104'h55555555555555555555555555;
            wr_write = 1;
            @(posedge wr_clk);
            #1;
            wr_write = 0;
            rd_addr = 2'b11;
            #1;
            $display("Testcase 002: Write to Addr 3");
            #1;

            check_outputs(104'h55555555555555555555555555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            wr_addr = 2'b01;
            wr_data = 104'hF0F0F0F0F0F0F0F0F0F0F0F0F0;
            wr_write = 1;
            @(posedge wr_clk);
            #1;

            wr_data = 104'h01010101010101010101010101;
            wr_write = 0;
            @(posedge wr_clk);
            #1;
            rd_addr = 2'b01;
            #1;
            $display("Testcase 003: Write Enable Check");
            #1;

            check_outputs(104'hF0F0F0F0F0F0F0F0F0F0F0F0F0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            wr_addr = 2'b10;
            wr_data = 104'h11111111111111111111111111;
            wr_write = 1;
            @(posedge wr_clk);
            #1;
            wr_data = 204'h22222222222222222222222222;
            @(posedge wr_clk);
            #1;
            wr_write = 0;
            rd_addr = 2'b10;
            #1;
            $display("Testcase 004: Overwrite Addr 2");
            #1;

            check_outputs(104'h22222222222222222222222222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            wr_addr = 2'b00;
            wr_data = 104'hDEADBEEFDEADBEEFDEADBEEF01;
            wr_write = 1;
            @(posedge wr_clk);
            #1;

            rd_addr = 2'b00;
            wr_addr = 2'b01;
            wr_data = 104'hCAFEBABECAFEBABECAFEBABE02;
            wr_write = 1;
            @(posedge wr_clk);
            #1;
            $display("Testcase 005: Read Addr 0 while writing Addr 1");
            #1;

            check_outputs(104'hDEADBEEFDEADBEEFDEADBEEF01);
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
        input [103:0] expected_rd_data;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h",
                         rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h",
                         expected_rd_data);
                $display("  Got:      rd_data=%h",
                         rd_data);
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
        $dumpvars(0,rd_addr, wr_addr, wr_clk, wr_data, wr_write, rd_data);
    end

endmodule
