`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg AS_L;
    reg CanBusDtack_L;
    reg CanBusSelect_H;
    reg DramDtack_L;
    reg DramSelect_H;
    wire DtackOut_L;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AS_L(AS_L),
        .CanBusDtack_L(CanBusDtack_L),
        .CanBusSelect_H(CanBusSelect_H),
        .DramDtack_L(DramDtack_L),
        .DramSelect_H(DramSelect_H),
        .DtackOut_L(DtackOut_L)
    );
    task testcase001;

    begin
        test_num = 1;
        AS_L = 1'b1;
        DramSelect_H = 1'b0;
        CanBusSelect_H = 1'b0;
        DramDtack_L = 1'b1;
        CanBusDtack_L = 1'b1;
        $display("Test case 001: AS_L high (Inactive state)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        AS_L = 1'b0;
        DramSelect_H = 1'b1;
        CanBusSelect_H = 1'b0;
        DramDtack_L = 1'b0;
        CanBusDtack_L = 1'b1;
        $display("Test case 002: AS_L low, DramSelect active, DramDtack low (Ack)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        AS_L = 1'b0;
        DramSelect_H = 1'b1;
        CanBusSelect_H = 1'b0;
        DramDtack_L = 1'b1;
        CanBusDtack_L = 1'b0;
        $display("Test case 003: AS_L low, DramSelect active, DramDtack high (No Ack)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        AS_L = 1'b0;
        DramSelect_H = 1'b0;
        CanBusSelect_H = 1'b1;
        DramDtack_L = 1'b1;
        CanBusDtack_L = 1'b0;
        $display("Test case 004: AS_L low, CanBusSelect active, CanBusDtack low (Ack)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        AS_L = 1'b0;
        DramSelect_H = 1'b0;
        CanBusSelect_H = 1'b1;
        DramDtack_L = 1'b0;
        CanBusDtack_L = 1'b1;
        $display("Test case 005: AS_L low, CanBusSelect active, CanBusDtack high (No Ack)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        AS_L = 1'b0;
        DramSelect_H = 1'b0;
        CanBusSelect_H = 1'b0;
        DramDtack_L = 1'b1;
        CanBusDtack_L = 1'b1;
        $display("Test case 006: AS_L low, no selection (defaults to low)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        AS_L = 1'b1;
        DramSelect_H = 1'b1;
        CanBusSelect_H = 1'b1;
        DramDtack_L = 1'b0;
        CanBusDtack_L = 1'b0;
        $display("Test case 007: AS_L high overrides active selections");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        AS_L = 1'b0;
        DramSelect_H = 1'b1;
        CanBusSelect_H = 1'b1;
        DramDtack_L = 1'b0;
        CanBusDtack_L = 1'b1;
        $display("Test case 008: Priority check - both selected, DRAM Ack 0");
        #1;

        check_outputs(1'b0);
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
        input expected_DtackOut_L;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DtackOut_L === (expected_DtackOut_L ^ DtackOut_L ^ expected_DtackOut_L)) begin
                $display("PASS");
                $display("  Outputs: DtackOut_L=%b",
                         DtackOut_L);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DtackOut_L=%b",
                         expected_DtackOut_L);
                $display("  Got:      DtackOut_L=%b",
                         DtackOut_L);
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
