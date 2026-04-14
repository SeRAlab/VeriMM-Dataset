`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] readReg1;
    reg [4:0] readReg2;
    reg [31:0] writeData;
    reg writeEnable;
    reg [4:0] writeReg;
    wire [31:0] data1;
    wire [31:0] data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .writeData(writeData),
        .writeEnable(writeEnable),
        .writeReg(writeReg),
        .data1(data1),
        .data2(data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        readReg1 = 0;
        readReg2 = 0;
        writeReg = 0;
        writeData = 0;
        writeEnable = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Write and Dual Port Read", test_num);
        reset_dut();


        writeReg = 5;
        writeData = 32'hDEADBEEF;
        writeEnable = 1;
        @(posedge clk);
        #1;
        writeEnable = 0;


        readReg1 = 5;
        readReg2 = 5;
        #2;

        #1;


        check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Multiple Register Write and Read", test_num);
        reset_dut();


        writeReg = 10;
        writeData = 32'h12345678;
        writeEnable = 1;
        @(posedge clk);
        #1;


        writeReg = 20;
        writeData = 32'h87654321;
        writeEnable = 1;
        @(posedge clk);
        #1;
        writeEnable = 0;


        readReg1 = 10;
        readReg2 = 20;
        #2;

        #1;


        check_outputs(32'h12345678, 32'h87654321);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Write Enable Check", test_num);
        reset_dut();


        writeReg = 15;
        writeData = 32'hAAAA_AAAA;
        writeEnable = 1;
        @(posedge clk);
        #1;


        writeReg = 15;
        writeData = 32'h5555_5555;
        writeEnable = 0;
        @(posedge clk);
        #1;

        readReg1 = 15;
        readReg2 = 0;
        #2;


        #1;



        check_outputs(32'hAAAA_AAAA, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Boundary Registers (0 and 31)", test_num);
        reset_dut();


        writeReg = 0;
        writeData = 32'hF0F0_F0F0;
        writeEnable = 1;
        @(posedge clk);
        #1;


        writeReg = 31;
        writeData = 32'h0F0F_0F0F;
        writeEnable = 1;
        @(posedge clk);
        #1;
        writeEnable = 0;

        readReg1 = 0;
        readReg2 = 31;
        #2;

        #1;


        check_outputs(32'hF0F0_F0F0, 32'h0F0F_0F0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Register Overwrite", test_num);
        reset_dut();


        writeReg = 7;
        writeData = 32'h1111_1111;
        writeEnable = 1;
        @(posedge clk);
        #1;


        writeReg = 7;
        writeData = 32'h2222_2222;
        writeEnable = 1;
        @(posedge clk);
        #1;
        writeEnable = 0;

        readReg1 = 7;
        readReg2 = 7;
        #2;

        #1;


        check_outputs(32'h2222_2222, 32'h2222_2222);
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
        input [31:0] expected_data1;
        input [31:0] expected_data2;
        begin
            if (expected_data1 === (expected_data1 ^ data1 ^ expected_data1) &&
                expected_data2 === (expected_data2 ^ data2 ^ expected_data2)) begin
                $display("PASS");
                $display("  Outputs: data1=%h, data2=%h",
                         data1, data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data1=%h, data2=%h",
                         expected_data1, expected_data2);
                $display("  Got:      data1=%h, data2=%h",
                         data1, data2);
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
        $dumpvars(0,clk, readReg1, readReg2, writeData, writeEnable, writeReg, data1, data2);
    end

endmodule
