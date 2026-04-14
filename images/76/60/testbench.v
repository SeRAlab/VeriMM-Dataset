`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CinWire1;
    reg [31:0] DselectWire1;
    reg [2:0] SWire1;
    reg [31:0] abusWire1;
    reg [31:0] bbusWire1;
    reg clk;
    reg immBit1;
    reg [31:0] immWire1;
    wire CinWire2;
    wire [31:0] DselectWire2;
    wire [2:0] SWire2;
    wire [31:0] abusWire2;
    wire [31:0] bbusWire2;
    wire immBit2;
    wire [31:0] immWire2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CinWire1(CinWire1),
        .DselectWire1(DselectWire1),
        .SWire1(SWire1),
        .abusWire1(abusWire1),
        .bbusWire1(bbusWire1),
        .clk(clk),
        .immBit1(immBit1),
        .immWire1(immWire1),
        .CinWire2(CinWire2),
        .DselectWire2(DselectWire2),
        .SWire2(SWire2),
        .abusWire2(abusWire2),
        .bbusWire2(bbusWire2),
        .immBit2(immBit2),
        .immWire2(immWire2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            CinWire1 = 0;
            DselectWire1 = 0;
            SWire1 = 0;
            abusWire1 = 0;
            bbusWire1 = 0;
            immBit1 = 0;
            immWire1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            abusWire1 = 32'h12345678;
            bbusWire1 = 32'h87654321;
            DselectWire1 = 32'hA5A5A5A5;
            immWire1 = 32'h5A5A5A5A;
            SWire1 = 3'b101;
            CinWire1 = 1'b1;
            immBit1 = 1'b0;

            @(posedge clk);
            #1;
            $display("Testcase %0d: Basic Data Transfer", test_num);
            #1;

            check_outputs(1'b1, 32'hA5A5A5A5, 3'b101, 32'h12345678, 32'h87654321, 1'b0, 32'h5A5A5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            abusWire1 = 32'hFFFFFFFF;
            bbusWire1 = 32'hFFFFFFFF;
            DselectWire1 = 32'hFFFFFFFF;
            immWire1 = 32'hFFFFFFFF;
            SWire1 = 3'b111;
            CinWire1 = 1'b1;
            immBit1 = 1'b1;

            @(posedge clk);
            #1;
            $display("Testcase %0d: All Ones Transfer", test_num);
            #1;

            check_outputs(1'b1, 32'hFFFFFFFF, 3'b111, 32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            abusWire1 = 32'hAAAAAAAA;
            bbusWire1 = 32'h55555555;
            DselectWire1 = 32'h33333333;
            immWire1 = 32'hCCCCCCCC;
            SWire1 = 3'b010;
            CinWire1 = 1'b0;
            immBit1 = 1'b1;

            @(posedge clk);
            #1;
            $display("Testcase %0d: Alternating Bits Transfer", test_num);
            #1;

            check_outputs(1'b0, 32'h33333333, 3'b010, 32'hAAAAAAAA, 32'h55555555, 1'b1, 32'hCCCCCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            abusWire1 = 0;
            bbusWire1 = 0;
            DselectWire1 = 0;
            immWire1 = 0;
            SWire1 = 3'b110;
            CinWire1 = 1'b1;
            immBit1 = 1'b1;

            @(posedge clk);
            #1;
            $display("Testcase %0d: Control Signals Toggle", test_num);
            #1;

            check_outputs(1'b1, 32'h0, 3'b110, 32'h0, 32'h0, 1'b1, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            abusWire1 = 32'h80000000;
            bbusWire1 = 32'h00000001;
            DselectWire1 = 32'h7FFFFFFF;
            immWire1 = 32'hFFFFFFF0;
            SWire1 = 3'b000;
            CinWire1 = 1'b0;
            immBit1 = 1'b0;

            @(posedge clk);
            #1;
            $display("Testcase %0d: Boundary Values", test_num);
            #1;

            check_outputs(1'b0, 32'h7FFFFFFF, 3'b000, 32'h80000000, 32'h00000001, 1'b0, 32'hFFFFFFF0);
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
        input expected_CinWire2;
        input [31:0] expected_DselectWire2;
        input [2:0] expected_SWire2;
        input [31:0] expected_abusWire2;
        input [31:0] expected_bbusWire2;
        input expected_immBit2;
        input [31:0] expected_immWire2;
        begin
            if (expected_CinWire2 === (expected_CinWire2 ^ CinWire2 ^ expected_CinWire2) &&
                expected_DselectWire2 === (expected_DselectWire2 ^ DselectWire2 ^ expected_DselectWire2) &&
                expected_SWire2 === (expected_SWire2 ^ SWire2 ^ expected_SWire2) &&
                expected_abusWire2 === (expected_abusWire2 ^ abusWire2 ^ expected_abusWire2) &&
                expected_bbusWire2 === (expected_bbusWire2 ^ bbusWire2 ^ expected_bbusWire2) &&
                expected_immBit2 === (expected_immBit2 ^ immBit2 ^ expected_immBit2) &&
                expected_immWire2 === (expected_immWire2 ^ immWire2 ^ expected_immWire2)) begin
                $display("PASS");
                $display("  Outputs: CinWire2=%b, DselectWire2=%h, SWire2=%h, abusWire2=%h, bbusWire2=%h, immBit2=%b, immWire2=%h",
                         CinWire2, DselectWire2, SWire2, abusWire2, bbusWire2, immBit2, immWire2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CinWire2=%b, DselectWire2=%h, SWire2=%h, abusWire2=%h, bbusWire2=%h, immBit2=%b, immWire2=%h",
                         expected_CinWire2, expected_DselectWire2, expected_SWire2, expected_abusWire2, expected_bbusWire2, expected_immBit2, expected_immWire2);
                $display("  Got:      CinWire2=%b, DselectWire2=%h, SWire2=%h, abusWire2=%h, bbusWire2=%h, immBit2=%b, immWire2=%h",
                         CinWire2, DselectWire2, SWire2, abusWire2, bbusWire2, immBit2, immWire2);
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
        $dumpvars(0,CinWire1, DselectWire1, SWire1, abusWire1, bbusWire1, clk, immBit1, immWire1, CinWire2, DselectWire2, SWire2, abusWire2, bbusWire2, immBit2, immWire2);
    end

endmodule
