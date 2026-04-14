`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] DselectWire2;
    reg NOPWire1;
    reg [63:0] bbusWire2;
    reg [2:0] branchControlBitWire1;
    reg clk;
    reg [63:0] dbusWire1;
    reg [1:0] lwSwFlag2;
    wire [31:0] DselectWire3;
    wire NOPWire2;
    wire [63:0] bbusWire3;
    wire [2:0] branchControlBitWire2;
    wire [63:0] dbusWire2;
    wire [1:0] lwSwFlag3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DselectWire2(DselectWire2),
        .NOPWire1(NOPWire1),
        .bbusWire2(bbusWire2),
        .branchControlBitWire1(branchControlBitWire1),
        .clk(clk),
        .dbusWire1(dbusWire1),
        .lwSwFlag2(lwSwFlag2),
        .DselectWire3(DselectWire3),
        .NOPWire2(NOPWire2),
        .bbusWire3(bbusWire3),
        .branchControlBitWire2(branchControlBitWire2),
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
            DselectWire2 = 0;
            NOPWire1 = 0;
            bbusWire2 = 0;
            branchControlBitWire1 = 0;
            dbusWire1 = 0;
            lwSwFlag2 = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Basic data transfer", test_num);

            dbusWire1 = 64'hAAAA_BBBB_CCCC_DDDD;
            DselectWire2 = 32'h1234_5678;
            bbusWire2 = 64'h1122_3344_5566_7788;
            lwSwFlag2 = 2'b10;
            branchControlBitWire1 = 3'b101;
            NOPWire1 = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h1234_5678, 1'b1, 64'h1122_3344_5566_7788, 3'b101, 64'hAAAA_BBBB_CCCC_DDDD, 2'b10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: All bits set to 1", test_num);

            dbusWire1 = 64'hFFFF_FFFF_FFFF_FFFF;
            DselectWire2 = 32'hFFFF_FFFF;
            bbusWire2 = 64'hFFFF_FFFF_FFFF_FFFF;
            lwSwFlag2 = 2'b11;
            branchControlBitWire1 = 3'b111;
            NOPWire1 = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b1, 64'hFFFF_FFFF_FFFF_FFFF, 3'b111, 64'hFFFF_FFFF_FFFF_FFFF, 2'b11);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Zero input check", test_num);

            dbusWire1 = 0;
            DselectWire2 = 0;
            bbusWire2 = 0;
            lwSwFlag2 = 0;
            branchControlBitWire1 = 0;
            NOPWire1 = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 1'b0, 64'h0, 3'b0, 64'h0, 2'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Alternating bit patterns", test_num);

            dbusWire1 = 64'h5555_AAAA_5555_AAAA;
            DselectWire2 = 32'hAAAA_5555;
            bbusWire2 = 64'h0F0F_F0F0_0F0F_F0F0;
            lwSwFlag2 = 2'b01;
            branchControlBitWire1 = 3'b010;
            NOPWire1 = 1'b0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA_5555, 1'b0, 64'h0F0F_F0F0_0F0F_F0F0, 3'b010, 64'h5555_AAAA_5555_AAAA, 2'b01);
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
        input expected_NOPWire2;
        input [63:0] expected_bbusWire3;
        input [2:0] expected_branchControlBitWire2;
        input [63:0] expected_dbusWire2;
        input [1:0] expected_lwSwFlag3;
        begin
            if (expected_DselectWire3 === (expected_DselectWire3 ^ DselectWire3 ^ expected_DselectWire3) &&
                expected_NOPWire2 === (expected_NOPWire2 ^ NOPWire2 ^ expected_NOPWire2) &&
                expected_bbusWire3 === (expected_bbusWire3 ^ bbusWire3 ^ expected_bbusWire3) &&
                expected_branchControlBitWire2 === (expected_branchControlBitWire2 ^ branchControlBitWire2 ^ expected_branchControlBitWire2) &&
                expected_dbusWire2 === (expected_dbusWire2 ^ dbusWire2 ^ expected_dbusWire2) &&
                expected_lwSwFlag3 === (expected_lwSwFlag3 ^ lwSwFlag3 ^ expected_lwSwFlag3)) begin
                $display("PASS");
                $display("  Outputs: DselectWire3=%h, NOPWire2=%b, bbusWire3=%h, branchControlBitWire2=%h, dbusWire2=%h, lwSwFlag3=%h",
                         DselectWire3, NOPWire2, bbusWire3, branchControlBitWire2, dbusWire2, lwSwFlag3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DselectWire3=%h, NOPWire2=%b, bbusWire3=%h, branchControlBitWire2=%h, dbusWire2=%h, lwSwFlag3=%h",
                         expected_DselectWire3, expected_NOPWire2, expected_bbusWire3, expected_branchControlBitWire2, expected_dbusWire2, expected_lwSwFlag3);
                $display("  Got:      DselectWire3=%h, NOPWire2=%b, bbusWire3=%h, branchControlBitWire2=%h, dbusWire2=%h, lwSwFlag3=%h",
                         DselectWire3, NOPWire2, bbusWire3, branchControlBitWire2, dbusWire2, lwSwFlag3);
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
        $dumpvars(0,DselectWire2, NOPWire1, bbusWire2, branchControlBitWire1, clk, dbusWire1, lwSwFlag2, DselectWire3, NOPWire2, bbusWire3, branchControlBitWire2, dbusWire2, lwSwFlag3);
    end

endmodule
