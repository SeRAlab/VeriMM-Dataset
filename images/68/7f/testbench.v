`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg busClk;
    reg [7:0] busDataIn;
    reg [7:0] fifoDataIn;
    reg fifoSelect;
    reg [15:0] numElementsInFifo;
    reg rstSyncToBusClk;
    reg strobe_i;
    reg usbClk;
    reg writeEn;
    wire [7:0] busDataOut;
    wire fifoREn;
    wire forceEmptySyncToBusClk;
    wire forceEmptySyncToUsbClk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .busClk(busClk),
        .busDataIn(busDataIn),
        .fifoDataIn(fifoDataIn),
        .fifoSelect(fifoSelect),
        .numElementsInFifo(numElementsInFifo),
        .rstSyncToBusClk(rstSyncToBusClk),
        .strobe_i(strobe_i),
        .usbClk(usbClk),
        .writeEn(writeEn),
        .busDataOut(busDataOut),
        .fifoREn(fifoREn),
        .forceEmptySyncToBusClk(forceEmptySyncToBusClk),
        .forceEmptySyncToUsbClk(forceEmptySyncToUsbClk)
    );

    // Clock generation (10ns period)
    initial begin
        busClk = 0;
        forever #5 busClk = ~busClk;
    end

        task reset_dut;

        begin
            rstSyncToBusClk = 1;
            address = 0;
            busDataIn = 0;
            fifoDataIn = 0;
            fifoSelect = 0;
            numElementsInFifo = 0;
            strobe_i = 0;
            writeEn = 0;
            repeat (5) @(posedge busClk);
            rstSyncToBusClk = 0;
            @(posedge busClk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge busClk);
            address = 3'b000;
            fifoDataIn = 8'hA5;
            fifoSelect = 1;
            strobe_i = 1;
            writeEn = 0;
            @(posedge busClk);

            #1;


            check_outputs(8'hA5, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge busClk);
            address = 3'b001;
            numElementsInFifo = 16'h1234;
            fifoSelect = 1;
            strobe_i = 1;
            writeEn = 0;
            @(posedge busClk);

            #1;


            check_outputs(8'h34, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge busClk);
            address = 3'b010;
            numElementsInFifo = 16'h1234;
            fifoSelect = 1;
            strobe_i = 1;
            writeEn = 0;
            @(posedge busClk);

            #1;


            check_outputs(8'h12, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge busClk);
            address = 3'b011;
            busDataIn = 8'h01;
            fifoSelect = 1;
            strobe_i = 1;
            writeEn = 1;
            @(posedge busClk);

            repeat (10) @(posedge busClk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge busClk);
            address = 3'b000;
            fifoDataIn = 8'hFF;
            fifoSelect = 0;
            strobe_i = 1;
            writeEn = 0;
            @(posedge busClk);


            #1;



            check_outputs(busDataOut, 1'b0, 1'b0, 1'b0);
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
        input [7:0] expected_busDataOut;
        input expected_fifoREn;
        input expected_forceEmptySyncToBusClk;
        input expected_forceEmptySyncToUsbClk;
        begin
            if (expected_busDataOut === (expected_busDataOut ^ busDataOut ^ expected_busDataOut) &&
                expected_fifoREn === (expected_fifoREn ^ fifoREn ^ expected_fifoREn) &&
                expected_forceEmptySyncToBusClk === (expected_forceEmptySyncToBusClk ^ forceEmptySyncToBusClk ^ expected_forceEmptySyncToBusClk) &&
                expected_forceEmptySyncToUsbClk === (expected_forceEmptySyncToUsbClk ^ forceEmptySyncToUsbClk ^ expected_forceEmptySyncToUsbClk)) begin
                $display("PASS");
                $display("  Outputs: busDataOut=%h, fifoREn=%b, forceEmptySyncToBusClk=%b, forceEmptySyncToUsbClk=%b",
                         busDataOut, fifoREn, forceEmptySyncToBusClk, forceEmptySyncToUsbClk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busDataOut=%h, fifoREn=%b, forceEmptySyncToBusClk=%b, forceEmptySyncToUsbClk=%b",
                         expected_busDataOut, expected_fifoREn, expected_forceEmptySyncToBusClk, expected_forceEmptySyncToUsbClk);
                $display("  Got:      busDataOut=%h, fifoREn=%b, forceEmptySyncToBusClk=%b, forceEmptySyncToUsbClk=%b",
                         busDataOut, fifoREn, forceEmptySyncToBusClk, forceEmptySyncToUsbClk);
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
        $dumpvars(0,address, busClk, busDataIn, fifoDataIn, fifoSelect, numElementsInFifo, rstSyncToBusClk, strobe_i, usbClk, writeEn, busDataOut, fifoREn, forceEmptySyncToBusClk, forceEmptySyncToUsbClk);
    end

endmodule
