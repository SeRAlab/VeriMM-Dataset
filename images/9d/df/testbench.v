`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Addr;
    reg Cmd;
    reg RW;
    reg [7:0] WData;
    reg clk;
    reg rst_n;
    wire Finish;
    wire [7:0] RData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .Cmd(Cmd),
        .RW(RW),
        .WData(WData),
        .clk(clk),
        .rst_n(rst_n),
        .Finish(Finish),
        .RData(RData)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        Addr = 0;
        Cmd = 0;
        RW = 0;
        WData = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Write Finish Check", test_num);
        reset_dut();
        perform_write(16'h0001, 8'hAA);
        #1;

        check_outputs(1'b1, RData);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write then Read back", test_num);
        reset_dut();
        perform_write(16'h0005, 8'h55);
        perform_read(16'h0005);
        #1;

        check_outputs(1'b1, 8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Address Alias Check (Lower 4 bits)", test_num);
        reset_dut();
        perform_write(16'hF004, 8'hBE);
        perform_read(16'h0004);
        #1;

        check_outputs(1'b1, 8'hBE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Index 15 (0xF) Check", test_num);
        reset_dut();
        perform_write(16'h000F, 8'h77);
        perform_read(16'hFFFF);
        #1;

        check_outputs(1'b1, 8'h77);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Overwrite Check", test_num);
        reset_dut();
        perform_write(16'h0002, 8'h11);
        perform_write(16'h0002, 8'h22);
        perform_read(16'h0002);
        #1;

        check_outputs(1'b1, 8'h22);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Multi-address Sequential Check", test_num);
        reset_dut();
        perform_write(16'h0000, 8'h01);
        perform_write(16'h0001, 8'h02);
        perform_write(16'h0002, 8'h03);
        perform_read(16'h0001);
        #1;

        check_outputs(1'b1, 8'h02);
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
        input expected_Finish;
        input [7:0] expected_RData;
        begin
            if (expected_Finish === (expected_Finish ^ Finish ^ expected_Finish) &&
                expected_RData === (expected_RData ^ RData ^ expected_RData)) begin
                $display("PASS");
                $display("  Outputs: Finish=%b, RData=%h",
                         Finish, RData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Finish=%b, RData=%h",
                         expected_Finish, expected_RData);
                $display("  Got:      Finish=%b, RData=%h",
                         Finish, RData);
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
        $dumpvars(0,Addr, Cmd, RW, WData, clk, rst_n, Finish, RData);
    end

endmodule
