`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] rd_ptr;
    reg rst;
    reg we;
    reg [2:0] wr_ptr;
    reg [49:0] wrdata;
    wire [49:0] rddata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_ptr(rd_ptr),
        .rst(rst),
        .we(we),
        .wr_ptr(wr_ptr),
        .wrdata(wrdata),
        .rddata(rddata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        we = 0;
        wr_ptr = 0;
        rd_ptr = 0;
        wrdata = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Basic Write and Read");


        @(posedge clk);
        #1;
        we = 1;
        wr_ptr = 3'd3;
        wrdata = 50'hA1B2C3D4E5F60;

        @(posedge clk);
        #1;
        we = 0;
        rd_ptr = 3'd3;

        @(posedge clk);
        #1;
        #1;

        check_outputs(50'hA1B2C3D4E5F60);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Verify Write Enable=0 prevents write");


        @(posedge clk);
        #1;
        we = 0;
        wr_ptr = 3'd5;
        wrdata = 50'hFFFFFFFFFFFFF;

        @(posedge clk);
        #1;
        rd_ptr = 3'd5;

        @(posedge clk);
        #1;
        #1;

        check_outputs(50'h0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Overwriting data");


        @(posedge clk);
        #1;
        we = 1; wr_ptr = 3'd1; wrdata = 50'h1111111111111;
        @(posedge clk);
        #1;

        wr_ptr = 3'd1; wrdata = 50'h2222222222222;
        @(posedge clk);
        #1;
        we = 0;
        rd_ptr = 3'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(50'h2222222222222);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Multiple addresses");


        @(posedge clk);
        #1; we = 1; wr_ptr = 3'd0; wrdata = 50'hAAAAA_AAAAA_AAAA;
        @(posedge clk);
        #1; we = 1; wr_ptr = 3'd7; wrdata = 50'h77777_77777_7777;
        @(posedge clk);
        #1; we = 0;


        rd_ptr = 3'd0;
        @(posedge clk);
        #1;
        if (rddata !== 50'hAAAAA_AAAAA_AAAA) begin
            $display("Fail at addr 0");
            fail_count++;
        end else begin

            rd_ptr = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(50'h77777_77777_7777);
        end
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Reset mid-operation");


        @(posedge clk);
        #1; we = 1; wr_ptr = 3'd4; wrdata = 50'hBCDE_BCDE_BCDE;
        @(posedge clk);
        #1; we = 0; rd_ptr = 3'd4;
        @(posedge clk);
        #1;


        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        #1;

        check_outputs(50'h0);
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
        input [49:0] expected_rddata;
        begin
            if (expected_rddata === (expected_rddata ^ rddata ^ expected_rddata)) begin
                $display("PASS");
                $display("  Outputs: rddata=%h",
                         rddata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rddata=%h",
                         expected_rddata);
                $display("  Got:      rddata=%h",
                         rddata);
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
        $dumpvars(0,clk, rd_ptr, rst, we, wr_ptr, wrdata, rddata);
    end

endmodule
