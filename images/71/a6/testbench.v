`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [35:0] tw;
    wire [35:0] tr_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .tw(tw),
        .tr_data(tr_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Input all zeros", test_num);
        tw = 36'h000000000;
        #1;

        check_outputs(36'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Input all ones", test_num);
        tw = 36'hFFFFFFFFF;
        #1;

        check_outputs(36'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Input alternating bits (A)", test_num);
        tw = 36'hAAAAAAAAA;
        #1;

        check_outputs(36'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Input alternating bits (5)", test_num);
        tw = 36'h555555555;
        #1;

        check_outputs(36'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Random pattern 1", test_num);
        tw = 36'h123456789;
        #1;

        check_outputs(36'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Random pattern 2", test_num);
        tw = 36'h987654321;
        #1;

        check_outputs(36'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Walking bit pattern", test_num);
        tw = 36'h000000001;
        #1;
        tw = 36'h000000002;
        #1;
        tw = 36'h000000004;
        #1;
        tw = 36'h800000000;
        #1;

        check_outputs(36'h0);
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
        input [35:0] expected_tr_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tr_data === (expected_tr_data ^ tr_data ^ expected_tr_data)) begin
                $display("PASS");
                $display("  Outputs: tr_data=%h",
                         tr_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tr_data=%h",
                         expected_tr_data);
                $display("  Got:      tr_data=%h",
                         tr_data);
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
