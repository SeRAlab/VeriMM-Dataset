`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] as1;
    reg [2:0] as2;
    reg [2:0] bs1;
    reg [2:0] bs2;
    reg [15:0] cd1;
    reg [15:0] cd2;
    reg clk;
    reg [2:0] cs1;
    reg [2:0] cs2;
    reg cw1;
    reg cw2;
    reg rst;
    wire [15:0] AD1;
    wire [15:0] AD2;
    wire [15:0] BD1;
    wire [15:0] BD2;
    wire [15:0] CD1;
    wire [15:0] CD2;
    wire WT1;
    wire WT2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .as1(as1),
        .as2(as2),
        .bs1(bs1),
        .bs2(bs2),
        .cd1(cd1),
        .cd2(cd2),
        .clk(clk),
        .cs1(cs1),
        .cs2(cs2),
        .cw1(cw1),
        .cw2(cw2),
        .rst(rst),
        .AD1(AD1),
        .AD2(AD2),
        .BD1(BD1),
        .BD2(BD2),
        .CD1(CD1),
        .CD2(CD2),
        .WT1(WT1),
        .WT2(WT2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            as1 = 0; as2 = 0; bs1 = 0; bs2 = 0;
            cs1 = 0; cs2 = 0; cw1 = 0; cw2 = 0;
            cd1 = 0; cd2 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            as1 = 3'd1; bs1 = 3'd2; as2 = 3'd3; bs2 = 3'd4;
            cs1 = 3'd5; cs2 = 3'd6;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Port 1 Write/Read");
            reset_dut();

            cs1 = 3'd1; cw1 = 1; cd1 = 16'hAAAA;
            @(posedge clk);
            #1;
            cw1 = 0;
            as1 = 3'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hAAAA, 16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Port 2 Write/Read");
            reset_dut();

            cs2 = 3'd2; cw2 = 1; cd2 = 16'h5555;
            @(posedge clk);
            #1;
            cw2 = 0;
            as2 = 3'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0, 16'h5555, 16'h0, 16'h0, 16'h0, 16'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simultaneous Writes (Unique Addresses)");
            reset_dut();

            cs1 = 3'd3; cw1 = 1; cd1 = 16'h1111;
            cs2 = 3'd4; cw2 = 1; cd2 = 16'h2222;
            @(posedge clk);
            #1;
            cw1 = 0; cw2 = 0;
            as1 = 3'd3; bs1 = 3'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h1111, 16'h0, 16'h2222, 16'h0, 16'h0, 16'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write Conflict (Same Address)");
            reset_dut();

            cs1 = 3'd7; cw1 = 1; cd1 = 16'h1234;
            cs2 = 3'd7; cw2 = 1; cd2 = 16'h5678;
            @(posedge clk);
            #1;
            cw1 = 0; cw2 = 0;
            as1 = 3'd7;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h5678, 16'h0, 16'h0, 16'h0, 16'h0, 16'h5678, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: WT Flags and Address Mapping");
            reset_dut();

            cs1 = 3'd5; cw1 = 1; cd1 = 16'hBEEF;
            cs2 = 3'd6; cw2 = 1; cd2 = 16'hFEED;
            @(posedge clk);
            #1;

            cw1 = 1; cw2 = 1;
            as1 = 3'd5; as2 = 3'd6;
            bs1 = 3'd6; bs2 = 3'd5;
            cs1 = 3'd5; cs2 = 3'd6;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hBEEF, 16'hFEED, 16'hFEED, 16'hBEEF, 16'hBEEF, 16'hFEED, 1'b1, 1'b1);
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
        input [15:0] expected_AD1;
        input [15:0] expected_AD2;
        input [15:0] expected_BD1;
        input [15:0] expected_BD2;
        input [15:0] expected_CD1;
        input [15:0] expected_CD2;
        input expected_WT1;
        input expected_WT2;
        begin
            if (expected_AD1 === (expected_AD1 ^ AD1 ^ expected_AD1) &&
                expected_AD2 === (expected_AD2 ^ AD2 ^ expected_AD2) &&
                expected_BD1 === (expected_BD1 ^ BD1 ^ expected_BD1) &&
                expected_BD2 === (expected_BD2 ^ BD2 ^ expected_BD2) &&
                expected_CD1 === (expected_CD1 ^ CD1 ^ expected_CD1) &&
                expected_CD2 === (expected_CD2 ^ CD2 ^ expected_CD2) &&
                expected_WT1 === (expected_WT1 ^ WT1 ^ expected_WT1) &&
                expected_WT2 === (expected_WT2 ^ WT2 ^ expected_WT2)) begin
                $display("PASS");
                $display("  Outputs: AD1=%h, AD2=%h, BD1=%h, BD2=%h, CD1=%h, CD2=%h, WT1=%b, WT2=%b",
                         AD1, AD2, BD1, BD2, CD1, CD2, WT1, WT2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AD1=%h, AD2=%h, BD1=%h, BD2=%h, CD1=%h, CD2=%h, WT1=%b, WT2=%b",
                         expected_AD1, expected_AD2, expected_BD1, expected_BD2, expected_CD1, expected_CD2, expected_WT1, expected_WT2);
                $display("  Got:      AD1=%h, AD2=%h, BD1=%h, BD2=%h, CD1=%h, CD2=%h, WT1=%b, WT2=%b",
                         AD1, AD2, BD1, BD2, CD1, CD2, WT1, WT2);
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
        $dumpvars(0,as1, as2, bs1, bs2, cd1, cd2, clk, cs1, cs2, cw1, cw2, rst, AD1, AD2, BD1, BD2, CD1, CD2, WT1, WT2);
    end

endmodule
