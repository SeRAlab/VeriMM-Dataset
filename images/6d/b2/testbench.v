`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Gi;
    reg GiPrev;
    reg Pi;
    reg PiPrev;
    wire G;
    wire P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Gi(Gi),
        .GiPrev(GiPrev),
        .Pi(Pi),
        .PiPrev(PiPrev),
        .G(G),
        .P(P)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All signals low", test_num);
            Gi = 0; Pi = 0; GiPrev = 0; PiPrev = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Current Generate (Gi) high", test_num);
            Gi = 1; Pi = 0; GiPrev = 0; PiPrev = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Pi and GiPrev high (Propagated Generate)", test_num);
            Gi = 0; Pi = 1; GiPrev = 1; PiPrev = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Pi and PiPrev high (Group Propagate)", test_num);
            Gi = 0; Pi = 1; GiPrev = 0; PiPrev = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Previous signals high, current low (Isolation)", test_num);
            Gi = 0; Pi = 0; GiPrev = 1; PiPrev = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All inputs high", test_num);
            Gi = 1; Pi = 1; GiPrev = 1; PiPrev = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Gi and PiPrev high", test_num);
            Gi = 1; Pi = 0; GiPrev = 0; PiPrev = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Pi high with both GiPrev and PiPrev high", test_num);
            Gi = 0; Pi = 1; GiPrev = 1; PiPrev = 1;
            #1;

            check_outputs(1, 1);
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
        input expected_G;
        input expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G) &&
                expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: G=%b, P=%b",
                         G, P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%b, P=%b",
                         expected_G, expected_P);
                $display("  Got:      G=%b, P=%b",
                         G, P);
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
