`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg In0;
    reg In1;
    wire CapOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In0(In0),
        .In1(In1),
        .CapOut(CapOut)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: In1=0, In0=0", test_num);
        In1 = 1'b0;
        In0 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: In1=0, In0=1", test_num);
        In1 = 1'b0;
        In0 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: In1=1, In0=0", test_num);
        In1 = 1'b1;
        In0 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: In1=1, In0=1", test_num);
        In1 = 1'b1;
        In0 = 1'b1;
        #1;

        check_outputs(1'b1);
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
        input expected_CapOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CapOut === (expected_CapOut ^ CapOut ^ expected_CapOut)) begin
                $display("PASS");
                $display("  Outputs: CapOut=%b",
                         CapOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CapOut=%b",
                         expected_CapOut);
                $display("  Got:      CapOut=%b",
                         CapOut);
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
