`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr_1;
    reg [7:0] addr_2;
    reg clk;
    reg [15:0] d_in_1;
    reg [15:0] d_in_2;
    reg rd_1;
    reg rd_2;
    reg wr_1;
    reg wr_2;
    wire [15:0] d_out_1;
    wire [15:0] d_out_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_1(addr_1),
        .addr_2(addr_2),
        .clk(clk),
        .d_in_1(d_in_1),
        .d_in_2(d_in_2),
        .rd_1(rd_1),
        .rd_2(rd_2),
        .wr_1(wr_1),
        .wr_2(wr_2),
        .d_out_1(d_out_1),
        .d_out_2(d_out_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addr_1 = 0; addr_2 = 0;
        d_in_1 = 0; d_in_2 = 0;
        rd_1 = 0;   rd_2 = 0;
        wr_1 = 0;   wr_2 = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        @(posedge clk);
        addr_1 = 8'h05; d_in_1 = 16'hAAAA; wr_1 = 1;
        @(negedge clk);
        #2 wr_1 = 0;


        @(posedge clk);
        addr_1 = 8'h05; rd_1 = 1;
        @(negedge clk);
        #2;

        $display("Testcase 001: Port 1 Basic Write/Read");
        #1;

        check_outputs(16'hAAAA, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        @(posedge clk);
        addr_2 = 8'h1F; d_in_2 = 16'h5555; wr_2 = 1;
        @(negedge clk);
        #2 wr_2 = 0;


        @(posedge clk);
        addr_2 = 8'h1F; rd_2 = 1;
        @(negedge clk);
        #2;

        $display("Testcase 002: Port 2 Basic Write/Read");
        #1;

        check_outputs(16'h0000, 16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        @(posedge clk);
        addr_1 = 8'h0A; d_in_1 = 16'h1234; wr_1 = 1;
        addr_2 = 8'h0B; d_in_2 = 16'hABCD; wr_2 = 1;
        @(negedge clk);
        #2 wr_1 = 0; wr_2 = 0;


        @(posedge clk);
        addr_1 = 8'h0A; rd_1 = 1;
        addr_2 = 8'h0B; rd_2 = 1;
        @(negedge clk);
        #2;

        $display("Testcase 003: Simultaneous Writes/Reads (Diff Addr)");
        #1;

        check_outputs(16'h1234, 16'hABCD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        @(posedge clk);
        addr_1 = 8'h02; d_in_1 = 16'h7777; wr_1 = 1;
        @(negedge clk);
        #2 wr_1 = 0;


        @(posedge clk);
        addr_1 = 8'h02; rd_1 = 1;
        addr_2 = 8'h03; d_in_2 = 16'hEEEE; wr_2 = 1;
        @(negedge clk);
        #2 wr_2 = 0; rd_1 = 0;


        @(posedge clk);
        addr_2 = 8'h03; rd_2 = 1;
        @(negedge clk);
        #2;

        $display("Testcase 004: Simultaneous Read/Write (Diff Addr)");
        #1;

        check_outputs(16'h0000, 16'hEEEE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        @(posedge clk);
        addr_1 = 8'd0;  d_in_1 = 16'hF0F0; wr_1 = 1;
        addr_2 = 8'd31; d_in_2 = 16'h0F0F; wr_2 = 1;
        @(negedge clk);
        #2 wr_1 = 0; wr_2 = 0;


        @(posedge clk);
        addr_1 = 8'd0;  rd_1 = 1;
        addr_2 = 8'd31; rd_2 = 1;
        @(negedge clk);
        #2;

        $display("Testcase 005: Boundary Address Check (0 and 31)");
        #1;

        check_outputs(16'hF0F0, 16'h0F0F);
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
        input [15:0] expected_d_out_1;
        input [15:0] expected_d_out_2;
        begin
            if (expected_d_out_1 === (expected_d_out_1 ^ d_out_1 ^ expected_d_out_1) &&
                expected_d_out_2 === (expected_d_out_2 ^ d_out_2 ^ expected_d_out_2)) begin
                $display("PASS");
                $display("  Outputs: d_out_1=%h, d_out_2=%h",
                         d_out_1, d_out_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out_1=%h, d_out_2=%h",
                         expected_d_out_1, expected_d_out_2);
                $display("  Got:      d_out_1=%h, d_out_2=%h",
                         d_out_1, d_out_2);
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
        $dumpvars(0,addr_1, addr_2, clk, d_in_1, d_in_2, rd_1, rd_2, wr_1, wr_2, d_out_1, d_out_2);
    end

endmodule
