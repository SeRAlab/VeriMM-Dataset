`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg h;
    reg [2:0] r;
    wire R2;
    wire R3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .r(r),
        .R2(R2),
        .R3(R3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: State H (r=001), h=0 -> Next State I (R2=1, R3=0)", test_num);
            h = 1'b0; r = 3'b001;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: State H (r=001), h=1 -> Next State J (R2=0, R3=1)", test_num);
            h = 1'b1; r = 3'b001;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: State I (r=010), h=0 -> Next State J (R2=0, R3=1)", test_num);
            h = 1'b0; r = 3'b010;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: State I (r=010), h=1 -> Next State H (R2=0, R3=0)", test_num);
            h = 1'b1; r = 3'b010;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: State J (r=100), h=0 -> Next State H (R2=0, R3=0)", test_num);
            h = 1'b0; r = 3'b100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: State J (r=100), h=1 -> Next State I (R2=1, R3=0)", test_num);
            h = 1'b1; r = 3'b100;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros (r=000) -> Next State None (R2=0, R3=0)", test_num);
            h = 1'b0; r = 3'b000;
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
        input expected_R2;
        input expected_R3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R2 === (expected_R2 ^ R2 ^ expected_R2) &&
                expected_R3 === (expected_R3 ^ R3 ^ expected_R3)) begin
                $display("PASS");
                $display("  Outputs: R2=%b, R3=%b",
                         R2, R3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R2=%b, R3=%b",
                         expected_R2, expected_R3);
                $display("  Got:      R2=%b, R3=%b",
                         R2, R3);
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
