`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] i;
    wire an1;
    wire an2;
    wire an3;
    wire an4;
    wire o1;
    wire o2;
    wire o3;
    wire o4;
    wire o5;
    wire o6;
    wire o7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .an1(an1),
        .an2(an2),
        .an3(an3),
        .an4(an4),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4),
        .o5(o5),
        .o6(o6),
        .o7(o7)
    );
    task testcase000;

        begin
            test_num = test_num + 1;
            i = 3'b000;
            $display("Test Case %0d: Input i = 000", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            i = 3'b001;
            $display("Test Case %0d: Input i = 001", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            i = 3'b010;
            $display("Test Case %0d: Input i = 010", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            i = 3'b011;
            $display("Test Case %0d: Input i = 011", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            i = 3'b100;
            $display("Test Case %0d: Input i = 100", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            i = 3'b101;
            $display("Test Case %0d: Input i = 101", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            i = 3'b110;
            $display("Test Case %0d: Input i = 110", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            i = 3'b111;
            $display("Test Case %0d: Input i = 111", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1);
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


        testcase000();
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
        input expected_an1;
        input expected_an2;
        input expected_an3;
        input expected_an4;
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input expected_o4;
        input expected_o5;
        input expected_o6;
        input expected_o7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_an1 === (expected_an1 ^ an1 ^ expected_an1) &&
                expected_an2 === (expected_an2 ^ an2 ^ expected_an2) &&
                expected_an3 === (expected_an3 ^ an3 ^ expected_an3) &&
                expected_an4 === (expected_an4 ^ an4 ^ expected_an4) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4) &&
                expected_o5 === (expected_o5 ^ o5 ^ expected_o5) &&
                expected_o6 === (expected_o6 ^ o6 ^ expected_o6) &&
                expected_o7 === (expected_o7 ^ o7 ^ expected_o7)) begin
                $display("PASS");
                $display("  Outputs: an1=%b, an2=%b, an3=%b, an4=%b, o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b",
                         an1, an2, an3, an4, o1, o2, o3, o4, o5, o6, o7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an1=%b, an2=%b, an3=%b, an4=%b, o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b",
                         expected_an1, expected_an2, expected_an3, expected_an4, expected_o1, expected_o2, expected_o3, expected_o4, expected_o5, expected_o6, expected_o7);
                $display("  Got:      an1=%b, an2=%b, an3=%b, an4=%b, o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b",
                         an1, an2, an3, an4, o1, o2, o3, o4, o5, o6, o7);
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
