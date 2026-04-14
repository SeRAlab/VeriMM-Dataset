`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] iC0;
    reg [31:0] iC1;
    reg [31:0] iC2;
    reg [31:0] iC3;
    reg [1:0] iS;
    wire [31:0] oZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iC0(iC0),
        .iC1(iC1),
        .iC2(iC2),
        .iC3(iC3),
        .iS(iS),
        .oZ(oZ)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select Channel 0 (iS=00)", test_num);
        iS = 2'b00;
        iC0 = 32'hAAAA_AAAA;
        iC1 = 32'hBBBB_BBBB;
        iC2 = 32'hCCCC_CCCC;
        iC3 = 32'hDDDD_DDDD;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select Channel 1 (iS=01)", test_num);
        iS = 2'b01;
        iC0 = 32'hAAAA_AAAA;
        iC1 = 32'hBBBB_BBBB;
        iC2 = 32'hCCCC_CCCC;
        iC3 = 32'hDDDD_DDDD;
        #1;

        check_outputs(32'hBBBB_BBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Channel 2 (iS=10)", test_num);
        iS = 2'b10;
        iC0 = 32'h1234_5678;
        iC1 = 32'h9ABC_DEF0;
        iC2 = 32'hFEED_BEEF;
        iC3 = 32'hDEAD_BABE;
        #1;

        check_outputs(32'hFEED_BEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select Channel 3 (iS=11)", test_num);
        iS = 2'b11;
        iC0 = 32'h1234_5678;
        iC1 = 32'h9ABC_DEF0;
        iC2 = 32'hFEED_BEEF;
        iC3 = 32'hDEAD_BABE;
        #1;

        check_outputs(32'hDEAD_BABE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All Zeros Selection", test_num);
        iS = 2'b10;
        iC0 = 32'hFFFF_FFFF;
        iC1 = 32'hFFFF_FFFF;
        iC2 = 32'h0000_0000;
        iC3 = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: All Ones Selection", test_num);
        iS = 2'b01;
        iC0 = 32'h0000_0000;
        iC1 = 32'hFFFF_FFFF;
        iC2 = 32'h0000_0000;
        iC3 = 32'h0000_0000;
        #1;

        check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_oZ;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oZ === (expected_oZ ^ oZ ^ expected_oZ)) begin
                $display("PASS");
                $display("  Outputs: oZ=%h",
                         oZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oZ=%h",
                         expected_oZ);
                $display("  Got:      oZ=%h",
                         oZ);
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
