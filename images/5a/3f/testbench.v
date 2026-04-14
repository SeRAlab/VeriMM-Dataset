`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire D1;
    wire D2;
    wire D3;
    wire D4;
    wire D5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking initial state of outputs", test_num);


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking stability of outputs over time", test_num);

            #50;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Final persistence check", test_num);

            #500;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_D1;
        input expected_D2;
        input expected_D3;
        input expected_D4;
        input expected_D5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_D3 === (expected_D3 ^ D3 ^ expected_D3) &&
                expected_D4 === (expected_D4 ^ D4 ^ expected_D4) &&
                expected_D5 === (expected_D5 ^ D5 ^ expected_D5)) begin
                $display("PASS");
                $display("  Outputs: D1=%b, D2=%b, D3=%b, D4=%b, D5=%b",
                         D1, D2, D3, D4, D5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%b, D2=%b, D3=%b, D4=%b, D5=%b",
                         expected_D1, expected_D2, expected_D3, expected_D4, expected_D5);
                $display("  Got:      D1=%b, D2=%b, D3=%b, D4=%b, D5=%b",
                         D1, D2, D3, D4, D5);
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
