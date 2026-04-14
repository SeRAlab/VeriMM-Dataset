`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] DataAddress;
    reg MEM_READ;
    reg MEM_WRITE;
    reg Reset;
    reg [7:0] WriteData;
    wire [7:0] ReadData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .DataAddress(DataAddress),
        .MEM_READ(MEM_READ),
        .MEM_WRITE(MEM_WRITE),
        .Reset(Reset),
        .WriteData(WriteData),
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
            MEM_READ = 0;
            MEM_WRITE = 0;
            DataAddress = 0;
            WriteData = 0;
            @(posedge Clk);
            #1;
            Reset = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Initialization Check", test_num);
            reset_dut();


            MEM_READ = 1;
            DataAddress = 8'h05;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read Check", test_num);
            reset_dut();


            MEM_WRITE = 1;
            DataAddress = 8'h10;
            WriteData = 8'hAA;
            @(posedge Clk);
            #1;


            MEM_WRITE = 0;
            MEM_READ = 1;
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-Impedance (Hi-Z) Check", test_num);
            reset_dut();


            MEM_READ = 0;
            DataAddress = 8'h00;
            #2;
            #1;

            check_outputs(8'hzz);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Address Check", test_num);
            reset_dut();


            MEM_WRITE = 1;
            DataAddress = 8'h01;
            WriteData = 8'h55;
            @(posedge Clk);
            #1;


            DataAddress = 8'h02;
            WriteData = 8'h33;
            @(posedge Clk);
            #1;


            MEM_WRITE = 0;
            MEM_READ = 1;
            DataAddress = 8'h01;
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Check", test_num);
            reset_dut();


            MEM_WRITE = 1;
            DataAddress = 8'hFF;
            WriteData = 8'h11;
            @(posedge Clk);
            #1;


            WriteData = 8'h22;
            @(posedge Clk);
            #1;

            MEM_WRITE = 0;
            MEM_READ = 1;
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Tri-state Toggle Check", test_num);
            reset_dut();


            MEM_WRITE = 1;
            DataAddress = 8'h05;
            WriteData = 8'h77;
            @(posedge Clk);
            #1;


            MEM_WRITE = 0;
            MEM_READ = 1;
            #2;


            MEM_READ = 0;
            #2;
            #1;

            check_outputs(8'hzz);
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
        $dumpvars(0,Clk, DataAddress, MEM_READ, MEM_WRITE, Reset, WriteData, ReadData);
    end

endmodule
