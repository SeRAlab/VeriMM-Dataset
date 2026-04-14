`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg rd_en;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        rd_en = 0;
        addr = 0;
        data_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Basic Write and Read");
        @(posedge clk); #1;
        we = 1; addr = 16'hAAAA; data_in = 16'h5555;
        @(posedge clk); #1;
        we = 0; rd_en = 1; addr = 16'hAAAA;
        @(negedge clk); #1;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Simultaneous Write/Read same address");
        @(posedge clk); #1;
        we = 1; rd_en = 1; addr = 16'h1234; data_in = 16'hBEEF;

        @(negedge clk); #1;
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Sequential writes to different addresses");
        @(posedge clk); #1;
        we = 1; addr = 16'h0001; data_in = 16'h1111;
        @(posedge clk); #1;
        we = 1; addr = 16'h0002; data_in = 16'h2222;
        @(posedge clk); #1;
        we = 0; rd_en = 1; addr = 16'h0001;
        @(negedge clk); #1;

        #1;


        check_outputs(16'h1111);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Overwriting data at the same address");
        @(posedge clk); #1;
        we = 1; addr = 16'h0005; data_in = 16'hAAAA;
        @(posedge clk); #1;
        we = 1; addr = 16'h0005; data_in = 16'hBBBB;
        @(posedge clk); #1;
        we = 0; rd_en = 1; addr = 16'h0005;
        @(negedge clk); #1;
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Boundary address 0xFFFF");
        @(posedge clk); #1;
        we = 1; addr = 16'hFFFF; data_in = 16'hF0F0;
        @(posedge clk); #1;
        we = 0; rd_en = 1; addr = 16'hFFFF;
        @(negedge clk); #1;
        #1;

        check_outputs(16'hF0F0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase 006: Simultaneous Write and Read (different addresses)");

        @(posedge clk); #1; we = 1; addr = 16'h0100; data_in = 16'h9999;
        @(posedge clk); #1; we = 0;

        @(posedge clk); #1;
        we = 1; addr = 16'h0200; data_in = 16'h8888;
        @(posedge clk);
        #1;
        rd_en = 1; addr = 16'h0100;
        @(negedge clk);
        #1;
        #1;

        check_outputs(16'h9999);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, rd_en, we, data_out);
    end

endmodule
