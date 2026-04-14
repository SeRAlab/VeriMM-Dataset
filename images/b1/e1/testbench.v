`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg irqDetected;
    reg [7:0] irqNumber;
    wire [7:0] EIC_Interrupt;
    wire [16:0] EIC_Offset;
    wire [3:0] EIC_ShadowSet;
    wire [5:0] EIC_Vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .irqDetected(irqDetected),
        .irqNumber(irqNumber),
        .EIC_Interrupt(EIC_Interrupt),
        .EIC_Offset(EIC_Offset),
        .EIC_ShadowSet(EIC_ShadowSet),
        .EIC_Vector(EIC_Vector)
    );
    task testcase001;

    begin
        test_num = 1;
        irqDetected = 0;
        irqNumber = 8'hAA;

        #1;


        check_outputs(8'h00, 17'h0, 4'h0, 6'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        irqDetected = 1;
        irqNumber = 8'h00;


        #1;



        check_outputs(8'h01, 17'h0000, 4'h0, 6'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        irqDetected = 1;
        irqNumber = 8'h07;



        #1;




        check_outputs(8'h08, 17'h0070, 4'h0, 6'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        irqDetected = 1;
        irqNumber = 8'h7F;


        #1;



        check_outputs(8'h80, 17'h07F0, 4'h0, 6'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        irqDetected = 1;
        irqNumber = 8'hFF;


        #1;



        check_outputs(8'h00, 17'h0FF0, 4'h0, 6'h0);
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
        input [7:0] expected_EIC_Interrupt;
        input [16:0] expected_EIC_Offset;
        input [3:0] expected_EIC_ShadowSet;
        input [5:0] expected_EIC_Vector;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EIC_Interrupt === (expected_EIC_Interrupt ^ EIC_Interrupt ^ expected_EIC_Interrupt) &&
                expected_EIC_Offset === (expected_EIC_Offset ^ EIC_Offset ^ expected_EIC_Offset) &&
                expected_EIC_ShadowSet === (expected_EIC_ShadowSet ^ EIC_ShadowSet ^ expected_EIC_ShadowSet) &&
                expected_EIC_Vector === (expected_EIC_Vector ^ EIC_Vector ^ expected_EIC_Vector)) begin
                $display("PASS");
                $display("  Outputs: EIC_Interrupt=%h, EIC_Offset=%h, EIC_ShadowSet=%h, EIC_Vector=%h",
                         EIC_Interrupt, EIC_Offset, EIC_ShadowSet, EIC_Vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EIC_Interrupt=%h, EIC_Offset=%h, EIC_ShadowSet=%h, EIC_Vector=%h",
                         expected_EIC_Interrupt, expected_EIC_Offset, expected_EIC_ShadowSet, expected_EIC_Vector);
                $display("  Got:      EIC_Interrupt=%h, EIC_Offset=%h, EIC_ShadowSet=%h, EIC_Vector=%h",
                         EIC_Interrupt, EIC_Offset, EIC_ShadowSet, EIC_Vector);
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
