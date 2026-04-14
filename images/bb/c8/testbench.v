`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CAN_A_TX;
    reg CAN_B_TX;
    reg CAN_C_TX;
    reg CAN_D_TX;
    wire CAN_A_RX;
    wire CAN_B_RX;
    wire CAN_C_RX;
    wire CAN_D_RX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CAN_A_TX(CAN_A_TX),
        .CAN_B_TX(CAN_B_TX),
        .CAN_C_TX(CAN_C_TX),
        .CAN_D_TX(CAN_D_TX),
        .CAN_A_RX(CAN_A_RX),
        .CAN_B_RX(CAN_B_RX),
        .CAN_C_RX(CAN_C_RX),
        .CAN_D_RX(CAN_D_RX)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All TX HIGH", test_num);
            CAN_A_TX = 1'b1;
            CAN_B_TX = 1'b1;
            CAN_C_TX = 1'b1;
            CAN_D_TX = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: CAN_A_TX LOW", test_num);
            CAN_A_TX = 1'b0;
            CAN_B_TX = 1'b1;
            CAN_C_TX = 1'b1;
            CAN_D_TX = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: CAN_B_TX LOW", test_num);
            CAN_A_TX = 1'b1;
            CAN_B_TX = 1'b0;
            CAN_C_TX = 1'b1;
            CAN_D_TX = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: CAN_C_TX LOW", test_num);
            CAN_A_TX = 1'b1;
            CAN_B_TX = 1'b1;
            CAN_C_TX = 1'b0;
            CAN_D_TX = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: CAN_D_TX LOW", test_num);
            CAN_A_TX = 1'b1;
            CAN_B_TX = 1'b1;
            CAN_C_TX = 1'b1;
            CAN_D_TX = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Multiple TX LOW (A and C)", test_num);
            CAN_A_TX = 1'b0;
            CAN_B_TX = 1'b1;
            CAN_C_TX = 1'b0;
            CAN_D_TX = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: All TX LOW", test_num);
            CAN_A_TX = 1'b0;
            CAN_B_TX = 1'b0;
            CAN_C_TX = 1'b0;
            CAN_D_TX = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_CAN_A_RX;
        input expected_CAN_B_RX;
        input expected_CAN_C_RX;
        input expected_CAN_D_RX;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CAN_A_RX === (expected_CAN_A_RX ^ CAN_A_RX ^ expected_CAN_A_RX) &&
                expected_CAN_B_RX === (expected_CAN_B_RX ^ CAN_B_RX ^ expected_CAN_B_RX) &&
                expected_CAN_C_RX === (expected_CAN_C_RX ^ CAN_C_RX ^ expected_CAN_C_RX) &&
                expected_CAN_D_RX === (expected_CAN_D_RX ^ CAN_D_RX ^ expected_CAN_D_RX)) begin
                $display("PASS");
                $display("  Outputs: CAN_A_RX=%b, CAN_B_RX=%b, CAN_C_RX=%b, CAN_D_RX=%b",
                         CAN_A_RX, CAN_B_RX, CAN_C_RX, CAN_D_RX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CAN_A_RX=%b, CAN_B_RX=%b, CAN_C_RX=%b, CAN_D_RX=%b",
                         expected_CAN_A_RX, expected_CAN_B_RX, expected_CAN_C_RX, expected_CAN_D_RX);
                $display("  Got:      CAN_A_RX=%b, CAN_B_RX=%b, CAN_C_RX=%b, CAN_D_RX=%b",
                         CAN_A_RX, CAN_B_RX, CAN_C_RX, CAN_D_RX);
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
