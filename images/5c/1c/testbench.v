`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg rx1DataRdyClr;
    reg rx2DataRdyClr;
    reg rx3DataRdyClr;
    reg [7:0] rxDataIn;
    reg rxDataRdySet;
    reg [7:0] tx1DataIn;
    reg tx1DataWEn;
    reg [7:0] tx2DataIn;
    reg tx2DataWEn;
    reg [7:0] tx3DataIn;
    reg tx3DataWEn;
    reg txDataFullClr;
    wire [7:0] rxDataOut;
    wire rxDataRdy;
    wire txDataFull;
    wire [7:0] txDataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .rx1DataRdyClr(rx1DataRdyClr),
        .rx2DataRdyClr(rx2DataRdyClr),
        .rx3DataRdyClr(rx3DataRdyClr),
        .rxDataIn(rxDataIn),
        .rxDataRdySet(rxDataRdySet),
        .tx1DataIn(tx1DataIn),
        .tx1DataWEn(tx1DataWEn),
        .tx2DataIn(tx2DataIn),
        .tx2DataWEn(tx2DataWEn),
        .tx3DataIn(tx3DataIn),
        .tx3DataWEn(tx3DataWEn),
        .txDataFullClr(txDataFullClr),
        .rxDataOut(rxDataOut),
        .rxDataRdy(rxDataRdy),
        .txDataFull(txDataFull),
        .txDataOut(txDataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tx1DataIn = 0;
            tx2DataIn = 0;
            tx3DataIn = 0;
            tx1DataWEn = 0;
            tx2DataWEn = 0;
            tx3DataWEn = 0;
            txDataFullClr = 0;
            rx1DataRdyClr = 0;
            rx2DataRdyClr = 0;
            rx3DataRdyClr = 0;
            rxDataIn = 0;
            rxDataRdySet = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: TX1 Write", test_num);
            tx1DataIn = 8'hA1;
            tx1DataWEn = 1;
            @(posedge clk);
            #1 tx1DataWEn = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 8'hA1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: TX2 Write", test_num);
            tx2DataIn = 8'hB2;
            tx2DataWEn = 1;
            @(posedge clk);
            #1 tx2DataWEn = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 8'hB2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: TX3 Write", test_num);
            tx3DataIn = 8'hC3;
            tx3DataWEn = 1;
            @(posedge clk);
            #1 tx3DataWEn = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 8'hC3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: TX Full Clear", test_num);

            tx1DataIn = 8'hD4;
            tx1DataWEn = 1;
            @(posedge clk);
            #1 tx1DataWEn = 0;
            txDataFullClr = 1;
            @(posedge clk);
            #1 txDataFullClr = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 8'hD4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: RX Set Data", test_num);
            rxDataIn = 8'hE5;
            rxDataRdySet = 1;
            @(posedge clk);
            #1 rxDataRdySet = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hE5, 1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: RX Ready Clear 1", test_num);
            rxDataIn = 8'hF6;
            rxDataRdySet = 1;
            @(posedge clk);
            #1 rxDataRdySet = 0;
            rx1DataRdyClr = 1;
            @(posedge clk);
            #1 rx1DataRdyClr = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hF6, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: RX Ready Clear 2", test_num);
            rxDataIn = 8'h77;
            rxDataRdySet = 1;
            @(posedge clk);
            #1 rxDataRdySet = 0;
            rx2DataRdyClr = 1;
            @(posedge clk);
            #1 rx2DataRdyClr = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h77, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: RX Ready Clear 3", test_num);
            rxDataIn = 8'h88;
            rxDataRdySet = 1;
            @(posedge clk);
            #1 rxDataRdySet = 0;
            rx3DataRdyClr = 1;
            @(posedge clk);
            #1 rx3DataRdyClr = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h88, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Sequential Overwrite", test_num);
            tx1DataIn = 8'h11;
            tx1DataWEn = 1;
            @(posedge clk);
            #1 tx1DataWEn = 0;
            tx2DataIn = 8'h22;
            tx2DataWEn = 1;
            @(posedge clk);
            #1 tx2DataWEn = 0;
            tx3DataIn = 8'h33;
            tx3DataWEn = 1;
            @(posedge clk);
            #1 tx3DataWEn = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 8'h33);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %0d: Power-on Reset State", test_num);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 8'h00);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_rxDataOut;
        input expected_rxDataRdy;
        input expected_txDataFull;
        input [7:0] expected_txDataOut;
        begin
            if (expected_rxDataOut === (expected_rxDataOut ^ rxDataOut ^ expected_rxDataOut) &&
                expected_rxDataRdy === (expected_rxDataRdy ^ rxDataRdy ^ expected_rxDataRdy) &&
                expected_txDataFull === (expected_txDataFull ^ txDataFull ^ expected_txDataFull) &&
                expected_txDataOut === (expected_txDataOut ^ txDataOut ^ expected_txDataOut)) begin
                $display("PASS");
                $display("  Outputs: rxDataOut=%h, rxDataRdy=%b, txDataFull=%b, txDataOut=%h",
                         rxDataOut, rxDataRdy, txDataFull, txDataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rxDataOut=%h, rxDataRdy=%b, txDataFull=%b, txDataOut=%h",
                         expected_rxDataOut, expected_rxDataRdy, expected_txDataFull, expected_txDataOut);
                $display("  Got:      rxDataOut=%h, rxDataRdy=%b, txDataFull=%b, txDataOut=%h",
                         rxDataOut, rxDataRdy, txDataFull, txDataOut);
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
        $dumpvars(0,clk, rst, rx1DataRdyClr, rx2DataRdyClr, rx3DataRdyClr, rxDataIn, rxDataRdySet, tx1DataIn, tx1DataWEn, tx2DataIn, tx2DataWEn, tx3DataIn, tx3DataWEn, txDataFullClr, rxDataOut, rxDataRdy, txDataFull, txDataOut);
    end

endmodule
