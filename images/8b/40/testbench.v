`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] DselectWire2;
    reg clk;
    reg [31:0] dbusWire1;
    wire [31:0] DselectWire3;
    wire [31:0] dbusWire2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DselectWire2(DselectWire2),
        .clk(clk),
        .dbusWire1(dbusWire1),
        .DselectWire3(DselectWire3),
        .dbusWire2(dbusWire2)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Transfer", test_num);
            reset_dut();
            dbusWire1 = 32'h12345678;
            DselectWire2 = 32'h87654321;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h87654321, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Zeros Transfer", test_num);
            reset_dut();
            dbusWire1 = 32'h00000000;
            DselectWire2 = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: All Ones Transfer", test_num);
            reset_dut();
            dbusWire1 = 32'hFFFFFFFF;
            DselectWire2 = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Alternating Bits Pattern", test_num);
            reset_dut();
            dbusWire1 = 32'hAAAAAAAA;
            DselectWire2 = 32'h55555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h55555555, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Specific Hex Pattern (BEEF/CAFE)", test_num);
            reset_dut();
            dbusWire1 = 32'hDEADBEEF;
            DselectWire2 = 32'hCAFEBABE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCAFEBABE, 32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Single Bit Shift Pattern", test_num);
            reset_dut();
            dbusWire1 = 32'h00000001;
            DselectWire2 = 32'h80000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h80000000, 32'h00000001);
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
        input [31:0] expected_DselectWire3;
        input [31:0] expected_dbusWire2;
        begin
            if (expected_DselectWire3 === (expected_DselectWire3 ^ DselectWire3 ^ expected_DselectWire3) &&
                expected_dbusWire2 === (expected_dbusWire2 ^ dbusWire2 ^ expected_dbusWire2)) begin
                $display("PASS");
                $display("  Outputs: DselectWire3=%h, dbusWire2=%h",
                         DselectWire3, dbusWire2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DselectWire3=%h, dbusWire2=%h",
                         expected_DselectWire3, expected_dbusWire2);
                $display("  Got:      DselectWire3=%h, dbusWire2=%h",
                         DselectWire3, dbusWire2);
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
        $dumpvars(0,DselectWire2, clk, dbusWire1, DselectWire3, dbusWire2);
    end

endmodule
