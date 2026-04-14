`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg sw1_d1;
    reg sw2_d2;
    reg sw3_d3;
    reg sw4_d4;
    reg sw5_a0;
    reg sw6_a1;
    wire led8_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sw1_d1(sw1_d1),
        .sw2_d2(sw2_d2),
        .sw3_d3(sw3_d3),
        .sw4_d4(sw4_d4),
        .sw5_a0(sw5_a0),
        .sw6_a1(sw6_a1),
        .led8_out(led8_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select sw1_d1 (a1=0, a0=0), input sw1_d1=1", test_num);
            sw6_a1 = 0; sw5_a0 = 0;
            sw1_d1 = 1; sw2_d2 = 0; sw3_d3 = 0; sw4_d4 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select sw1_d1 (a1=0, a0=0), input sw1_d1=0, others=1", test_num);
            sw6_a1 = 0; sw5_a0 = 0;
            sw1_d1 = 0; sw2_d2 = 1; sw3_d3 = 1; sw4_d4 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select sw2_d2 (a1=0, a0=1), input sw2_d2=1", test_num);
            sw6_a1 = 0; sw5_a0 = 1;
            sw1_d1 = 0; sw2_d2 = 1; sw3_d3 = 0; sw4_d4 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select sw2_d2 (a1=0, a0=1), input sw2_d2=0, others=1", test_num);
            sw6_a1 = 0; sw5_a0 = 1;
            sw1_d1 = 1; sw2_d2 = 0; sw3_d3 = 1; sw4_d4 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select sw3_d3 (a1=1, a0=0), input sw3_d3=1", test_num);
            sw6_a1 = 1; sw5_a0 = 0;
            sw1_d1 = 0; sw2_d2 = 0; sw3_d3 = 1; sw4_d4 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select sw3_d3 (a1=1, a0=0), input sw3_d3=0, others=1", test_num);
            sw6_a1 = 1; sw5_a0 = 0;
            sw1_d1 = 1; sw2_d2 = 1; sw3_d3 = 0; sw4_d4 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Select sw4_d4 (a1=1, a0=1), input sw4_d4=1", test_num);
            sw6_a1 = 1; sw5_a0 = 1;
            sw1_d1 = 0; sw2_d2 = 0; sw3_d3 = 0; sw4_d4 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Select sw4_d4 (a1=1, a0=1), input sw4_d4=0, others=1", test_num);
            sw6_a1 = 1; sw5_a0 = 1;
            sw1_d1 = 1; sw2_d2 = 1; sw3_d3 = 1; sw4_d4 = 0;
            #1;

            check_outputs(1'b0);
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
        input expected_led8_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led8_out === (expected_led8_out ^ led8_out ^ expected_led8_out)) begin
                $display("PASS");
                $display("  Outputs: led8_out=%b",
                         led8_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led8_out=%b",
                         expected_led8_out);
                $display("  Got:      led8_out=%b",
                         led8_out);
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
