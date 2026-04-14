`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg dataReady;
    reg rst;
    wire empty;
    wire full;
    wire txBusy;
    wire [7:0] txData;
    wire txStart;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .dataReady(dataReady),
        .rst(rst),
        .empty(empty),
        .full(full),
        .txBusy(txBusy),
        .txData(txData),
        .txStart(txStart)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            dataReady = 0;
            data = 8'h00;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 8'h00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            data = 8'hA5;
            dataReady = 1;
            @(posedge clk);
            dataReady = 0;



            wait(txStart == 1);
            #1;

            #1;


            check_outputs(1, 0, 1, 8'hA5, 1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                data = 8'h10 + i;
                dataReady = 1;
                @(posedge clk);
            end
            dataReady = 0;
            #1;

            #1;


            check_outputs(0, 1, 1, 8'h10, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);

            data = 8'h11; dataReady = 1; @(posedge clk);
            data = 8'h22; dataReady = 1; @(posedge clk);
            dataReady = 0;


            wait(txStart == 1 && txData == 8'h11);
            @(posedge clk);


            wait(txStart == 1);
            #1;

            #1;


            check_outputs(0, 0, 1, 8'h22, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);

            data = 8'hAA; dataReady = 1; @(posedge clk);
            data = 8'hBB; dataReady = 1; @(posedge clk);
            dataReady = 0;




            repeat(2) begin
                wait(txStart == 1);
                @(posedge clk);
            end


            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 8'hBB, 0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);

            for (i = 0; i < 10; i = i + 1) begin
                data = 8'hF0 + i;
                dataReady = 1;
                @(posedge clk);
            end
            dataReady = 0;
            #1;

            #1;


            check_outputs(0, 1, 1, 8'hF0, 1);
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
        input expected_empty;
        input expected_full;
        input expected_txBusy;
        input [7:0] expected_txData;
        input expected_txStart;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_txBusy === (expected_txBusy ^ txBusy ^ expected_txBusy) &&
                expected_txData === (expected_txData ^ txData ^ expected_txData) &&
                expected_txStart === (expected_txStart ^ txStart ^ expected_txStart)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, txBusy=%b, txData=%h, txStart=%b",
                         empty, full, txBusy, txData, txStart);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, txBusy=%b, txData=%h, txStart=%b",
                         expected_empty, expected_full, expected_txBusy, expected_txData, expected_txStart);
                $display("  Got:      empty=%b, full=%b, txBusy=%b, txData=%h, txStart=%b",
                         empty, full, txBusy, txData, txStart);
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
        $dumpvars(0,clk, data, dataReady, rst, empty, full, txBusy, txData, txStart);
    end

endmodule
