`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg CI;
    wire CO;
    wire SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CI(CI),
        .CO(CO),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Simple addition (5 + 3, CI=0)", test_num);
        A = 4'b0101; B = 4'b0011; CI = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Addition with CI (2 + 2 + 1)", test_num);
        A = 4'b0010; B = 4'b0010; CI = 1'b1;
        #1;

        check_outputs(1'b0, 4'b0101);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Carry-out generation (10 + 10)", test_num);
        A = 4'b1010; B = 4'b1010; CI = 1'b0;
        #1;

        check_outputs(1'b1, 4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Max values (15 + 15 + 1)", test_num);
        A = 4'b1111; B = 4'b1111; CI = 1'b1;
        #1;

        check_outputs(1'b1, 4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Adding zeros", test_num);
        A = 4'b0000; B = 4'b0000; CI = 1'b0;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Ripple carry bit propagation (15 + 0 + 1)", test_num);
        A = 4'b1111; B = 4'b0000; CI = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0000);
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
        input expected_CO;
        input expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, SUM=%b",
                         CO, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, SUM=%b",
                         expected_CO, expected_SUM);
                $display("  Got:      CO=%b, SUM=%b",
                         CO, SUM);
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
