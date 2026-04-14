`timescale 1ns/1ps

module alu_prep_daa_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] high;
    reg [3:0] low;
    wire high_eq_9;
    wire high_gt_9;
    wire low_gt_9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_prep_daa dut (
        .high(high),
        .low(low),
        .high_eq_9(high_eq_9),
        .high_gt_9(high_gt_9),
        .low_gt_9(low_gt_9)
    );
    task testcase001;

        begin
            test_num = 1;
            high = 4'd5; low = 4'd4;
            $display("Test %03d: Inputs high=5, low=4", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            high = 4'd2; low = 4'd10;
            $display("Test %03d: Inputs high=2, low=10", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            high = 4'd9; low = 4'd0;
            $display("Test %03d: Inputs high=9, low=0", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            high = 4'd11; low = 4'd5;
            $display("Test %03d: Inputs high=11, low=5", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            high = 4'd15; low = 4'd15;
            $display("Test %03d: Inputs high=15, low=15", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            high = 4'd9; low = 4'd12;
            $display("Test %03d: Inputs high=9, low=12", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            high = 4'd0; low = 4'd0;
            $display("Test %03d: Inputs high=0, low=0", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            high = 4'd8; low = 4'd9;
            $display("Test %03d: Inputs high=8, low=9", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_prep_daa Testbench");
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
        input expected_high_eq_9;
        input expected_high_gt_9;
        input expected_low_gt_9;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_high_eq_9 === (expected_high_eq_9 ^ high_eq_9 ^ expected_high_eq_9) &&
                expected_high_gt_9 === (expected_high_gt_9 ^ high_gt_9 ^ expected_high_gt_9) &&
                expected_low_gt_9 === (expected_low_gt_9 ^ low_gt_9 ^ expected_low_gt_9)) begin
                $display("PASS");
                $display("  Outputs: high_eq_9=%b, high_gt_9=%b, low_gt_9=%b",
                         high_eq_9, high_gt_9, low_gt_9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high_eq_9=%b, high_gt_9=%b, low_gt_9=%b",
                         expected_high_eq_9, expected_high_gt_9, expected_low_gt_9);
                $display("  Got:      high_eq_9=%b, high_gt_9=%b, low_gt_9=%b",
                         high_eq_9, high_gt_9, low_gt_9);
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
