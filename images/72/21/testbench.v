`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallelDataIn;
    reg parallelLoad;
    reg peripheralClk8Edge;
    reg peripheralClkEdge;
    reg serialDataIn;
    wire [7:0] parallelDataOut;
    wire serialDataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .parallelDataIn(parallelDataIn),
        .parallelLoad(parallelLoad),
        .peripheralClk8Edge(peripheralClk8Edge),
        .peripheralClkEdge(peripheralClkEdge),
        .serialDataIn(serialDataIn),
        .parallelDataOut(parallelDataOut),
        .serialDataOut(serialDataOut)
    );

    // Clock generation (10ns period)
    initial begin
        peripheralClkEdge = 0;
        forever #5 peripheralClkEdge = ~peripheralClkEdge;
    end

        task reset_dut;

        begin
            @(negedge peripheralClkEdge);
            parallelLoad = 0;
            parallelDataIn = 8'b0;
            serialDataIn = 0;
            peripheralClk8Edge = 0;
            clk = 0;
            repeat(2) @(negedge peripheralClkEdge);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 8'hAA", test_num);
            @(negedge peripheralClkEdge);
            parallelDataIn = 8'hAA;
            parallelLoad = 1;
            @(negedge peripheralClkEdge);
            parallelLoad = 0;
            #2;

            #1;


            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 8'h55", test_num);
            @(negedge peripheralClkEdge);
            parallelDataIn = 8'h55;
            parallelLoad = 1;
            @(negedge peripheralClkEdge);
            parallelLoad = 0;
            #2;

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Serial Shift In 1 (Base 0x00)", test_num);
            @(negedge peripheralClkEdge);
            parallelDataIn = 8'h00;
            parallelLoad = 1;
            @(negedge peripheralClkEdge);
            parallelLoad = 0;
            serialDataIn = 1;
            @(negedge peripheralClkEdge);
            #2;

            #1;


            check_outputs(8'h80, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Serial Shift In 0 (Base 0xFF)", test_num);
            @(negedge peripheralClkEdge);
            parallelDataIn = 8'hFF;
            parallelLoad = 1;
            @(negedge peripheralClkEdge);
            parallelLoad = 0;
            serialDataIn = 0;
            @(negedge peripheralClkEdge);
            #2;

            #1;


            check_outputs(8'h7F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Serial Shift In 1 (Base 0x55)", test_num);
            @(negedge peripheralClkEdge);
            parallelDataIn = 8'h55;
            parallelLoad = 1;
            @(negedge peripheralClkEdge);
            parallelLoad = 0;
            serialDataIn = 1;
            @(negedge peripheralClkEdge);
            #2;

            #1;


            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Serial Shift In 0 (Base 0xAA)", test_num);
            @(negedge peripheralClkEdge);
            parallelDataIn = 8'hAA;
            parallelLoad = 1;
            @(negedge peripheralClkEdge);
            parallelLoad = 0;
            serialDataIn = 0;
            @(negedge peripheralClkEdge);
            #2;

            #1;


            check_outputs(8'h55, 1'b1);
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
        input [7:0] expected_parallelDataOut;
        input expected_serialDataOut;
        begin
            if (expected_parallelDataOut === (expected_parallelDataOut ^ parallelDataOut ^ expected_parallelDataOut) &&
                expected_serialDataOut === (expected_serialDataOut ^ serialDataOut ^ expected_serialDataOut)) begin
                $display("PASS");
                $display("  Outputs: parallelDataOut=%h, serialDataOut=%b",
                         parallelDataOut, serialDataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallelDataOut=%h, serialDataOut=%b",
                         expected_parallelDataOut, expected_serialDataOut);
                $display("  Got:      parallelDataOut=%h, serialDataOut=%b",
                         parallelDataOut, serialDataOut);
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
        $dumpvars(0,clk, parallelDataIn, parallelLoad, peripheralClk8Edge, peripheralClkEdge, serialDataIn, parallelDataOut, serialDataOut);
    end

endmodule
