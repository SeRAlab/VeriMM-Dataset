`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DPO;
    reg SPO;
    wire DPO_OUT;
    wire SPO_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DPO(DPO),
        .SPO(SPO),
        .DPO_OUT(DPO_OUT),
        .SPO_OUT(SPO_OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SPO=0, DPO=0", test_num);
            SPO = 0;
            DPO = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SPO=0, DPO=1", test_num);
            SPO = 0;
            DPO = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SPO=1, DPO=0", test_num);
            SPO = 1;
            DPO = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SPO=1, DPO=1", test_num);
            SPO = 1;
            DPO = 1;
            #1;

            check_outputs(1, 1);
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
        input expected_DPO_OUT;
        input expected_SPO_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DPO_OUT === (expected_DPO_OUT ^ DPO_OUT ^ expected_DPO_OUT) &&
                expected_SPO_OUT === (expected_SPO_OUT ^ SPO_OUT ^ expected_SPO_OUT)) begin
                $display("PASS");
                $display("  Outputs: DPO_OUT=%b, SPO_OUT=%b",
                         DPO_OUT, SPO_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DPO_OUT=%b, SPO_OUT=%b",
                         expected_DPO_OUT, expected_SPO_OUT);
                $display("  Got:      DPO_OUT=%b, SPO_OUT=%b",
                         DPO_OUT, SPO_OUT);
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
