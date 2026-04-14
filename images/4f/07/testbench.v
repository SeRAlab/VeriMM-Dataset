`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [1:0] select;
    wire [63:0] AOut;
    wire [63:0] BOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .select(select),
        .AOut(AOut),
        .BOut(BOut)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 64'h0000000000000000;
        B = 64'hFFFFFFFFFFFFFFFF;
        select = 2'b00;
        $display("Test %0d: No inversion (select=00)", test_num);
        #1;

        check_outputs(64'h0000000000000000, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 64'h0000000000000000;
        B = 64'hFFFFFFFFFFFFFFFF;
        select = 2'b01;
        $display("Test %0d: Invert A (select=01)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 64'h0000000000000000;
        B = 64'hFFFFFFFFFFFFFFFF;
        select = 2'b10;
        $display("Test %0d: Invert B (select=10)", test_num);
        #1;

        check_outputs(64'h0000000000000000, 64'h0000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 64'hAAAAAAAAAAAAAAAA;
        B = 64'h5555555555555555;
        select = 2'b11;
        $display("Test %0d: Invert Both (select=11)", test_num);
        #1;

        check_outputs(64'h5555555555555555, 64'hAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 64'h123456789ABCDEF0;
        B = 64'hFEDCBA9876543210;
        select = 2'b01;
        $display("Test %0d: Specific pattern A (select=01)", test_num);
        #1;

        check_outputs(~64'h123456789ABCDEF0, 64'hFEDCBA9876543210);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 64'hFFFF0000FFFF0000;
        B = 64'h0000FFFF0000FFFF;
        select = 2'b10;
        $display("Test %0d: Specific pattern B (select=10)", test_num);
        #1;

        check_outputs(64'hFFFF0000FFFF0000, ~64'h0000FFFF0000FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 64'hDEADC0DEBEEFBABE;
        B = 64'h0123456789ABCDEF;
        select = 2'b11;
        $display("Test %0d: Complex pattern (select=11)", test_num);
        #1;

        check_outputs(~64'hDEADC0DEBEEFBABE, ~64'h0123456789ABCDEF);
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
        testcase007();
        
        
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
        input [63:0] expected_AOut;
        input [63:0] expected_BOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AOut === (expected_AOut ^ AOut ^ expected_AOut) &&
                expected_BOut === (expected_BOut ^ BOut ^ expected_BOut)) begin
                $display("PASS");
                $display("  Outputs: AOut=%h, BOut=%h",
                         AOut, BOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AOut=%h, BOut=%h",
                         expected_AOut, expected_BOut);
                $display("  Got:      AOut=%h, BOut=%h",
                         AOut, BOut);
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
