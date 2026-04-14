`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr_r;
    reg [9:0] addr_w;
    reg clk;
    reg [7:0] data_w;
    reg we;
    wire [7:0] data_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_r(addr_r),
        .addr_w(addr_w),
        .clk(clk),
        .data_w(data_w),
        .we(we),
        .data_r(data_r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        addr_w = 0;
        data_w = 0;
        addr_r = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        we = 1; addr_w = 10'd50; data_w = 8'hA5;
        @(posedge clk); #1;
        we = 0;

        addr_r = 10'd50;
        @(posedge clk); #1;
        $display("Testcase 001: Basic Write/Read");
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        we = 1; addr_w = 10'd1023; data_w = 8'hFF;
        @(posedge clk); #1;
        we = 0;

        addr_r = 10'd1023;
        @(posedge clk); #1;
        $display("Testcase 002: Boundary Address 1023");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        we = 1; addr_w = 10'd0; data_w = 8'h11;
        @(posedge clk); #1;
        we = 0;

        addr_r = 10'd0;
        @(posedge clk); #1;
        $display("Testcase 003: Boundary Address 0");
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        we = 1; addr_w = 10'd15; data_w = 8'h77;
        @(posedge clk); #1;

        we = 0; addr_w = 10'd15; data_w = 8'h99;
        @(posedge clk); #1;

        addr_r = 10'd15;
        @(posedge clk); #1;
        $display("Testcase 004: Write Enable (WE=0) Check");

        #1;


        check_outputs(8'h77);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        we = 1; addr_w = 10'd200; data_w = 8'hAA;
        @(posedge clk); #1;

        we = 1; addr_w = 10'd200; data_w = 8'hBB;
        @(posedge clk); #1;
        we = 0;

        addr_r = 10'd200;
        @(posedge clk); #1;
        $display("Testcase 005: Data Overwrite");
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        we = 1; addr_w = 10'd100; data_w = 8'hCC;
        @(posedge clk); #1;

        we = 1; addr_w = 10'd200; data_w = 8'hDD;
        addr_r = 10'd100;
        @(posedge clk); #1;
        $display("Testcase 006: Simultaneous Read/Write");
        #1;

        check_outputs(8'hCC);
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
        input [7:0] expected_data_r;
        begin
            if (expected_data_r === (expected_data_r ^ data_r ^ expected_data_r)) begin
                $display("PASS");
                $display("  Outputs: data_r=%h",
                         data_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_r=%h",
                         expected_data_r);
                $display("  Got:      data_r=%h",
                         data_r);
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
        $dumpvars(0,addr_r, addr_w, clk, data_w, we, data_r);
    end

endmodule
