`timescale 1ns/1ps

module simple_module_tb;

    // Testbench signals (combinational circuit)
    reg k;
    reg l;
    wire m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_module dut (
        .k(k),
        .l(l),
        .m(m)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: k=1, l=0", test_num);
        k = 1;
        l = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: k=0, l=1", test_num);
        k = 0;
        l = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: k=1, l=1", test_num);
        k = 1;
        l = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: k=0, l=0", test_num);
        k = 0;
        l = 0;
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_module Testbench");
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
        input expected_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: m=%b",
                         m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%b",
                         expected_m);
                $display("  Got:      m=%b",
                         m);
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
