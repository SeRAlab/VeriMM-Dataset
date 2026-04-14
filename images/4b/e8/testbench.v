`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [4:0] index1;
    reg [4:0] index2;
    reg [31:0] writeData2;
    reg writeEnable2;
    wire [31:0] readData1;
    wire [31:0] readData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .index1(index1),
        .index2(index2),
        .writeData2(writeData2),
        .writeEnable2(writeEnable2),
        .readData1(readData1),
        .readData2(readData2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            index1 = 0;
            index2 = 0;
            writeData2 = 0;
            writeEnable2 = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            index2 = 5;
            writeData2 = 32'hDEADBEEF;
            writeEnable2 = 1;
            @(posedge clock);
            #1;


            index2 = 10;
            writeData2 = 32'hCAFEBABE;
            writeEnable2 = 1;
            @(posedge clock);
            #1;


            writeEnable2 = 0;
            index1 = 5;
            index2 = 10;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 32'hCAFEBABE);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            index2 = 15;
            writeData2 = 32'h12345678;
            writeEnable2 = 1;
            index1 = 0;

            @(posedge clock);
            #1;


            #1;



            check_outputs(readData1, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();


            index2 = 15;
            writeData2 = 32'hAAAAAAAA;
            writeEnable2 = 1;
            @(posedge clock);
            #1;


            index1 = 15;
            index2 = 20;
            writeData2 = 32'hBBBBBBBB;
            writeEnable2 = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hAAAAAAAA, 32'hBBBBBBBB);
        end
        endtask

    task testcase004;

        begin
            reset_dut();


            index2 = 7;
            writeData2 = 32'h00001111;
            writeEnable2 = 1;
            @(posedge clock);
            #1;


            index2 = 7;
            writeData2 = 32'h00002222;
            writeEnable2 = 0;
            @(posedge clock);
            #1;


            index1 = 7;
            index2 = 7;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h00001111, 32'h00001111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            index2 = 0;
            writeData2 = 32'hFFFFFFFF;
            writeEnable2 = 1;
            @(posedge clock);
            #1;

            index1 = 0;
            index2 = 0;
            writeEnable2 = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
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
        input [31:0] expected_readData1;
        input [31:0] expected_readData2;
        begin
            if (expected_readData1 === (expected_readData1 ^ readData1 ^ expected_readData1) &&
                expected_readData2 === (expected_readData2 ^ readData2 ^ expected_readData2)) begin
                $display("PASS");
                $display("  Outputs: readData1=%h, readData2=%h",
                         readData1, readData2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readData1=%h, readData2=%h",
                         expected_readData1, expected_readData2);
                $display("  Got:      readData1=%h, readData2=%h",
                         readData1, readData2);
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
        $dumpvars(0,clock, index1, index2, writeData2, writeEnable2, readData1, readData2);
    end

endmodule
