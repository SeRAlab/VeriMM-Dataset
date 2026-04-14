`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg mdio_mdc;
    reg mdio_o;
    reg mdio_t;
    reg phy0_mdio_i;
    reg phy1_mdio_i;
    wire mdio_i;
    wire phy0_mdc;
    wire phy0_mdio_o;
    wire phy0_mdio_t;
    wire phy1_mdc;
    wire phy1_mdio_o;
    wire phy1_mdio_t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mdio_mdc(mdio_mdc),
        .mdio_o(mdio_o),
        .mdio_t(mdio_t),
        .phy0_mdio_i(phy0_mdio_i),
        .phy1_mdio_i(phy1_mdio_i),
        .mdio_i(mdio_i),
        .phy0_mdc(phy0_mdc),
        .phy0_mdio_o(phy0_mdio_o),
        .phy0_mdio_t(phy0_mdio_t),
        .phy1_mdc(phy1_mdc),
        .phy1_mdio_o(phy1_mdio_o),
        .phy1_mdio_t(phy1_mdio_t)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All inputs at zero (Initial State)", test_num);
            mdio_mdc = 0;
            mdio_o = 0;
            mdio_t = 0;
            phy0_mdio_i = 0;
            phy1_mdio_i = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Test MDC distribution", test_num);
            mdio_mdc = 1;
            mdio_o = 0;
            mdio_t = 0;
            phy0_mdio_i = 1;
            phy1_mdio_i = 1;

            #1;


            check_outputs(1, 1, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Test MDIO Output data distribution", test_num);
            mdio_mdc = 0;
            mdio_o = 1;
            mdio_t = 0;
            phy0_mdio_i = 1;
            phy1_mdio_i = 1;
            #1;

            check_outputs(1, 0, 1, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Test MDIO Tri-state distribution", test_num);
            mdio_mdc = 0;
            mdio_o = 0;
            mdio_t = 1;
            phy0_mdio_i = 1;
            phy1_mdio_i = 1;
            #1;

            check_outputs(1, 0, 0, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: PHY0 driving MDIO bus low", test_num);
            mdio_mdc = 1;
            mdio_o = 1;
            mdio_t = 1;
            phy0_mdio_i = 0;
            phy1_mdio_i = 1;

            #1;


            check_outputs(0, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: PHY1 driving MDIO bus low", test_num);
            mdio_mdc = 1;
            mdio_o = 1;
            mdio_t = 1;
            phy0_mdio_i = 1;
            phy1_mdio_i = 0;
            #1;

            check_outputs(0, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Both PHYs high (Idle/High-Z state)", test_num);
            mdio_mdc = 0;
            mdio_o = 0;
            mdio_t = 0;
            phy0_mdio_i = 1;
            phy1_mdio_i = 1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Mixed signals verification", test_num);
            mdio_mdc = 1;
            mdio_o = 0;
            mdio_t = 1;
            phy0_mdio_i = 0;
            phy1_mdio_i = 0;
            #1;

            check_outputs(0, 1, 0, 1, 1, 0, 1);
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
        input expected_mdio_i;
        input expected_phy0_mdc;
        input expected_phy0_mdio_o;
        input expected_phy0_mdio_t;
        input expected_phy1_mdc;
        input expected_phy1_mdio_o;
        input expected_phy1_mdio_t;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mdio_i === (expected_mdio_i ^ mdio_i ^ expected_mdio_i) &&
                expected_phy0_mdc === (expected_phy0_mdc ^ phy0_mdc ^ expected_phy0_mdc) &&
                expected_phy0_mdio_o === (expected_phy0_mdio_o ^ phy0_mdio_o ^ expected_phy0_mdio_o) &&
                expected_phy0_mdio_t === (expected_phy0_mdio_t ^ phy0_mdio_t ^ expected_phy0_mdio_t) &&
                expected_phy1_mdc === (expected_phy1_mdc ^ phy1_mdc ^ expected_phy1_mdc) &&
                expected_phy1_mdio_o === (expected_phy1_mdio_o ^ phy1_mdio_o ^ expected_phy1_mdio_o) &&
                expected_phy1_mdio_t === (expected_phy1_mdio_t ^ phy1_mdio_t ^ expected_phy1_mdio_t)) begin
                $display("PASS");
                $display("  Outputs: mdio_i=%b, phy0_mdc=%b, phy0_mdio_o=%b, phy0_mdio_t=%b, phy1_mdc=%b, phy1_mdio_o=%b, phy1_mdio_t=%b",
                         mdio_i, phy0_mdc, phy0_mdio_o, phy0_mdio_t, phy1_mdc, phy1_mdio_o, phy1_mdio_t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mdio_i=%b, phy0_mdc=%b, phy0_mdio_o=%b, phy0_mdio_t=%b, phy1_mdc=%b, phy1_mdio_o=%b, phy1_mdio_t=%b",
                         expected_mdio_i, expected_phy0_mdc, expected_phy0_mdio_o, expected_phy0_mdio_t, expected_phy1_mdc, expected_phy1_mdio_o, expected_phy1_mdio_t);
                $display("  Got:      mdio_i=%b, phy0_mdc=%b, phy0_mdio_o=%b, phy0_mdio_t=%b, phy1_mdc=%b, phy1_mdio_o=%b, phy1_mdio_t=%b",
                         mdio_i, phy0_mdc, phy0_mdio_o, phy0_mdio_t, phy1_mdc, phy1_mdio_o, phy1_mdio_t);
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
