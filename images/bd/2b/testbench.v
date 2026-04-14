`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p10_b3;
    reg p11_a3;
    reg p13_b4;
    reg p14_a4;
    reg p15_enable_n;
    reg p1_sel;
    reg p2_a1;
    reg p3_b1;
    reg p5_a2;
    reg p6_b2;
    wire p12_o4;
    wire p4_o1;
    wire p7_o2;
    wire p9_o3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p10_b3(p10_b3),
        .p11_a3(p11_a3),
        .p13_b4(p13_b4),
        .p14_a4(p14_a4),
        .p15_enable_n(p15_enable_n),
        .p1_sel(p1_sel),
        .p2_a1(p2_a1),
        .p3_b1(p3_b1),
        .p5_a2(p5_a2),
        .p6_b2(p6_b2),
        .p12_o4(p12_o4),
        .p4_o1(p4_o1),
        .p7_o2(p7_o2),
        .p9_o3(p9_o3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low (Disabled)", test_num);
            p15_enable_n = 1'b0;
            p1_sel = 1'b0;
            p2_a1 = 1'b1; p3_b1 = 1'b1;
            p5_a2 = 1'b1; p6_b2 = 1'b1;
            p11_a3 = 1'b1; p10_b3 = 1'b1;
            p14_a4 = 1'b1; p13_b4 = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Sel low (Select A), A=1111", test_num);
            p15_enable_n = 1'b1;
            p1_sel = 1'b0;
            p2_a1 = 1'b1; p3_b1 = 1'b0;
            p5_a2 = 1'b1; p6_b2 = 1'b0;
            p11_a3 = 1'b1; p10_b3 = 1'b0;
            p14_a4 = 1'b1; p13_b4 = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Sel low (Select A), A=0000, B=1111", test_num);
            p15_enable_n = 1'b1;
            p1_sel = 1'b0;
            p2_a1 = 1'b0; p3_b1 = 1'b1;
            p5_a2 = 1'b0; p6_b2 = 1'b1;
            p11_a3 = 1'b0; p10_b3 = 1'b1;
            p14_a4 = 1'b0; p13_b4 = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Sel high (Select B), B=1111, A=0000", test_num);
            p15_enable_n = 1'b1;
            p1_sel = 1'b1;
            p2_a1 = 1'b0; p3_b1 = 1'b1;
            p5_a2 = 1'b0; p6_b2 = 1'b1;
            p11_a3 = 1'b0; p10_b3 = 1'b1;
            p14_a4 = 1'b0; p13_b4 = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Sel high (Select B), B=0000, A=1111", test_num);
            p15_enable_n = 1'b1;
            p1_sel = 1'b1;
            p2_a1 = 1'b1; p3_b1 = 1'b0;
            p5_a2 = 1'b1; p6_b2 = 1'b0;
            p11_a3 = 1'b1; p10_b3 = 1'b0;
            p14_a4 = 1'b1; p13_b4 = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits, Select A (1010)", test_num);
            p15_enable_n = 1'b1;
            p1_sel = 1'b0;
            p2_a1 = 1'b1; p3_b1 = 1'b0;
            p5_a2 = 1'b0; p6_b2 = 1'b1;
            p11_a3 = 1'b1; p10_b3 = 1'b0;
            p14_a4 = 1'b0; p13_b4 = 1'b1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits, Select B (0101)", test_num);
            p15_enable_n = 1'b1;
            p1_sel = 1'b1;
            p2_a1 = 1'b1; p3_b1 = 1'b0;
            p5_a2 = 1'b0; p6_b2 = 1'b1;
            p11_a3 = 1'b1; p10_b3 = 1'b0;
            p14_a4 = 1'b0; p13_b4 = 1'b1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Enable high to low", test_num);
            p2_a1 = 1'b1; p5_a2 = 1'b1; p11_a3 = 1'b1; p14_a4 = 1'b1;
            p1_sel = 1'b0;
            p15_enable_n = 1'b1; #5;
            p15_enable_n = 1'b0;

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
        input expected_p12_o4;
        input expected_p4_o1;
        input expected_p7_o2;
        input expected_p9_o3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p12_o4 === (expected_p12_o4 ^ p12_o4 ^ expected_p12_o4) &&
                expected_p4_o1 === (expected_p4_o1 ^ p4_o1 ^ expected_p4_o1) &&
                expected_p7_o2 === (expected_p7_o2 ^ p7_o2 ^ expected_p7_o2) &&
                expected_p9_o3 === (expected_p9_o3 ^ p9_o3 ^ expected_p9_o3)) begin
                $display("PASS");
                $display("  Outputs: p12_o4=%b, p4_o1=%b, p7_o2=%b, p9_o3=%b",
                         p12_o4, p4_o1, p7_o2, p9_o3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p12_o4=%b, p4_o1=%b, p7_o2=%b, p9_o3=%b",
                         expected_p12_o4, expected_p4_o1, expected_p7_o2, expected_p9_o3);
                $display("  Got:      p12_o4=%b, p4_o1=%b, p7_o2=%b, p9_o3=%b",
                         p12_o4, p4_o1, p7_o2, p9_o3);
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
