`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] haddr;
    reg [2:0] hburst;
    reg [3:0] hmaster;
    reg hmastlock;
    reg hready_ba;
    reg hsel;
    reg [2:0] hsize;
    reg [1:0] htrans;
    reg [31:0] hwdata;
    reg hwrite;
    wire [31:0] haddr_d;
    wire [2:0] hburst_d;
    wire [3:0] hmaster_d;
    wire hmastlock_d;
    wire hready_ba_d;
    wire hsel_d;
    wire [2:0] hsize_d;
    wire [1:0] htrans_d;
    wire [31:0] hwdata_d;
    wire hwrite_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .haddr(haddr),
        .hburst(hburst),
        .hmaster(hmaster),
        .hmastlock(hmastlock),
        .hready_ba(hready_ba),
        .hsel(hsel),
        .hsize(hsize),
        .htrans(htrans),
        .hwdata(hwdata),
        .hwrite(hwrite),
        .haddr_d(haddr_d),
        .hburst_d(hburst_d),
        .hmaster_d(hmaster_d),
        .hmastlock_d(hmastlock_d),
        .hready_ba_d(hready_ba_d),
        .hsel_d(hsel_d),
        .hsize_d(hsize_d),
        .htrans_d(htrans_d),
        .hwdata_d(hwdata_d),
        .hwrite_d(hwrite_d)
    );
    task testcase001;

        begin
            $display("Testcase 001: Standard AHB Write Transaction");
            test_num = 1;

            haddr     = 32'hC0DE_1234;
            hburst    = 3'b000;
            hmaster   = 4'h1;
            hmastlock = 1'b0;
            hready_ba = 1'b1;
            hsel      = 1'b1;
            hsize     = 3'b010;
            htrans    = 2'b10;
            hwdata    = 32'hABCD_5566;
            hwrite    = 1'b1;


            #1;



            check_outputs(32'hC0DE_1234, 3'b000, 4'h1, 1'b0, 1'b1, 1'b1, 3'b010, 2'b10, 32'hABCD_5566, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Zeros / Idle State");
            test_num = 2;
            haddr     = 32'h0;
            hburst    = 3'h0;
            hmaster   = 4'h0;
            hmastlock = 1'b0;
            hready_ba = 1'b0;
            hsel      = 1'b0;
            hsize     = 3'h0;
            htrans    = 2'h0;
            hwdata    = 32'h0;
            hwrite    = 1'b0;

            #1;


            check_outputs(32'h0, 3'h0, 4'h0, 1'b0, 1'b0, 1'b0, 3'h0, 2'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All Ones / Maximum Values");
            test_num = 3;
            haddr     = 32'hFFFF_FFFF;
            hburst    = 3'b111;
            hmaster   = 4'b1111;
            hmastlock = 1'b1;
            hready_ba = 1'b1;
            hsel      = 1'b1;
            hsize     = 3'b111;
            htrans    = 2'b11;
            hwdata    = 32'hFFFF_FFFF;
            hwrite    = 1'b1;

            #1;


            check_outputs(32'hFFFF_FFFF, 3'b111, 4'b1111, 1'b1, 1'b1, 1'b1, 3'b111, 2'b11, 32'hFFFF_FFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Standard AHB Read Transaction");
            test_num = 4;
            haddr     = 32'h4000_0000;
            hburst    = 3'b011;
            hmaster   = 4'h2;
            hmastlock = 1'b0;
            hready_ba = 1'b1;
            hsel      = 1'b1;
            hsize     = 3'b001;
            htrans    = 2'b11;
            hwdata    = 32'h0;
            hwrite    = 1'b0;

            #1;


            check_outputs(32'h4000_0000, 3'b011, 4'h2, 1'b0, 1'b1, 1'b1, 3'b001, 2'b11, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Alternating Bit Pattern");
            test_num = 5;
            haddr     = 32'hAAAA_AAAA;
            hburst    = 3'b101;
            hmaster   = 4'hA;
            hmastlock = 1'b1;
            hready_ba = 1'b0;
            hsel      = 1'b1;
            hsize     = 3'b101;
            htrans    = 2'b01;
            hwdata    = 32'h5555_5555;
            hwrite    = 1'b1;

            #1;


            check_outputs(32'hAAAA_AAAA, 3'b101, 4'hA, 1'b1, 1'b0, 1'b1, 3'b101, 2'b01, 32'h5555_5555, 1'b1);
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
        input [31:0] expected_haddr_d;
        input [2:0] expected_hburst_d;
        input [3:0] expected_hmaster_d;
        input expected_hmastlock_d;
        input expected_hready_ba_d;
        input expected_hsel_d;
        input [2:0] expected_hsize_d;
        input [1:0] expected_htrans_d;
        input [31:0] expected_hwdata_d;
        input expected_hwrite_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_haddr_d === (expected_haddr_d ^ haddr_d ^ expected_haddr_d) &&
                expected_hburst_d === (expected_hburst_d ^ hburst_d ^ expected_hburst_d) &&
                expected_hmaster_d === (expected_hmaster_d ^ hmaster_d ^ expected_hmaster_d) &&
                expected_hmastlock_d === (expected_hmastlock_d ^ hmastlock_d ^ expected_hmastlock_d) &&
                expected_hready_ba_d === (expected_hready_ba_d ^ hready_ba_d ^ expected_hready_ba_d) &&
                expected_hsel_d === (expected_hsel_d ^ hsel_d ^ expected_hsel_d) &&
                expected_hsize_d === (expected_hsize_d ^ hsize_d ^ expected_hsize_d) &&
                expected_htrans_d === (expected_htrans_d ^ htrans_d ^ expected_htrans_d) &&
                expected_hwdata_d === (expected_hwdata_d ^ hwdata_d ^ expected_hwdata_d) &&
                expected_hwrite_d === (expected_hwrite_d ^ hwrite_d ^ expected_hwrite_d)) begin
                $display("PASS");
                $display("  Outputs: haddr_d=%h, hburst_d=%h, hmaster_d=%h, hmastlock_d=%b, hready_ba_d=%b, hsel_d=%b, hsize_d=%h, htrans_d=%h, hwdata_d=%h, hwrite_d=%b",
                         haddr_d, hburst_d, hmaster_d, hmastlock_d, hready_ba_d, hsel_d, hsize_d, htrans_d, hwdata_d, hwrite_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: haddr_d=%h, hburst_d=%h, hmaster_d=%h, hmastlock_d=%b, hready_ba_d=%b, hsel_d=%b, hsize_d=%h, htrans_d=%h, hwdata_d=%h, hwrite_d=%b",
                         expected_haddr_d, expected_hburst_d, expected_hmaster_d, expected_hmastlock_d, expected_hready_ba_d, expected_hsel_d, expected_hsize_d, expected_htrans_d, expected_hwdata_d, expected_hwrite_d);
                $display("  Got:      haddr_d=%h, hburst_d=%h, hmaster_d=%h, hmastlock_d=%b, hready_ba_d=%b, hsel_d=%b, hsize_d=%h, htrans_d=%h, hwdata_d=%h, hwrite_d=%b",
                         haddr_d, hburst_d, hmaster_d, hmastlock_d, hready_ba_d, hsel_d, hsize_d, htrans_d, hwdata_d, hwrite_d);
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

endmodule
