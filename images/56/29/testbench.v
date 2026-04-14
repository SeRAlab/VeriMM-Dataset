`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a1;
    reg a2;
    reg a3;
    reg b1;
    reg b2;
    reg b3;
    reg c1;
    reg c2;
    reg c3;
    wire out1;
    wire out2;
    wire out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs LOW", test_num);
            a1 = 0; b1 = 0; c1 = 0;
            a2 = 0; b2 = 0; c2 = 0;
            a3 = 0; b3 = 0; c3 = 0;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs HIGH", test_num);
            a1 = 1; b1 = 1; c1 = 1;
            a2 = 1; b2 = 1; c2 = 1;
            a3 = 1; b3 = 1; c3 = 1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed inputs (Only 2/3 high per gate)", test_num);

            a1 = 1; b1 = 1; c1 = 0;

            a2 = 1; b2 = 0; c2 = 1;

            a3 = 0; b3 = 1; c3 = 1;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single 0 input per gate", test_num);

            a1 = 0; b1 = 1; c1 = 1;

            a2 = 1; b2 = 0; c2 = 1;

            a3 = 1; b3 = 1; c3 = 0;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle individual gates to LOW", test_num);

            a1 = 1; b1 = 1; c1 = 1;
            a2 = 0; b2 = 1; c2 = 1;
            a3 = 1; b3 = 0; c3 = 1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Gate 2 to LOW", test_num);
            a1 = 0; b1 = 0; c1 = 0;
            a2 = 1; b2 = 1; c2 = 1;
            a3 = 0; b3 = 1; c3 = 0;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Gate 3 to LOW", test_num);
            a1 = 1; b1 = 0; c1 = 0;
            a2 = 0; b2 = 0; c2 = 1;
            a3 = 1; b3 = 1; c3 = 1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Mix", test_num);
            a1 = 1; b1 = 1; c1 = 1;
            a2 = 1; b2 = 1; c2 = 1;
            a3 = 0; b3 = 0; c3 = 0;
            #1;

            check_outputs(0, 0, 1);
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
        input expected_out1;
        input expected_out2;
        input expected_out3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out1=%b, out2=%b, out3=%b",
                         out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b, out2=%b, out3=%b",
                         expected_out1, expected_out2, expected_out3);
                $display("  Got:      out1=%b, out2=%b, out3=%b",
                         out1, out2, out3);
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
