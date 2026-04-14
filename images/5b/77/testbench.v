`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg [3:0] burst_len;
    reg [1:0] burst_type;
    reg clk;
    reg rd_en;
    reg rst;
    reg [31:0] wd;
    reg we;
    wire [31:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .burst_len(burst_len),
        .burst_type(burst_type),
        .clk(clk),
        .rd_en(rd_en),
        .rst(rst),
        .wd(wd),
        .we(we),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 0;
            we = 0;
            wd = 0;
            rd_en = 0;
            burst_len = 0;
            burst_type = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Single Write and Read...");
            reset_dut();


            @(posedge clk);
            addr = 32'h100;
            wd = 32'hDEADBEEF;
            we = 1;
            burst_len = 0;
            @(posedge clk);
            we = 0;

            repeat(2) @(posedge clk);


            addr = 32'h100;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Burst Write and Read (Incr)...");
            reset_dut();


            @(posedge clk);
            addr = 32'h200;
            we = 1;
            burst_len = 3;
            burst_type = 2'b01;

            wd = 32'h11111111; @(posedge clk);
            wd = 32'h22222222; @(posedge clk);
            wd = 32'h33333333; @(posedge clk);
            wd = 32'h44444444; @(posedge clk);
            we = 0;

            repeat(2) @(posedge clk);


            addr = 32'h200;
            rd_en = 1;
            burst_len = 3;
            @(posedge clk);

            repeat(4) @(posedge clk);
            rd_en = 0;

            repeat(1) @(posedge clk);
            #1;

            check_outputs(32'h44444444);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Sequential Pipelined Access...");
            reset_dut();


            @(posedge clk);
            addr = 32'h10; wd = 32'hAAAAAAAA; we = 1; @(posedge clk);
            addr = 32'h14; wd = 32'hBBBBBBBB; we = 1; @(posedge clk);
            we = 0;

            repeat(2) @(posedge clk);


            addr = 32'h14; rd_en = 1; @(posedge clk);
            rd_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'hBBBBBBBB);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Fixed Burst Access...");
            reset_dut();


            @(posedge clk);
            addr = 32'h300;
            we = 1;
            burst_len = 1;
            burst_type = 2'b00;

            wd = 32'hCAFE0001; @(posedge clk);
            wd = 32'hCAFE0002; @(posedge clk);
            we = 0;

            repeat(2) @(posedge clk);


            addr = 32'h300;
            rd_en = 1;
            burst_len = 0;
            @(posedge clk);
            rd_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'hCAFE0002);
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
        input [31:0] expected_rd_data;
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
        $dumpvars(0,addr, burst_len, burst_type, clk, rd_en, rst, wd, we, rd_data);
    end

endmodule
