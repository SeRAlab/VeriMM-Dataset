`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg pin1;
    reg pin11;
    reg pin13;
    reg pin3;
    reg pin5;
    reg pin9;
    wire pin10;
    wire pin12;
    wire pin2;
    wire pin4;
    wire pin6;
    wire pin8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pin1(pin1),
        .pin11(pin11),
        .pin13(pin13),
        .pin3(pin3),
        .pin5(pin5),
        .pin9(pin9),
        .pin10(pin10),
        .pin12(pin12),
        .pin2(pin2),
        .pin4(pin4),
        .pin6(pin6),
        .pin8(pin8)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs LOW (0)", test_num);

            pin1 = 0; pin3 = 0; pin5 = 0; pin9 = 0; pin11 = 0; pin13 = 0;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs HIGH (1)", test_num);
            pin1 = 1; pin3 = 1; pin5 = 1; pin9 = 1; pin11 = 1; pin13 = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pattern 101010", test_num);

            pin1 = 1; pin3 = 0; pin5 = 1; pin9 = 0; pin11 = 1; pin13 = 0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pattern 010101", test_num);

            pin1 = 0; pin3 = 1; pin5 = 0; pin9 = 1; pin11 = 0; pin13 = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed arbitrary pattern", test_num);

            pin1 = 1; pin3 = 1; pin5 = 0; pin9 = 0; pin11 = 1; pin13 = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complement of testcase 5", test_num);

            pin1 = 0; pin3 = 0; pin5 = 1; pin9 = 1; pin11 = 0; pin13 = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0);
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
        input expected_pin10;
        input expected_pin12;
        input expected_pin2;
        input expected_pin4;
        input expected_pin6;
        input expected_pin8;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pin10 === (expected_pin10 ^ pin10 ^ expected_pin10) &&
                expected_pin12 === (expected_pin12 ^ pin12 ^ expected_pin12) &&
                expected_pin2 === (expected_pin2 ^ pin2 ^ expected_pin2) &&
                expected_pin4 === (expected_pin4 ^ pin4 ^ expected_pin4) &&
                expected_pin6 === (expected_pin6 ^ pin6 ^ expected_pin6) &&
                expected_pin8 === (expected_pin8 ^ pin8 ^ expected_pin8)) begin
                $display("PASS");
                $display("  Outputs: pin10=%b, pin12=%b, pin2=%b, pin4=%b, pin6=%b, pin8=%b",
                         pin10, pin12, pin2, pin4, pin6, pin8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pin10=%b, pin12=%b, pin2=%b, pin4=%b, pin6=%b, pin8=%b",
                         expected_pin10, expected_pin12, expected_pin2, expected_pin4, expected_pin6, expected_pin8);
                $display("  Got:      pin10=%b, pin12=%b, pin2=%b, pin4=%b, pin6=%b, pin8=%b",
                         pin10, pin12, pin2, pin4, pin6, pin8);
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
