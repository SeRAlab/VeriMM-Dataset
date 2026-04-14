`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] iht_s00_i;
    reg [14:0] iht_s01_i;
    reg [14:0] iht_s10_i;
    reg [14:0] iht_s11_i;
    wire [14:0] iht_d00_o;
    wire [14:0] iht_d01_o;
    wire [14:0] iht_d10_o;
    wire [14:0] iht_d11_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iht_s00_i(iht_s00_i),
        .iht_s01_i(iht_s01_i),
        .iht_s10_i(iht_s10_i),
        .iht_s11_i(iht_s11_i),
        .iht_d00_o(iht_d00_o),
        .iht_d01_o(iht_d01_o),
        .iht_d10_o(iht_d10_o),
        .iht_d11_o(iht_d11_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        iht_s00_i = 15'h0000;
        iht_s01_i = 15'h0000;
        iht_s10_i = 15'h0000;
        iht_s11_i = 15'h0000;
        #1;

        check_outputs(15'h0000, 15'h0000, 15'h0000, 15'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit Impulse S00", test_num);
        iht_s00_i = 15'h0001;
        iht_s01_i = 15'h0000;
        iht_s10_i = 15'h0000;
        iht_s11_i = 15'h0000;
        #1;

        check_outputs(15'h0001, 15'h0001, 15'h0001, 15'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit Impulse S11", test_num);
        iht_s00_i = 15'h0000;
        iht_s01_i = 15'h0000;
        iht_s10_i = 15'h0000;
        iht_s11_i = 15'h0001;
        #1;

        check_outputs(15'h0001, 15'h7FFF, 15'h7FFF, 15'h0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive Integers", test_num);
        iht_s00_i = 15'd10;
        iht_s01_i = 15'd5;
        iht_s10_i = 15'd8;
        iht_s11_i = 15'd3;
        #1;

        check_outputs(15'h001A, 15'h000A, 15'h0004, 15'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Wrap Around Check", test_num);
        iht_s00_i = 15'h4000;
        iht_s01_i = 15'h4000;
        iht_s10_i = 15'h4000;
        iht_s11_i = 15'h4000;
        #1;

        check_outputs(15'h0000, 15'h0000, 15'h0000, 15'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Linear Gradient", test_num);
        iht_s00_i = 15'd100;
        iht_s01_i = 15'd200;
        iht_s10_i = 15'd300;
        iht_s11_i = 15'd400;
        #1;

        check_outputs(15'h03E8, 15'h7F38, 15'h7E70, 15'h0000);
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
        input [14:0] expected_iht_d00_o;
        input [14:0] expected_iht_d01_o;
        input [14:0] expected_iht_d10_o;
        input [14:0] expected_iht_d11_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_iht_d00_o === (expected_iht_d00_o ^ iht_d00_o ^ expected_iht_d00_o) &&
                expected_iht_d01_o === (expected_iht_d01_o ^ iht_d01_o ^ expected_iht_d01_o) &&
                expected_iht_d10_o === (expected_iht_d10_o ^ iht_d10_o ^ expected_iht_d10_o) &&
                expected_iht_d11_o === (expected_iht_d11_o ^ iht_d11_o ^ expected_iht_d11_o)) begin
                $display("PASS");
                $display("  Outputs: iht_d00_o=%h, iht_d01_o=%h, iht_d10_o=%h, iht_d11_o=%h",
                         iht_d00_o, iht_d01_o, iht_d10_o, iht_d11_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: iht_d00_o=%h, iht_d01_o=%h, iht_d10_o=%h, iht_d11_o=%h",
                         expected_iht_d00_o, expected_iht_d01_o, expected_iht_d10_o, expected_iht_d11_o);
                $display("  Got:      iht_d00_o=%h, iht_d01_o=%h, iht_d10_o=%h, iht_d11_o=%h",
                         iht_d00_o, iht_d01_o, iht_d10_o, iht_d11_o);
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
