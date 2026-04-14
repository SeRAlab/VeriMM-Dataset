`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] DselectWire2;
    reg [31:0] bbusWire2;
    reg clk;
    reg [31:0] dbusWire1;
    reg [1:0] lwSwFlag2;
    wire [31:0] DselectWire3;
    wire [31:0] bbusWire3;
    wire [31:0] dbusWire2;
    wire [1:0] lwSwFlag3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DselectWire2(DselectWire2),
        .bbusWire2(bbusWire2),
        .clk(clk),
        .dbusWire1(dbusWire1),
        .lwSwFlag2(lwSwFlag2),
        .DselectWire3(DselectWire3),
        .bbusWire3(bbusWire3),
        .dbusWire2(dbusWire2),
        .lwSwFlag3(lwSwFlag3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dbusWire1 = 32'h0;
            DselectWire2 = 32'h0;
            bbusWire2 = 32'h0;
            lwSwFlag2 = 2'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            dbusWire1 = 32'hDEADBEEF;
            DselectWire2 = 32'h12345678;
            bbusWire2 = 32'h87654321;
            lwSwFlag2 = 2'b10;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h12345678, 32'h87654321, 32'hDEADBEEF, 2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            dbusWire1 = 32'h00000000;
            DselectWire2 = 32'h00000000;
            bbusWire2 = 32'h00000000;
            lwSwFlag2 = 2'b00;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            dbusWire1 = 32'hFFFFFFFF;
            DselectWire2 = 32'hFFFFFFFF;
            bbusWire2 = 32'hFFFFFFFF;
            lwSwFlag2 = 2'b11;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            dbusWire1 = 32'hAAAAAAAA;
            DselectWire2 = 32'h55555555;
            bbusWire2 = 32'hF0F0F0F0;
            lwSwFlag2 = 2'b01;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h55555555, 32'hF0F0F0F0, 32'hAAAAAAAA, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            dbusWire1 = 32'h0F0F0F0F;
            DselectWire2 = 32'hF0F0F0F0;
            bbusWire2 = 32'hCC33CC33;
            lwSwFlag2 = 2'b10;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hF0F0F0F0, 32'hCC33CC33, 32'h0F0F0F0F, 2'b10);
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
        input [31:0] expected_DselectWire3;
        input [31:0] expected_bbusWire3;
        input [31:0] expected_dbusWire2;
        input [1:0] expected_lwSwFlag3;
        begin
            if (expected_DselectWire3 === (expected_DselectWire3 ^ DselectWire3 ^ expected_DselectWire3) &&
                expected_bbusWire3 === (expected_bbusWire3 ^ bbusWire3 ^ expected_bbusWire3) &&
                expected_dbusWire2 === (expected_dbusWire2 ^ dbusWire2 ^ expected_dbusWire2) &&
                expected_lwSwFlag3 === (expected_lwSwFlag3 ^ lwSwFlag3 ^ expected_lwSwFlag3)) begin
                $display("PASS");
                $display("  Outputs: DselectWire3=%h, bbusWire3=%h, dbusWire2=%h, lwSwFlag3=%h",
                         DselectWire3, bbusWire3, dbusWire2, lwSwFlag3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DselectWire3=%h, bbusWire3=%h, dbusWire2=%h, lwSwFlag3=%h",
                         expected_DselectWire3, expected_bbusWire3, expected_dbusWire2, expected_lwSwFlag3);
                $display("  Got:      DselectWire3=%h, bbusWire3=%h, dbusWire2=%h, lwSwFlag3=%h",
                         DselectWire3, bbusWire3, dbusWire2, lwSwFlag3);
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
        $dumpvars(0,DselectWire2, bbusWire2, clk, dbusWire1, lwSwFlag2, DselectWire3, bbusWire3, dbusWire2, lwSwFlag3);
    end

endmodule
