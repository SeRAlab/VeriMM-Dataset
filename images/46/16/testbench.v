`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg B2;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire VOUT;
    wire VREF;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .VOUT(VOUT),
        .VREF(VREF),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A1 = 0; A2 = 0; B1 = 0; B2 = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            $display("Running Testcase001: Inputs for Y=0 (Even, <2)");

            #1;


            check_outputs(1, 1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A1 = 0; A2 = 1; B1 = 0; B2 = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            $display("Running Testcase002: Inputs for Y=1 (Odd, <2)");
            #1;

            check_outputs(0, 1, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A1 = 1; A2 = 0; B1 = 0; B2 = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            $display("Running Testcase003: Inputs for Y=2 (Even, >=2)");
            #1;

            check_outputs(1, 0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A1 = 1; A2 = 1; B1 = 0; B2 = 0;
            VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            $display("Running Testcase004: Inputs for Y=3 (Odd, >=2)");
            #1;

            check_outputs(0, 0, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A1 = 0; A2 = 1; B1 = 0; B2 = 0;
            VPWR = 0; VGND = 1; VPB = 0; VNB = 1;
            $display("Running Testcase005: Inverted Rails Verification (Y=1)");
            #1;

            check_outputs(1, 0, 2'b01);
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
        input expected_VOUT;
        input expected_VREF;
        input [1:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VOUT === (expected_VOUT ^ VOUT ^ expected_VOUT) &&
                expected_VREF === (expected_VREF ^ VREF ^ expected_VREF) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: VOUT=%b, VREF=%b, Y=%h",
                         VOUT, VREF, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VOUT=%b, VREF=%b, Y=%h",
                         expected_VOUT, expected_VREF, expected_Y);
                $display("  Got:      VOUT=%b, VREF=%b, Y=%h",
                         VOUT, VREF, Y);
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
