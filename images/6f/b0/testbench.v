`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg begintransfer;
    reg clk;
    reg read;
    reg reset_n;
    reg write;
    reg [7:0] writedata;
    wire LCD_E;
    wire LCD_RS;
    wire LCD_RW;
    wire [7:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .begintransfer(begintransfer),
        .clk(clk),
        .read(read),
        .reset_n(reset_n),
        .write(write),
        .writedata(writedata),
        .LCD_E(LCD_E),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        address = 0;
        begintransfer = 0;
        read = 0;
        write = 0;
        writedata = 0;
        repeat(2) @(posedge clk);
        #1 reset_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Write Data (RS=1)", test_num);
        reset_dut();

        @(posedge clk);
        address = 2'b01;
        writedata = 8'hA5;
        write = 1;
        read = 0;
        begintransfer = 1;

        @(posedge clk);
        begintransfer = 0;


        repeat(10) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b1, 1'b0, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Write Instruction (RS=0)", test_num);
        reset_dut();

        @(posedge clk);
        address = 2'b00;
        writedata = 8'h01;
        write = 1;
        read = 0;
        begintransfer = 1;

        @(posedge clk);
        begintransfer = 0;

        repeat(10) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Read Data (RW=1)", test_num);
        reset_dut();

        @(posedge clk);
        address = 2'b01;
        write = 0;
        read = 1;
        begintransfer = 1;

        @(posedge clk);
        begintransfer = 0;

        repeat(10) @(posedge clk);



        #1;




        check_outputs(1'b0, 1'b1, 1'b1, readdata);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Idle Maintenance", test_num);
        reset_dut();

        address = 2'b11;
        writedata = 8'hFF;
        write = 1;
        read = 0;
        begintransfer = 0;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 8'h00);
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
        input expected_LCD_E;
        input expected_LCD_RS;
        input expected_LCD_RW;
        input [7:0] expected_readdata;
        begin
            if (expected_LCD_E === (expected_LCD_E ^ LCD_E ^ expected_LCD_E) &&
                expected_LCD_RS === (expected_LCD_RS ^ LCD_RS ^ expected_LCD_RS) &&
                expected_LCD_RW === (expected_LCD_RW ^ LCD_RW ^ expected_LCD_RW) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: LCD_E=%b, LCD_RS=%b, LCD_RW=%b, readdata=%h",
                         LCD_E, LCD_RS, LCD_RW, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LCD_E=%b, LCD_RS=%b, LCD_RW=%b, readdata=%h",
                         expected_LCD_E, expected_LCD_RS, expected_LCD_RW, expected_readdata);
                $display("  Got:      LCD_E=%b, LCD_RS=%b, LCD_RW=%b, readdata=%h",
                         LCD_E, LCD_RS, LCD_RW, readdata);
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
        $dumpvars(0,address, begintransfer, clk, read, reset_n, write, writedata, LCD_E, LCD_RS, LCD_RW, readdata);
    end

endmodule
