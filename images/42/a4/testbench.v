`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg dataReady;
    reg rst;
    reg txBusy;
    wire empty;
    wire full;
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
        .txBusy(txBusy),
        .empty(empty),
        .full(full),
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
            data = 0;
            txBusy = 1;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 8'bzzzz_zzzz, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Byte Write", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'hA5;
            dataReady = 1;
            @(posedge clk);
            dataReady = 0;


            @(posedge clk);
            txBusy = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Buffer Full Check", test_num);
            reset_dut();

            txBusy = 1;
            for (i = 0; i < 64; i = i + 1) begin
                @(posedge clk);
                data = i[7:0];
                dataReady = 1;
            end
            @(posedge clk);
            dataReady = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Buffer Emptying Check", test_num);
            reset_dut();


            txBusy = 1;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                data = i + 8'h10;
                dataReady = 1;
            end
            @(posedge clk);
            dataReady = 0;


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                txBusy = 0;
                @(posedge clk);
                txBusy = 1;
            end

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 8'bzzzz_zzzz, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overrun Handling", test_num);
            reset_dut();

            txBusy = 1;
            for (i = 0; i < 70; i = i + 1) begin
                @(posedge clk);
                data = i[7:0];
                dataReady = 1;
            end
            @(posedge clk);
            dataReady = 0;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous Flow", test_num);
            reset_dut();

            txBusy = 0;
            @(posedge clk);
            data = 8'h55;
            dataReady = 1;
            @(posedge clk);
            data = 8'hAA;
            dataReady = 1;
            @(posedge clk);
            dataReady = 0;


            txBusy = 1;
            repeat(2) @(posedge clk);
            txBusy = 0;
            repeat(1) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'hAA, 1'b1);
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
        input [7:0] expected_txData;
        input expected_txStart;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_txData === (expected_txData ^ txData ^ expected_txData) &&
                expected_txStart === (expected_txStart ^ txStart ^ expected_txStart)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, txData=%h, txStart=%b",
                         empty, full, txData, txStart);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, txData=%h, txStart=%b",
                         expected_empty, expected_full, expected_txData, expected_txStart);
                $display("  Got:      empty=%b, full=%b, txData=%h, txStart=%b",
                         empty, full, txData, txStart);
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
        $dumpvars(0,clk, data, dataReady, rst, txBusy, empty, full, txData, txStart);
    end

endmodule
