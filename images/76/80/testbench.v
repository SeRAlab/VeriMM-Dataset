`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] iMop;
    wire [8:0] oUopFlowIdx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iMop(iMop),
        .oUopFlowIdx(oUopFlowIdx)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: iMop = 8'h00", test_num);
        iMop = 8'h00;

        #1;


        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: iMop = 8'h01", test_num);
        iMop = 8'h01;

        #1;


        check_outputs(oUopFlowIdx);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: iMop = 8'h0F", test_num);
        iMop = 8'h0F;
        #1;

        check_outputs(oUopFlowIdx);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: iMop = 8'h10", test_num);
        iMop = 8'h10;
        #1;

        check_outputs(oUopFlowIdx);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: iMop = 8'h55", test_num);
        iMop = 8'h55;
        #1;

        check_outputs(oUopFlowIdx);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: iMop = 8'hAA", test_num);
        iMop = 8'hAA;
        #1;

        check_outputs(oUopFlowIdx);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase %0d: iMop = 8'h80", test_num);
        iMop = 8'h80;
        #1;

        check_outputs(oUopFlowIdx);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running Testcase %0d: iMop = 8'hF0", test_num);
        iMop = 8'hF0;
        #1;

        check_outputs(oUopFlowIdx);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Running Testcase %0d: iMop = 8'hFE", test_num);
        iMop = 8'hFE;
        #1;

        check_outputs(oUopFlowIdx);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Running Testcase %0d: iMop = 8'hFF", test_num);
        iMop = 8'hFF;
        #1;

        check_outputs(oUopFlowIdx);
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
        testcase009();
        testcase010();
        
        
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
        input [8:0] expected_oUopFlowIdx;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oUopFlowIdx === (expected_oUopFlowIdx ^ oUopFlowIdx ^ expected_oUopFlowIdx)) begin
                $display("PASS");
                $display("  Outputs: oUopFlowIdx=%h",
                         oUopFlowIdx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oUopFlowIdx=%h",
                         expected_oUopFlowIdx);
                $display("  Got:      oUopFlowIdx=%h",
                         oUopFlowIdx);
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
