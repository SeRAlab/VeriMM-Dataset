`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a0;
    reg a1;
    reg a2;
    reg a3;
    reg b0;
    reg b1;
    reg b2;
    reg b3;
    wire z0;
    wire z1;
    wire z2;
    wire z3;
    wire z4;
    wire z5;
    wire z6;
    wire z7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .z0(z0),
        .z1(z1),
        .z2(z2),
        .z3(z3),
        .z4(z4),
        .z5(z5),
        .z6(z6),
        .z7(z7)
    );
    task testcase001;

        begin
            test_num = 1;

            {a3, a2, a1, a0} = 4'd0;
            {b3, b2, b1, b0} = 4'd0;
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            {a3, a2, a1, a0} = 4'd15;
            {b3, b2, b1, b0} = 4'd15;
            #1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            {a3, a2, a1, a0} = 4'd1;
            {b3, b2, b1, b0} = 4'd1;
            #1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            {a3, a2, a1, a0} = 4'd5;
            {b3, b2, b1, b0} = 4'd3;
            #1;
            #1;

            check_outputs(1, 1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            {a3, a2, a1, a0} = 4'd10;
            {b3, b2, b1, b0} = 4'd10;
            #1;
            #1;

            check_outputs(0, 0, 1, 0, 0, 1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            {a3, a2, a1, a0} = 4'd7;
            {b3, b2, b1, b0} = 4'd9;
            #1;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            {a3, a2, a1, a0} = 4'd15;
            {b3, b2, b1, b0} = 4'd1;
            #1;
            #1;

            check_outputs(1, 1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;

            {a3, a2, a1, a0} = 4'd14;
            {b3, b2, b1, b0} = 4'd4;
            #1;
            #1;

            check_outputs(0, 0, 0, 1, 1, 1, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            {a3, a2, a1, a0} = 4'd11;
            {b3, b2, b1, b0} = 4'd6;
            #1;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            {a3, a2, a1, a0} = 4'd2;
            {b3, b2, b1, b0} = 4'd0;
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
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
        input expected_z0;
        input expected_z1;
        input expected_z2;
        input expected_z3;
        input expected_z4;
        input expected_z5;
        input expected_z6;
        input expected_z7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z0 === (expected_z0 ^ z0 ^ expected_z0) &&
                expected_z1 === (expected_z1 ^ z1 ^ expected_z1) &&
                expected_z2 === (expected_z2 ^ z2 ^ expected_z2) &&
                expected_z3 === (expected_z3 ^ z3 ^ expected_z3) &&
                expected_z4 === (expected_z4 ^ z4 ^ expected_z4) &&
                expected_z5 === (expected_z5 ^ z5 ^ expected_z5) &&
                expected_z6 === (expected_z6 ^ z6 ^ expected_z6) &&
                expected_z7 === (expected_z7 ^ z7 ^ expected_z7)) begin
                $display("PASS");
                $display("  Outputs: z0=%b, z1=%b, z2=%b, z3=%b, z4=%b, z5=%b, z6=%b, z7=%b",
                         z0, z1, z2, z3, z4, z5, z6, z7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z0=%b, z1=%b, z2=%b, z3=%b, z4=%b, z5=%b, z6=%b, z7=%b",
                         expected_z0, expected_z1, expected_z2, expected_z3, expected_z4, expected_z5, expected_z6, expected_z7);
                $display("  Got:      z0=%b, z1=%b, z2=%b, z3=%b, z4=%b, z5=%b, z6=%b, z7=%b",
                         z0, z1, z2, z3, z4, z5, z6, z7);
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
