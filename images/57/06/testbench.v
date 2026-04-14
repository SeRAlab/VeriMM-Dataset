`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg reset;
    reg sync;
    reg write;
    reg [31:0] writedata;
    wire [31:0] reg0;
    wire [31:0] reg1;
    wire [31:0] reg2;
    wire [31:0] reg3;
    wire [31:0] reg4;
    wire [31:0] reg5;
    wire [31:0] reg6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .reset(reset),
        .sync(sync),
        .write(write),
        .writedata(writedata),
        .reg0(reg0),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg5(reg5),
        .reg6(reg6)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        address = 0;
        sync = 0;
        write = 0;
        writedata = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Power-on Reset", test_num);
        reset_dut();
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Write to Reg0", test_num);
        reset_dut();
        address = 4'h0;
        writedata = 32'hAAAA_BBBB;
        write = 1;
        sync = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAA_BBBB, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Write to Reg6", test_num);
        reset_dut();
        address = 4'h6;
        writedata = 32'h1234_5678;
        write = 1;
        sync = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 32'h1234_5678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Write with sync=0", test_num);
        reset_dut();
        address = 4'h2;
        writedata = 32'hDEAD_BEEF;
        write = 1;
        sync = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Write with write=0", test_num);
        reset_dut();
        address = 4'h1;
        writedata = 32'hCAFE_BABE;
        write = 0;
        sync = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Sequential Writes", test_num);
        reset_dut();


        address = 4'h1; writedata = 32'h1; write = 1; sync = 1;
        @(posedge clk); #1;


        address = 4'h3; writedata = 32'h3;
        @(posedge clk); #1;


        address = 4'h5; writedata = 32'h5;
        @(posedge clk); #1;

        #1;


        check_outputs(0, 32'h1, 0, 32'h3, 0, 32'h5, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Invalid Address Access (Addr 7)", test_num);
        reset_dut();
        address = 4'h7;
        writedata = 32'hFFFF_FFFF;
        write = 1;
        sync = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Overwrite Register", test_num);
        reset_dut();


        address = 4'h4; writedata = 32'hAAAA_AAAA; write = 1; sync = 1;
        @(posedge clk); #1;


        address = 4'h4; writedata = 32'h5555_5555;
        @(posedge clk); #1;

        #1;


        check_outputs(0, 0, 0, 0, 32'h5555_5555, 0, 0);
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
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_reg0;
        input [31:0] expected_reg1;
        input [31:0] expected_reg2;
        input [31:0] expected_reg3;
        input [31:0] expected_reg4;
        input [31:0] expected_reg5;
        input [31:0] expected_reg6;
        begin
            if (expected_reg0 === (expected_reg0 ^ reg0 ^ expected_reg0) &&
                expected_reg1 === (expected_reg1 ^ reg1 ^ expected_reg1) &&
                expected_reg2 === (expected_reg2 ^ reg2 ^ expected_reg2) &&
                expected_reg3 === (expected_reg3 ^ reg3 ^ expected_reg3) &&
                expected_reg4 === (expected_reg4 ^ reg4 ^ expected_reg4) &&
                expected_reg5 === (expected_reg5 ^ reg5 ^ expected_reg5) &&
                expected_reg6 === (expected_reg6 ^ reg6 ^ expected_reg6)) begin
                $display("PASS");
                $display("  Outputs: reg0=%h, reg1=%h, reg2=%h, reg3=%h, reg4=%h, reg5=%h, reg6=%h",
                         reg0, reg1, reg2, reg3, reg4, reg5, reg6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg0=%h, reg1=%h, reg2=%h, reg3=%h, reg4=%h, reg5=%h, reg6=%h",
                         expected_reg0, expected_reg1, expected_reg2, expected_reg3, expected_reg4, expected_reg5, expected_reg6);
                $display("  Got:      reg0=%h, reg1=%h, reg2=%h, reg3=%h, reg4=%h, reg5=%h, reg6=%h",
                         reg0, reg1, reg2, reg3, reg4, reg5, reg6);
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
        $dumpvars(0,address, clk, reset, sync, write, writedata, reg0, reg1, reg2, reg3, reg4, reg5, reg6);
    end

endmodule
