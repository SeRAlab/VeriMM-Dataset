`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ReadAddr;
    reg [7:0] WriteAddr;
    reg [7:0] WriteData;
    reg WriteEnable;
    reg gclk;
    wire [7:0] ReadData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadAddr(ReadAddr),
        .WriteAddr(WriteAddr),
        .WriteData(WriteData),
        .WriteEnable(WriteEnable),
        .gclk(gclk),
        .ReadData(ReadData)
    );

    // Clock generation (10ns period)
    initial begin
        gclk = 0;
        forever #5 gclk = ~gclk;
    end

        task reset_dut;

        begin
            ReadAddr = 8'h0;
            WriteAddr = 8'h0;
            WriteData = 8'h0;
            WriteEnable = 1'b0;
            @(posedge gclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            WriteEnable = 1;
            WriteAddr = 8'h10;
            WriteData = 8'hA5;
            @(posedge gclk);
            #1;

            WriteEnable = 0;
            ReadAddr = 8'h10;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            WriteEnable = 1;
            WriteAddr = 8'h20;
            WriteData = 8'h5A;
            @(posedge gclk);
            #1;

            WriteEnable = 0;
            ReadAddr = 8'h20;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            WriteEnable = 1;
            WriteAddr = 8'h30;
            WriteData = 8'h11;
            @(posedge gclk);
            #1;

            WriteEnable = 0;
            WriteAddr = 8'h30;
            WriteData = 8'h22;
            @(posedge gclk);
            #1;

            ReadAddr = 8'h30;
            @(posedge gclk);
            #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            WriteEnable = 1;
            WriteAddr = 8'h40;
            WriteData = 8'hCC;
            @(posedge gclk);
            #1;

            WriteEnable = 1;
            WriteAddr = 8'h50;
            WriteData = 8'hDD;
            ReadAddr = 8'h40;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            WriteEnable = 1;
            WriteAddr = 8'hFF;
            WriteData = 8'h99;
            @(posedge gclk);
            #1;

            WriteEnable = 0;
            ReadAddr = 8'hFF;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(8'h99);
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
        $dumpvars(0,ReadAddr, WriteAddr, WriteData, WriteEnable, gclk, ReadData);
    end

endmodule
