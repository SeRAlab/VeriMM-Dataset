`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] DselectWire3;
    reg [31:0] bbusWire3;
    reg [1:0] branchControlBitWire2;
    reg clk;
    reg [31:0] dbusWire2;
    reg [1:0] lwSwFlag3;
    wire [31:0] DselectWire4;
    wire [31:0] bbusWire4;
    wire [1:0] branchControlBitWire3;
    wire [31:0] dbusWire3;
    wire [1:0] lwSwFlag4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DselectWire3(DselectWire3),
        .bbusWire3(bbusWire3),
        .branchControlBitWire2(branchControlBitWire2),
        .clk(clk),
        .dbusWire2(dbusWire2),
        .lwSwFlag3(lwSwFlag3),
        .DselectWire4(DselectWire4),
        .bbusWire4(bbusWire4),
        .branchControlBitWire3(branchControlBitWire3),
        .dbusWire3(dbusWire3),
        .lwSwFlag4(lwSwFlag4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dbusWire2 = 32'h0;
            DselectWire3 = 32'h0;
            bbusWire3 = 32'h0;
            lwSwFlag3 = 2'h0;
            branchControlBitWire2 = 2'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            dbusWire2 = 32'h0;
            DselectWire3 = 32'h0;
            bbusWire3 = 32'h0;
            lwSwFlag3 = 2'h0;
            branchControlBitWire2 = 2'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 2'h0, 32'h0, 2'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Arbitrary Values", test_num);
            reset_dut();
            dbusWire2 = 32'h12345678;
            DselectWire3 = 32'hABCDEF01;
            bbusWire3 = 32'h87654321;
            lwSwFlag3 = 2'b10;
            branchControlBitWire2 = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCDEF01, 32'h87654321, 2'b01, 32'h12345678, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            dbusWire2 = 32'hFFFFFFFF;
            DselectWire3 = 32'hFFFFFFFF;
            bbusWire3 = 32'hFFFFFFFF;
            lwSwFlag3 = 2'b11;
            branchControlBitWire2 = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 2'b11, 32'hFFFFFFFF, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Alternating Bits", test_num);
            reset_dut();
            dbusWire2 = 32'h55555555;
            DselectWire3 = 32'hAAAAAAAA;
            bbusWire3 = 32'h55555555;
            lwSwFlag3 = 2'b01;
            branchControlBitWire2 = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h55555555, 2'b10, 32'h55555555, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Values", test_num);
            reset_dut();
            dbusWire2 = 32'h80000000;
            DselectWire3 = 32'h00000001;
            bbusWire3 = 32'h7FFFFFFF;
            lwSwFlag3 = 2'b00;
            branchControlBitWire2 = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000001, 32'h7FFFFFFF, 2'b11, 32'h80000000, 2'b00);
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
        input [31:0] expected_DselectWire4;
        input [31:0] expected_bbusWire4;
        input [1:0] expected_branchControlBitWire3;
        input [31:0] expected_dbusWire3;
        input [1:0] expected_lwSwFlag4;
        begin
            if (expected_DselectWire4 === (expected_DselectWire4 ^ DselectWire4 ^ expected_DselectWire4) &&
                expected_bbusWire4 === (expected_bbusWire4 ^ bbusWire4 ^ expected_bbusWire4) &&
                expected_branchControlBitWire3 === (expected_branchControlBitWire3 ^ branchControlBitWire3 ^ expected_branchControlBitWire3) &&
                expected_dbusWire3 === (expected_dbusWire3 ^ dbusWire3 ^ expected_dbusWire3) &&
                expected_lwSwFlag4 === (expected_lwSwFlag4 ^ lwSwFlag4 ^ expected_lwSwFlag4)) begin
                $display("PASS");
                $display("  Outputs: DselectWire4=%h, bbusWire4=%h, branchControlBitWire3=%h, dbusWire3=%h, lwSwFlag4=%h",
                         DselectWire4, bbusWire4, branchControlBitWire3, dbusWire3, lwSwFlag4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DselectWire4=%h, bbusWire4=%h, branchControlBitWire3=%h, dbusWire3=%h, lwSwFlag4=%h",
                         expected_DselectWire4, expected_bbusWire4, expected_branchControlBitWire3, expected_dbusWire3, expected_lwSwFlag4);
                $display("  Got:      DselectWire4=%h, bbusWire4=%h, branchControlBitWire3=%h, dbusWire3=%h, lwSwFlag4=%h",
                         DselectWire4, bbusWire4, branchControlBitWire3, dbusWire3, lwSwFlag4);
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
        $dumpvars(0,DselectWire3, bbusWire3, branchControlBitWire2, clk, dbusWire2, lwSwFlag3, DselectWire4, bbusWire4, branchControlBitWire3, dbusWire3, lwSwFlag4);
    end

endmodule
