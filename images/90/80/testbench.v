`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    wire VGND;
    wire VNB;
    wire VPB;
    wire VPWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Initial power-up check");

        clk = 0;
        #10;

        clk = 1;
        #10;
        clk = 0;
        #10;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Persistence check over multiple clock cycles");

        repeat(20) begin
            clk = 1;
            #5;
            clk = 0;
            #5;
        end

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Long duration stability check");

        #500;
        clk = 1;
        #5;
        clk = 0;
        #5;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Rapid clocking check");

        repeat(50) begin
            clk = !clk;
            #1;
        end
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_VGND;
        input expected_VNB;
        input expected_VPB;
        input expected_VPWR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VGND === (expected_VGND ^ VGND ^ expected_VGND) &&
                expected_VNB === (expected_VNB ^ VNB ^ expected_VNB) &&
                expected_VPB === (expected_VPB ^ VPB ^ expected_VPB) &&
                expected_VPWR === (expected_VPWR ^ VPWR ^ expected_VPWR)) begin
                $display("PASS");
                $display("  Outputs: VGND=%b, VNB=%b, VPB=%b, VPWR=%b",
                         VGND, VNB, VPB, VPWR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGND=%b, VNB=%b, VPB=%b, VPWR=%b",
                         expected_VGND, expected_VNB, expected_VPB, expected_VPWR);
                $display("  Got:      VGND=%b, VNB=%b, VPB=%b, VPWR=%b",
                         VGND, VNB, VPB, VPWR);
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
