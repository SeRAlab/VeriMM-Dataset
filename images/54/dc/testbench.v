`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg h;
    reg [3:0] z;
    wire Z1;
    wire Z3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .z(z),
        .Z1(Z1),
        .Z3(Z3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: State U (z=0001), h=1 -> Should transition to V (Z1=1)", test_num);
        z = 4'b0001;
        h = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State U (z=0001), h=0 -> Should transition to W (Z1=0, Z3=0)", test_num);
        z = 4'b0001;
        h = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State V (z=0010), h=1 -> Should transition to X (Z3=1)", test_num);
        z = 4'b0010;
        h = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State V (z=0010), h=0 -> Should transition to U (Z1=0, Z3=0)", test_num);
        z = 4'b0010;
        h = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State W (z=0100), h=1 -> Should transition to X (Z3=1)", test_num);
        z = 4'b0100;
        h = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State W (z=0100), h=0 -> Should transition to U (Z1=0, Z3=0)", test_num);
        z = 4'b0100;
        h = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: State X (z=1000), h=1 -> Should transition to V (Z1=1)", test_num);
        z = 4'b1000;
        h = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: State X (z=1000), h=0 -> Should transition to U (Z1=0, Z3=0)", test_num);
        z = 4'b1000;
        h = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Inactive State (z=0000), h=1 -> Outputs should be 0", test_num);
        z = 4'b0000;
        h = 1;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_Z1;
        input expected_Z3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z1 === (expected_Z1 ^ Z1 ^ expected_Z1) &&
                expected_Z3 === (expected_Z3 ^ Z3 ^ expected_Z3)) begin
                $display("PASS");
                $display("  Outputs: Z1=%b, Z3=%b",
                         Z1, Z3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z1=%b, Z3=%b",
                         expected_Z1, expected_Z3);
                $display("  Got:      Z1=%b, Z3=%b",
                         Z1, Z3);
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
