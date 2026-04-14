`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallelDataIn;
    reg parallelLoad;
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
        .peripheralClkEdge(peripheralClkEdge),
        .serialDataIn(serialDataIn),
        .parallelDataOut(parallelDataOut),
        .serialDataOut(serialDataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            parallelLoad = 1;
            parallelDataIn = 8'h00;
            peripheralClkEdge = 0;
            serialDataIn = 0;
            @(posedge clk);
            #1;
            parallelLoad = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            parallelLoad = 1;
            parallelDataIn = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            parallelLoad = 1;
            parallelDataIn = 8'h5A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            parallelLoad = 0;
            peripheralClkEdge = 1;
            serialDataIn = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = 4;
            reset_dut();
            data_to_shift = 8'hAB;
            parallelLoad = 0;
            peripheralClkEdge = 1;


            for(i=0; i<8; i=i+1) begin
                serialDataIn = data_to_shift[7-i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hAB, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            parallelLoad = 1;
            parallelDataIn = 8'hAA;
            @(posedge clk);
            #1;

            parallelLoad = 0;
            peripheralClkEdge = 0;
            serialDataIn = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            parallelLoad = 1;
            parallelDataIn = 8'hCC;
            peripheralClkEdge = 1;
            serialDataIn = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCC, 1'b1);
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
        $dumpvars(0,clk, parallelDataIn, parallelLoad, peripheralClkEdge, serialDataIn, parallelDataOut, serialDataOut);
    end

endmodule
