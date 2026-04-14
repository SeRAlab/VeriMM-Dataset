`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg direction;
    reg [1:0] shift_amount;
    reg [3:0] signed_data;
    wire GTE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .direction(direction),
        .shift_amount(shift_amount),
        .signed_data(signed_data),
        .GTE(GTE)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive data, shift amount 0, Left", test_num);
            direction = 0;
            shift_amount = 2'b00;
            signed_data = 4'sb0011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative data, shift amount 0, Right", test_num);
            direction = 1;
            shift_amount = 2'b00;
            signed_data = 4'sb1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive data, Left shift (remains positive)", test_num);
            direction = 0;
            shift_amount = 2'b10;
            signed_data = 4'sb0001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive data, Left shift (overflows to negative)", test_num);
            direction = 0;
            shift_amount = 2'b10;
            signed_data = 4'sb0010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative data, Left shift (remains negative)", test_num);
            direction = 0;
            shift_amount = 2'b01;
            signed_data = 4'sb1101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive data, Right shift", test_num);
            direction = 1;
            shift_amount = 2'b10;
            signed_data = 4'sb0111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative data, Right shift (arithmetic preservation)", test_num);
            direction = 1;
            shift_amount = 2'b10;
            signed_data = 4'sb1000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative data, Right shift maximum", test_num);
            direction = 1;
            shift_amount = 2'b11;
            signed_data = 4'sb1000;
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
        input expected_GTE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GTE === (expected_GTE ^ GTE ^ expected_GTE)) begin
                $display("PASS");
                $display("  Outputs: GTE=%b",
                         GTE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GTE=%b",
                         expected_GTE);
                $display("  Got:      GTE=%b",
                         GTE);
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
