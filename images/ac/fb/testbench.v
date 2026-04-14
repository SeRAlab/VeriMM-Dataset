`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [39:0] busAddr;
    reg busOE;
    reg busWR;
    reg clock;
    reg [13:0] pixCellIx;
    reg reset;
    wire busHold;
    wire [31:0] cellData1;
    wire [31:0] cellData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .busAddr(busAddr),
        .busOE(busOE),
        .busWR(busWR),
        .clock(clock),
        .pixCellIx(pixCellIx),
        .reset(reset),
        .busHold(busHold),
        .cellData1(cellData1),
        .cellData2(cellData2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        busAddr = 0;
        busOE = 0;
        busWR = 0;
        pixCellIx = 0;
        busData_reg = 0;
        bus_drive = 0;
        repeat(5) @(posedge clock);
        reset = 0;
        @(posedge clock);
    end
        endtask
    task bus_write;

        input [39:0] addr;
        input [31:0] data;
        begin
            @(posedge clock);
            busAddr = addr;
            busData_reg = data;
            bus_drive = 1;
            busWR = 1;
            @(posedge clock);

            while(busHold) @(posedge clock);
            busWR = 0;
            bus_drive = 0;
            @(posedge clock);
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        pixCellIx = 14'h0;
        repeat(2) @(posedge clock);
        #1;

        check_outputs(1'b0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        bus_write(40'h000000000A, 32'hDEADBEEF);
        pixCellIx = 14'h000A;
        repeat(2) @(posedge clock);
        #1;

        check_outputs(1'b0, 32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        bus_write(40'h000000040A, 32'hCAFEBABE);
        pixCellIx = 14'h000A;
        repeat(2) @(posedge clock);
        #1;

        check_outputs(1'b0, 32'h0, 32'hCAFEBABE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        bus_write(40'h00000001FF, 32'h11112222);
        bus_write(40'h00000005FF, 32'h33334444);
        pixCellIx = 14'h01FF;
        repeat(2) @(posedge clock);
        #1;

        check_outputs(1'b0, 32'h11112222, 32'h33334444);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        bus_write(40'h0000000055, 12345);
        pixCellIx = 14'h0055;
        repeat(5) @(posedge clock);
        #1;

        check_outputs(1'b0, 12345, 32'h0);
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
        input expected_busHold;
        input [31:0] expected_cellData1;
        input [31:0] expected_cellData2;
        begin
            if (expected_busHold === (expected_busHold ^ busHold ^ expected_busHold) &&
                expected_cellData1 === (expected_cellData1 ^ cellData1 ^ expected_cellData1) &&
                expected_cellData2 === (expected_cellData2 ^ cellData2 ^ expected_cellData2)) begin
                $display("PASS");
                $display("  Outputs: busHold=%b, cellData1=%h, cellData2=%h",
                         busHold, cellData1, cellData2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busHold=%b, cellData1=%h, cellData2=%h",
                         expected_busHold, expected_cellData1, expected_cellData2);
                $display("  Got:      busHold=%b, cellData1=%h, cellData2=%h",
                         busHold, cellData1, cellData2);
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
        $dumpvars(0,busAddr, busOE, busWR, clock, pixCellIx, reset, busHold, cellData1, cellData2);
    end

endmodule
