`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] iALOUT;
    reg [7:0] iDTDOU;
    reg [7:0] iMULRG;
    reg [7:0] iSFRMX;
    reg [1:0] iSGPRI;
    wire [7:0] oGPRDI;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iALOUT(iALOUT),
        .iDTDOU(iDTDOU),
        .iMULRG(iMULRG),
        .iSFRMX(iSFRMX),
        .iSGPRI(iSGPRI),
        .oGPRDI(oGPRDI)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selecting iALOUT (iSGPRI = 00)", test_num);
            iALOUT = 8'hA5;
            iDTDOU = 8'h00;
            iMULRG = 8'h00;
            iSFRMX = 8'h00;
            iSGPRI = 2'b00;
            #10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selecting iDTDOU (iSGPRI = 01)", test_num);
            iALOUT = 8'h00;
            iDTDOU = 8'h5A;
            iMULRG = 8'h00;
            iSFRMX = 8'h00;
            iSGPRI = 2'b01;
            #10;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selecting iMULRG (iSGPRI = 10)", test_num);
            iALOUT = 8'h00;
            iDTDOU = 8'h00;
            iMULRG = 8'hFF;
            iSFRMX = 8'h00;
            iSGPRI = 2'b10;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selecting iSFRMX (iSGPRI = 11)", test_num);
            iALOUT = 8'h12;
            iDTDOU = 8'h34;
            iMULRG = 8'h56;
            iSFRMX = 8'h78;
            iSGPRI = 2'b11;
            #10;
            #1;

            check_outputs(8'h78);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs identical (8'hCC)", test_num);
            iALOUT = 8'hCC;
            iDTDOU = 8'hCC;
            iMULRG = 8'hCC;
            iSFRMX = 8'hCC;
            iSGPRI = 2'b01;
            #10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            iALOUT = 8'h00;
            iDTDOU = 8'h00;
            iMULRG = 8'h00;
            iSFRMX = 8'h00;
            iSGPRI = 2'b00;
            #10;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_oGPRDI;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oGPRDI === (expected_oGPRDI ^ oGPRDI ^ expected_oGPRDI)) begin
                $display("PASS");
                $display("  Outputs: oGPRDI=%h",
                         oGPRDI);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oGPRDI=%h",
                         expected_oGPRDI);
                $display("  Got:      oGPRDI=%h",
                         oGPRDI);
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
