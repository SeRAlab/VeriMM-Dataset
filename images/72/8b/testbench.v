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
    reg [1:0] lwSwFlag1;
    wire CinWire2;
    wire [31:0] DselectWire2;
    wire [2:0] SWire2;
    wire [31:0] abusWire2;
    wire [31:0] bbusWire2;
    wire immBit2;
    wire [31:0] immWire2;
    wire [1:0] lwSwFlag2;

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
        .lwSwFlag1(lwSwFlag1),
        .CinWire2(CinWire2),
        .DselectWire2(DselectWire2),
        .SWire2(SWire2),
        .abusWire2(abusWire2),
        .bbusWire2(bbusWire2),
        .immBit2(immBit2),
        .immWire2(immWire2),
        .lwSwFlag2(lwSwFlag2)
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
            lwSwFlag1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and Zero Inputs", test_num);
            reset_dut();


            CinWire1 = 1'b0;
            DselectWire1 = 32'h00000000;
            SWire1 = 3'b000;
            abusWire1 = 32'h00000000;
            bbusWire1 = 32'h00000000;
            immBit1 = 1'b0;
            immWire1 = 32'h00000000;
            lwSwFlag1 = 2'b00;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'h0, 3'b000, 32'h0, 32'h0, 1'b0, 32'h0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Values Latching", test_num);
            reset_dut();

            CinWire1 = 1'b1;
            DselectWire1 = 32'hFFFFFFFF;
            SWire1 = 3'b111;
            abusWire1 = 32'hFFFFFFFF;
            bbusWire1 = 32'hFFFFFFFF;
            immBit1 = 1'b1;
            immWire1 = 32'hFFFFFFFF;
            lwSwFlag1 = 2'b11;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF, 3'b111, 32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bit Patterns", test_num);
            reset_dut();

            CinWire1 = 1'b0;
            DselectWire1 = 32'hAAAAAAAA;
            SWire1 = 3'b101;
            abusWire1 = 32'h55555555;
            bbusWire1 = 32'hAAAAAAAA;
            immBit1 = 1'b1;
            immWire1 = 32'h55555555;
            lwSwFlag1 = 2'b10;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'hAAAAAAAA, 3'b101, 32'h55555555, 32'hAAAAAAAA, 1'b1, 32'h55555555, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Random Hex Data Check", test_num);
            reset_dut();

            CinWire1 = 1'b1;
            DselectWire1 = 32'h12345678;
            SWire1 = 3'b011;
            abusWire1 = 32'hDEADBEEF;
            bbusWire1 = 32'hCAFEBABE;
            immBit1 = 1'b0;
            immWire1 = 32'h87654321;
            lwSwFlag1 = 2'b01;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h12345678, 3'b011, 32'hDEADBEEF, 32'hCAFEBABE, 1'b0, 32'h87654321, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Propagation and Signal Stability", test_num);
            reset_dut();


            CinWire1 = 1'b0;
            DselectWire1 = 32'hA5A5A5A5;
            SWire1 = 3'b110;
            abusWire1 = 32'h0F0F0F0F;
            bbusWire1 = 32'hF0F0F0F0;
            immBit1 = 1'b1;
            immWire1 = 32'h3C3C3C3C;
            lwSwFlag1 = 2'b11;

            @(posedge clk);
            #1;


            CinWire1 = 1'b1;
            DselectWire1 = 32'hFFFFFFFF;

            #1;
            #1;

            check_outputs(1'b0, 32'hA5A5A5A5, 3'b110, 32'h0F0F0F0F, 32'hF0F0F0F0, 1'b1, 32'h3C3C3C3C, 2'b11);
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
        input [1:0] expected_lwSwFlag2;
        begin
            if (expected_CinWire2 === (expected_CinWire2 ^ CinWire2 ^ expected_CinWire2) &&
                expected_DselectWire2 === (expected_DselectWire2 ^ DselectWire2 ^ expected_DselectWire2) &&
                expected_SWire2 === (expected_SWire2 ^ SWire2 ^ expected_SWire2) &&
                expected_abusWire2 === (expected_abusWire2 ^ abusWire2 ^ expected_abusWire2) &&
                expected_bbusWire2 === (expected_bbusWire2 ^ bbusWire2 ^ expected_bbusWire2) &&
                expected_immBit2 === (expected_immBit2 ^ immBit2 ^ expected_immBit2) &&
                expected_immWire2 === (expected_immWire2 ^ immWire2 ^ expected_immWire2) &&
                expected_lwSwFlag2 === (expected_lwSwFlag2 ^ lwSwFlag2 ^ expected_lwSwFlag2)) begin
                $display("PASS");
                $display("  Outputs: CinWire2=%b, DselectWire2=%h, SWire2=%h, abusWire2=%h, bbusWire2=%h, immBit2=%b, immWire2=%h, lwSwFlag2=%h",
                         CinWire2, DselectWire2, SWire2, abusWire2, bbusWire2, immBit2, immWire2, lwSwFlag2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CinWire2=%b, DselectWire2=%h, SWire2=%h, abusWire2=%h, bbusWire2=%h, immBit2=%b, immWire2=%h, lwSwFlag2=%h",
                         expected_CinWire2, expected_DselectWire2, expected_SWire2, expected_abusWire2, expected_bbusWire2, expected_immBit2, expected_immWire2, expected_lwSwFlag2);
                $display("  Got:      CinWire2=%b, DselectWire2=%h, SWire2=%h, abusWire2=%h, bbusWire2=%h, immBit2=%b, immWire2=%h, lwSwFlag2=%h",
                         CinWire2, DselectWire2, SWire2, abusWire2, bbusWire2, immBit2, immWire2, lwSwFlag2);
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
        $dumpvars(0,CinWire1, DselectWire1, SWire1, abusWire1, bbusWire1, clk, immBit1, immWire1, lwSwFlag1, CinWire2, DselectWire2, SWire2, abusWire2, bbusWire2, immBit2, immWire2, lwSwFlag2);
    end

endmodule
