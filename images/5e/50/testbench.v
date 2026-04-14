`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [31:0] InstructionRead;
    reg [31:0] PCValue;
    reg flushcontrol;
    reg stallcontrol;
    wire [31:0] ReadDataInstructionRead;
    wire [31:0] ReadDataPCValue;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .InstructionRead(InstructionRead),
        .PCValue(PCValue),
        .flushcontrol(flushcontrol),
        .stallcontrol(stallcontrol),
        .ReadDataInstructionRead(ReadDataInstructionRead),
        .ReadDataPCValue(ReadDataPCValue)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            flushcontrol = 1;
            stallcontrol = 0;
            InstructionRead = 32'h0;
            PCValue = 32'h0;
            @(posedge Clk);
            #1;
            flushcontrol = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            PCValue = 32'h0000_1000;
            InstructionRead = 32'h0123_4567;
            stallcontrol = 0;
            flushcontrol = 0;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'h0123_4567, 32'h0000_1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            PCValue = 32'h0000_2000;
            InstructionRead = 32'hAAAA_BBBB;
            @(posedge Clk);
            #1;


            stallcontrol = 1;
            PCValue = 32'hFFFF_FFFF;
            InstructionRead = 32'hEEEE_EEEE;

            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'hAAAA_BBBB, 32'h0000_2000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            PCValue = 32'h0000_3000;
            InstructionRead = 32'h1111_2222;
            @(posedge Clk);
            #1;


            flushcontrol = 1;
            PCValue = 32'hFFFF_FFFF;
            InstructionRead = 32'hEEEE_EEEE;

            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'h0000_0000, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            PCValue = 32'h0000_4000;
            InstructionRead = 32'h5555_6666;
            @(posedge Clk);
            #1;


            flushcontrol = 1;
            stallcontrol = 1;
            PCValue = 32'h9999_9999;
            InstructionRead = 32'h8888_8888;

            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'h0000_0000, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            PCValue = 32'h10;
            InstructionRead = 32'hA;
            stallcontrol = 1;
            @(posedge Clk);
            #1;


            stallcontrol = 0;
            PCValue = 32'h20;
            InstructionRead = 32'hB;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'hB, 32'h20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            PCValue = 32'h100; InstructionRead = 32'h1;
            @(posedge Clk); #1;
            PCValue = 32'h104; InstructionRead = 32'h2;
            @(posedge Clk); #1;
            PCValue = 32'h108; InstructionRead = 32'h3;
            @(posedge Clk); #2;

            #1;


            check_outputs(32'h3, 32'h108);
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
        input [31:0] expected_ReadDataInstructionRead;
        input [31:0] expected_ReadDataPCValue;
        begin
            if (expected_ReadDataInstructionRead === (expected_ReadDataInstructionRead ^ ReadDataInstructionRead ^ expected_ReadDataInstructionRead) &&
                expected_ReadDataPCValue === (expected_ReadDataPCValue ^ ReadDataPCValue ^ expected_ReadDataPCValue)) begin
                $display("PASS");
                $display("  Outputs: ReadDataInstructionRead=%h, ReadDataPCValue=%h",
                         ReadDataInstructionRead, ReadDataPCValue);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadDataInstructionRead=%h, ReadDataPCValue=%h",
                         expected_ReadDataInstructionRead, expected_ReadDataPCValue);
                $display("  Got:      ReadDataInstructionRead=%h, ReadDataPCValue=%h",
                         ReadDataInstructionRead, ReadDataPCValue);
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
        $dumpvars(0,Clk, InstructionRead, PCValue, flushcontrol, stallcontrol, ReadDataInstructionRead, ReadDataPCValue);
    end

endmodule
