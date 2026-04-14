`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c0;
    reg g0;
    reg g1;
    reg g2;
    reg g3;
    reg p0;
    reg p1;
    reg p2;
    reg p3;
    wire G;
    wire P;
    wire c1;
    wire c2;
    wire c3;
    wire c4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c0(c0),
        .g0(g0),
        .g1(g1),
        .g2(g2),
        .g3(g3),
        .p0(p0),
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .G(G),
        .P(P),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .c4(c4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            c0 = 0; g3 = 0; g2 = 0; g1 = 0; g0 = 0; p3 = 0; p2 = 0; p1 = 0; p0 = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in only (c0=1), no propagation", test_num);
            c0 = 1; g3 = 0; g2 = 0; g1 = 0; g0 = 0; p3 = 0; p2 = 0; p1 = 0; p0 = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in (c0=1) with full propagation (P=1)", test_num);
            c0 = 1; g3 = 0; g2 = 0; g1 = 0; g0 = 0; p3 = 1; p2 = 1; p1 = 1; p0 = 1;

            #1;


            check_outputs(0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Generate at stage 0 (g0=1), no propagation", test_num);
            c0 = 0; g3 = 0; g2 = 0; g1 = 0; g0 = 1; p3 = 0; p2 = 0; p1 = 0; p0 = 0;


            #1;



            check_outputs(0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Generate at stage 0 (g0=1) with propagation to c4", test_num);
            c0 = 0; g3 = 0; g2 = 0; g1 = 0; g0 = 1; p3 = 1; p2 = 1; p1 = 1; p0 = 0;


            #1;



            check_outputs(1, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Generate at stage 3 (g3=1)", test_num);
            c0 = 0; g3 = 1; g2 = 0; g1 = 0; g0 = 0; p3 = 0; p2 = 0; p1 = 0; p0 = 0;

            #1;


            check_outputs(1, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Propagation interrupted at stage 1", test_num);
            c0 = 1; g3 = 0; g2 = 0; g1 = 0; g0 = 0; p3 = 1; p2 = 1; p1 = 0; p0 = 1;


            #1;



            check_outputs(0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Partial generate (g1) and propagation", test_num);
            c0 = 0; g3 = 0; g2 = 0; g1 = 1; g0 = 0; p3 = 1; p2 = 1; p1 = 0; p0 = 0;

            #1;


            check_outputs(1, 0, 0, 1, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All generate signals high", test_num);
            c0 = 0; g3 = 1; g2 = 1; g1 = 1; g0 = 1; p3 = 0; p2 = 0; p1 = 0; p0 = 0;

            #1;


            check_outputs(1, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex configuration", test_num);

            c0 = 1; g3 = 0; g2 = 1; g1 = 0; g0 = 1; p3 = 1; p2 = 0; p1 = 1; p0 = 0;






            #1;







            check_outputs(1, 0, 1, 1, 1, 1);
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
        testcase009();
        testcase010();
        
        
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
        input expected_G;
        input expected_P;
        input expected_c1;
        input expected_c2;
        input expected_c3;
        input expected_c4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G) &&
                expected_P === (expected_P ^ P ^ expected_P) &&
                expected_c1 === (expected_c1 ^ c1 ^ expected_c1) &&
                expected_c2 === (expected_c2 ^ c2 ^ expected_c2) &&
                expected_c3 === (expected_c3 ^ c3 ^ expected_c3) &&
                expected_c4 === (expected_c4 ^ c4 ^ expected_c4)) begin
                $display("PASS");
                $display("  Outputs: G=%b, P=%b, c1=%b, c2=%b, c3=%b, c4=%b",
                         G, P, c1, c2, c3, c4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%b, P=%b, c1=%b, c2=%b, c3=%b, c4=%b",
                         expected_G, expected_P, expected_c1, expected_c2, expected_c3, expected_c4);
                $display("  Got:      G=%b, P=%b, c1=%b, c2=%b, c3=%b, c4=%b",
                         G, P, c1, c2, c3, c4);
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
