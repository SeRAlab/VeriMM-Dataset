`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [31:0] data_in;
    reg en;
    reg rst;
    reg wr_en;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .rst(rst),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            wr_en = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();


            en = 1;
            wr_en = 1;
            addr = 16'h0010;
            data_in = 32'hDEADBEEF;
            @(posedge clk);


            wr_en = 0;
            @(posedge clk);

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Verify multiple addresses");
            reset_dut();

            en = 1;

            wr_en = 1;
            addr = 16'h000A;
            data_in = 32'h11112222;
            @(posedge clk);


            addr = 16'h000B;
            data_in = 32'h33334444;
            @(posedge clk);


            wr_en = 0;
            addr = 16'h000A;
            @(posedge clk);

            #1;


            check_outputs(32'h11112222);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify Enable signal gating");
            reset_dut();


            en = 0;
            wr_en = 1;
            addr = 16'h0020;
            data_in = 32'h55556666;
            @(posedge clk);


            en = 1;
            wr_en = 0;
            addr = 16'h0020;
            @(posedge clk);


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify Write Enable signal logic");
            reset_dut();

            en = 1;

            wr_en = 0;
            addr = 16'h0030;
            data_in = 32'h77778888;
            @(posedge clk);


            addr = 16'h0030;
            @(posedge clk);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting memory location");
            reset_dut();

            en = 1;

            wr_en = 1;
            addr = 16'h0040;
            data_in = 32'hAAAA_AAAA;
            @(posedge clk);


            data_in = 32'hBBBB_BBBB;
            @(posedge clk);


            wr_en = 0;
            @(posedge clk);

            #1;


            check_outputs(32'hBBBB_BBBB);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, en, rst, wr_en, data_out);
    end

endmodule
