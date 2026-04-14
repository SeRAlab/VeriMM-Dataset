`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg rd_en;
    reg wr_en;
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
        addr = 12'b0;
        data_in = 16'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        addr = 12'h005;
        data_in = 16'hABCD;
        wr_en = 1'b1;
        @(posedge clk);
        #1;
        wr_en = 1'b0;


        rd_en = 1'b1;
        addr = 12'h005;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        addr = 12'h010;
        data_in = 16'h1234;
        wr_en = 1'b1;
        @(posedge clk);
        #1;
        wr_en = 1'b0;


        rd_en = 1'b0;
        addr = 12'h010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        addr = 12'h001; data_in = 16'hAAAA; wr_en = 1'b1;
        @(posedge clk); #1;

        addr = 12'hFFF; data_in = 16'hFFFF; wr_en = 1'b1;
        @(posedge clk); #1;
        wr_en = 1'b0;


        rd_en = 1'b1;
        addr = 12'h001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        addr = 12'h100; data_in = 16'h1111; wr_en = 1'b1;
        @(posedge clk); #1;

        addr = 12'h100; data_in = 16'h2222; wr_en = 1'b1;
        @(posedge clk); #1;
        wr_en = 1'b0;


        rd_en = 1'b1;
        addr = 12'h100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        addr = 12'h200; data_in = 16'h5555; wr_en = 1'b1;
        @(posedge clk); #1;
        wr_en = 1'b0;


        rd_en = 1'b1;
        addr = 12'h200;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h5555);
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
        $dumpvars(0,addr, clk, data_in, rd_en, wr_en, data_out);
    end

endmodule
