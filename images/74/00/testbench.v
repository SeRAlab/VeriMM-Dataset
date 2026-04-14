`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg P11;
    reg P12;
    reg P14;
    reg P2;
    reg P3;
    reg P5;
    reg P6;
    reg P7;
    reg P8;
    reg P9;
    wire P1;
    wire P10;
    wire P13;
    wire P4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .P11(P11),
        .P12(P12),
        .P14(P14),
        .P2(P2),
        .P3(P3),
        .P5(P5),
        .P6(P6),
        .P7(P7),
        .P8(P8),
        .P9(P9),
        .P1(P1),
        .P10(P10),
        .P13(P13),
        .P4(P4)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Override Condition Active (P14=1, P7=0) - Inputs logic low", test_num);

        P14 = 1'b1;
        P7 = 1'b0;

        P2 = 1'b0; P3 = 1'b0;
        P5 = 1'b0; P6 = 1'b0;
        P8 = 1'b0; P9 = 1'b0;
        P11 = 1'b0; P12 = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Override Condition Active (P14=1, P7=0) - Inputs logic high", test_num);
        P14 = 1'b1;
        P7 = 1'b0;

        P2 = 1'b1; P3 = 1'b1;
        P5 = 1'b1; P6 = 1'b1;
        P8 = 1'b1; P9 = 1'b1;
        P11 = 1'b1; P12 = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Normal Mode (P14=0, P7=0) - All inputs 0", test_num);
        P14 = 1'b0;
        P7 = 1'b0;

        P2 = 1'b0; P3 = 1'b0;
        P5 = 1'b0; P6 = 1'b0;
        P8 = 1'b0; P9 = 1'b0;
        P11 = 1'b0; P12 = 1'b0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Normal Mode (P14=1, P7=1) - All inputs 1", test_num);
        P14 = 1'b1;
        P7 = 1'b1;

        P2 = 1'b1; P3 = 1'b1;
        P5 = 1'b1; P6 = 1'b1;
        P8 = 1'b1; P9 = 1'b1;
        P11 = 1'b1; P12 = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Normal Mode (P14=0, P7=1) - Mixed Logic Levels", test_num);
        P14 = 1'b0;
        P7 = 1'b1;


        P2 = 1'b1; P3 = 1'b1;

        P5 = 1'b0; P6 = 1'b1;

        P8 = 1'b1; P9 = 1'b0;

        P11 = 1'b0; P12 = 1'b0;


        #1;



        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Edge Case - Normal Mode (P14=0, P7=0) - Alternating Inputs", test_num);
        P14 = 1'b0;
        P7 = 1'b0;


        P2 = 1'b0; P3 = 1'b1;

        P5 = 1'b1; P6 = 1'b1;

        P8 = 1'b1; P9 = 1'b1;

        P11 = 1'b1; P12 = 1'b0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
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
        input expected_P1;
        input expected_P10;
        input expected_P13;
        input expected_P4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P1 === (expected_P1 ^ P1 ^ expected_P1) &&
                expected_P10 === (expected_P10 ^ P10 ^ expected_P10) &&
                expected_P13 === (expected_P13 ^ P13 ^ expected_P13) &&
                expected_P4 === (expected_P4 ^ P4 ^ expected_P4)) begin
                $display("PASS");
                $display("  Outputs: P1=%b, P10=%b, P13=%b, P4=%b",
                         P1, P10, P13, P4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P1=%b, P10=%b, P13=%b, P4=%b",
                         expected_P1, expected_P10, expected_P13, expected_P4);
                $display("  Got:      P1=%b, P10=%b, P13=%b, P4=%b",
                         P1, P10, P13, P4);
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
