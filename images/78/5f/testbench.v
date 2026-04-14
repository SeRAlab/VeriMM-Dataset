`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address;
    reg clk;
    reg readEnable;
    reg [7:0] writeData;
    reg writeEnable;
    wire [7:0] readData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .readEnable(readEnable),
        .writeData(writeData),
        .writeEnable(writeEnable),
        .readData(readData)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        address = 0;
        readEnable = 0;
        writeEnable = 0;
        writeData = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Write and Read (Addr 5)", test_num);
        reset_dut();


        @(negedge clk);
        address = 5'd5;
        writeData = 8'hA5;
        writeEnable = 1;
        @(negedge clk);
        writeEnable = 0;


        address = 5'd5;
        readEnable = 1;
        @(negedge clk);
        readEnable = 0;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Boundary Test (Addr 0)", test_num);
        reset_dut();


        @(negedge clk);
        address = 5'd0;
        writeData = 8'h11;
        writeEnable = 1;
        @(negedge clk);
        writeEnable = 0;


        address = 5'd0;
        readEnable = 1;
        @(negedge clk);
        readEnable = 0;

        #1;


        check_outputs(8'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Boundary Test (Addr 31)", test_num);
        reset_dut();


        @(negedge clk);
        address = 5'd31;
        writeData = 8'hFF;
        writeEnable = 1;
        @(negedge clk);
        writeEnable = 0;


        address = 5'd31;
        readEnable = 1;
        @(negedge clk);
        readEnable = 0;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Overwrite Test", test_num);
        reset_dut();


        @(negedge clk);
        address = 5'd10;
        writeData = 8'hAA;
        writeEnable = 1;
        @(negedge clk);

        writeData = 8'h55;
        @(negedge clk);
        writeEnable = 0;


        address = 5'd10;
        readEnable = 1;
        @(negedge clk);
        readEnable = 0;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Write Isolation Test", test_num);
        reset_dut();


        @(negedge clk);
        address = 5'd15;
        writeData = 8'hCC;
        writeEnable = 1;
        @(negedge clk);

        address = 5'd16;
        writeData = 8'hDD;
        @(negedge clk);
        writeEnable = 0;


        address = 5'd15;
        readEnable = 1;
        @(negedge clk);
        readEnable = 0;

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
        input [7:0] expected_readData;
        begin
            if (expected_readData === (expected_readData ^ readData ^ expected_readData)) begin
                $display("PASS");
                $display("  Outputs: readData=%h",
                         readData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readData=%h",
                         expected_readData);
                $display("  Got:      readData=%h",
                         readData);
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
        $dumpvars(0,address, clk, readEnable, writeData, writeEnable, readData);
    end

endmodule
