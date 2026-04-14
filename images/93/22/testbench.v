`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena_;
    reg [7:0] fl_dout;
    reg rst_;
    wire [7:0] fl_din;
    wire fl_we_;
    wire rdy_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena_(ena_),
        .fl_dout(fl_dout),
        .rst_(rst_),
        .fl_din(fl_din),
        .fl_we_(fl_we_),
        .rdy_(rdy_)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_ = 0;
        ena_ = 1;
        fl_dout = 8'h00;
        @(posedge clk);
        #2 rst_ = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Initial Reset and Idle State", test_num);
        reset_dut();


        #1;



        check_outputs(8'h01, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Single Step Operation (Data 0x00 -> 0x01)", test_num);
        reset_dut();
        fl_dout = 8'h00;
        ena_ = 0;
        @(posedge clk);

        #1;


        check_outputs(8'h01, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: LSB Inversion Check (Data 0xFF -> 0xFE)", test_num);
        reset_dut();
        fl_dout = 8'hFF;
        ena_ = 0;
        @(posedge clk);

        #1;


        check_outputs(8'hFE, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Inactive Enable Check", test_num);
        reset_dut();
        fl_dout = 8'hAA;
        ena_ = 1;
        @(posedge clk);

        #1;


        check_outputs(8'hAB, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Consecutive Operations", test_num);
        reset_dut();


        fl_dout = 8'h55;
        ena_ = 0;
        @(posedge clk);


        fl_dout = 8'h22;
        @(posedge clk);

        #1;


        check_outputs(8'h23, 1'b0, 1'b0);
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
        input [7:0] expected_fl_din;
        input expected_fl_we_;
        input expected_rdy_;
        begin
            if (expected_fl_din === (expected_fl_din ^ fl_din ^ expected_fl_din) &&
                expected_fl_we_ === (expected_fl_we_ ^ fl_we_ ^ expected_fl_we_) &&
                expected_rdy_ === (expected_rdy_ ^ rdy_ ^ expected_rdy_)) begin
                $display("PASS");
                $display("  Outputs: fl_din=%h, fl_we_=%b, rdy_=%b",
                         fl_din, fl_we_, rdy_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fl_din=%h, fl_we_=%b, rdy_=%b",
                         expected_fl_din, expected_fl_we_, expected_rdy_);
                $display("  Got:      fl_din=%h, fl_we_=%b, rdy_=%b",
                         fl_din, fl_we_, rdy_);
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
        $dumpvars(0,clk, ena_, fl_dout, rst_, fl_din, fl_we_, rdy_);
    end

endmodule
