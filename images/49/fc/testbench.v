`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Reset;
    reg [7:0] WriteData;
    reg [5:0] readAddress;
    reg readEn;
    reg [5:0] writeAddress;
    reg writeEn;
    wire [7:0] ReadData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Reset(Reset),
        .WriteData(WriteData),
        .readAddress(readAddress),
        .readEn(readEn),
        .writeAddress(writeAddress),
        .writeEn(writeEn),
        .ReadData(ReadData)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            writeEn = 0;
            readEn = 0;
            WriteData = 0;
            writeAddress = 0;
            readAddress = 0;
            @(posedge Clk);
            #1;
            Reset = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset initialization check", test_num);
            reset_dut();


            readAddress = 6'h0A;
            readEn = 1;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read operation", test_num);
            reset_dut();


            writeAddress = 6'h05;
            WriteData = 8'h55;
            writeEn = 1;
            @(posedge Clk);
            #1;
            writeEn = 0;


            readAddress = 6'h05;
            readEn = 1;
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: High Impedance check when readEn=0", test_num);
            reset_dut();


            writeAddress = 6'h10;
            WriteData = 8'hAA;
            writeEn = 1;
            @(posedge Clk);
            #1;
            writeEn = 0;


            readAddress = 6'h10;
            readEn = 0;
            #2;
            #1;

            check_outputs(8'bz);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Simultaneous Write to A and Read from B", test_num);
            reset_dut();


            writeAddress = 6'h20;
            WriteData = 8'hCC;
            writeEn = 1;
            @(posedge Clk);
            #1;


            writeAddress = 6'h21;
            WriteData = 8'hDD;
            writeEn = 1;
            readAddress = 6'h20;
            readEn = 1;
            #2;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Max address (63) write/read check", test_num);
            reset_dut();

            writeAddress = 6'd63;
            WriteData = 8'hFF;
            writeEn = 1;
            @(posedge Clk);
            #1;
            writeEn = 0;

            readAddress = 6'd63;
            readEn = 1;
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Write Enable disabled check", test_num);
            reset_dut();


            writeAddress = 6'h01;
            WriteData = 8'hEE;
            writeEn = 0;
            @(posedge Clk);
            #1;


            readAddress = 6'h01;
            readEn = 1;
            #2;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_ReadData;
        begin
            if (expected_ReadData === (expected_ReadData ^ ReadData ^ expected_ReadData)) begin
                $display("PASS");
                $display("  Outputs: ReadData=%h",
                         ReadData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadData=%h",
                         expected_ReadData);
                $display("  Got:      ReadData=%h",
                         ReadData);
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
        $dumpvars(0,Clk, Reset, WriteData, readAddress, readEn, writeAddress, writeEn, ReadData);
    end

endmodule
