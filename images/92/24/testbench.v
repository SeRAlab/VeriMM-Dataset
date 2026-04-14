`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] iGPI;
    reg [7:0] iGPO;
    reg [3:0] iSSFRR;
    wire [7:0] oSFRMX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iGPI(iGPI),
        .iGPO(iGPO),
        .iSSFRR(iSSFRR),
        .oSFRMX(oSFRMX)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select iGPI using iSSFRR = 0", test_num);
        iGPI = 8'hAA;
        iGPO = 8'h55;
        iSSFRR = 4'd0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select iGPO using iSSFRR = 1", test_num);
        iGPI = 8'hAA;
        iGPO = 8'h55;
        iSSFRR = 4'd1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify iGPO changes do not affect output when iGPI is selected", test_num);
        iGPI = 8'h12;
        iGPO = 8'h00;
        iSSFRR = 4'd0;
        #5;
        iGPO = 8'hFF;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify iGPI changes do not affect output when iGPO is selected", test_num);
        iGPI = 8'h00;
        iGPO = 8'h34;
        iSSFRR = 4'd1;
        #5;
        iGPI = 8'hFF;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Test all-ones and all-zeros for iGPI", test_num);
        iGPI = 8'hFF;
        iGPO = 8'h00;
        iSSFRR = 4'd0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Test all-ones and all-zeros for iGPO", test_num);
        iGPI = 8'h00;
        iGPO = 8'hFF;
        iSSFRR = 4'd1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Test selection value 2 (potential undefined port/null)", test_num);
        iGPI = 8'h12;
        iGPO = 8'h34;
        iSSFRR = 4'd2;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Test selection value 7 (max index of 8-to-1)", test_num);
        iGPI = 8'h12;
        iGPO = 8'h34;
        iSSFRR = 4'd7;
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
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_oSFRMX;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oSFRMX === (expected_oSFRMX ^ oSFRMX ^ expected_oSFRMX)) begin
                $display("PASS");
                $display("  Outputs: oSFRMX=%h",
                         oSFRMX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oSFRMX=%h",
                         expected_oSFRMX);
                $display("  Got:      oSFRMX=%h",
                         oSFRMX);
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
