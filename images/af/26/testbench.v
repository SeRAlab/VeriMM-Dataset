`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg gpio_i_o;
    reg gpio_i_t;
    reg gpio_o_i;
    reg wire_i_o;
    reg wire_i_t;
    reg wire_o_i;
    wire gpio_i_i;
    wire gpio_o_o;
    wire gpio_o_t;
    wire wire_i_i;
    wire wire_o_o;
    wire wire_o_t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gpio_i_o(gpio_i_o),
        .gpio_i_t(gpio_i_t),
        .gpio_o_i(gpio_o_i),
        .wire_i_o(wire_i_o),
        .wire_i_t(wire_i_t),
        .wire_o_i(wire_o_i),
        .gpio_i_i(gpio_i_i),
        .gpio_o_o(gpio_o_o),
        .gpio_o_t(gpio_o_t),
        .wire_i_i(wire_i_i),
        .wire_o_o(wire_o_o),
        .wire_o_t(wire_o_t)
    );
    task testcase001;

        begin
            $display("Test Case 001: All Inputs Low");

            gpio_i_o = 0;
            gpio_i_t = 0;
            gpio_o_i = 0;
            wire_i_o = 0;
            wire_i_t = 0;
            wire_o_i = 0;








            #1;









            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All Inputs High");

            gpio_i_o = 1;
            gpio_i_t = 1;
            gpio_o_i = 1;
            wire_i_o = 1;
            wire_i_t = 1;
            wire_o_i = 1;


            #1;



            check_outputs(1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: GPIO Input Group Toggle");


            gpio_i_o = 1;
            gpio_i_t = 0;
            wire_o_i = 1;


            gpio_o_i = 0;
            wire_i_o = 0;
            wire_i_t = 0;








            #1;









            check_outputs(1, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: GPIO Output Group Toggle");


            gpio_o_i = 1;
            wire_i_o = 1;
            wire_i_t = 1;


            gpio_i_o = 0;
            gpio_i_t = 0;
            wire_o_i = 0;








            #1;









            check_outputs(0, 1, 1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Mixed Pattern Check");

            gpio_i_o = 0;
            gpio_i_t = 1;
            gpio_o_i = 1;
            wire_i_o = 0;
            wire_i_t = 1;
            wire_o_i = 1;








            #1;









            check_outputs(1, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Bit Inverse Pattern");

            gpio_i_o = 1;
            gpio_i_t = 0;
            gpio_o_i = 0;
            wire_i_o = 1;
            wire_i_t = 0;
            wire_o_i = 0;



            #1;




            check_outputs(0, 1, 0, 0, 1, 0);
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
        input expected_gpio_i_i;
        input expected_gpio_o_o;
        input expected_gpio_o_t;
        input expected_wire_i_i;
        input expected_wire_o_o;
        input expected_wire_o_t;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gpio_i_i === (expected_gpio_i_i ^ gpio_i_i ^ expected_gpio_i_i) &&
                expected_gpio_o_o === (expected_gpio_o_o ^ gpio_o_o ^ expected_gpio_o_o) &&
                expected_gpio_o_t === (expected_gpio_o_t ^ gpio_o_t ^ expected_gpio_o_t) &&
                expected_wire_i_i === (expected_wire_i_i ^ wire_i_i ^ expected_wire_i_i) &&
                expected_wire_o_o === (expected_wire_o_o ^ wire_o_o ^ expected_wire_o_o) &&
                expected_wire_o_t === (expected_wire_o_t ^ wire_o_t ^ expected_wire_o_t)) begin
                $display("PASS");
                $display("  Outputs: gpio_i_i=%b, gpio_o_o=%b, gpio_o_t=%b, wire_i_i=%b, wire_o_o=%b, wire_o_t=%b",
                         gpio_i_i, gpio_o_o, gpio_o_t, wire_i_i, wire_o_o, wire_o_t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_i_i=%b, gpio_o_o=%b, gpio_o_t=%b, wire_i_i=%b, wire_o_o=%b, wire_o_t=%b",
                         expected_gpio_i_i, expected_gpio_o_o, expected_gpio_o_t, expected_wire_i_i, expected_wire_o_o, expected_wire_o_t);
                $display("  Got:      gpio_i_i=%b, gpio_o_o=%b, gpio_o_t=%b, wire_i_i=%b, wire_o_o=%b, wire_o_t=%b",
                         gpio_i_i, gpio_o_o, gpio_o_t, wire_i_i, wire_o_o, wire_o_t);
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
