`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg j;
    reg l;
    reg q;
    wire g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .j(j),
        .l(l),
        .q(q),
        .g(g)
    );
    task testcase001;

        begin
            test_num = 1;
            q = 0; l = 0; d = 0; j = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            q = 0; l = 0; d = 0; j = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            q = 0; l = 0; d = 1; j = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            q = 0; l = 0; d = 1; j = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            q = 0; l = 1; d = 0; j = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            q = 0; l = 1; d = 0; j = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            q = 0; l = 1; d = 1; j = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            q = 0; l = 1; d = 1; j = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            q = 1; l = 0; d = 0; j = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            q = 1; l = 0; d = 0; j = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            q = 1; l = 0; d = 1; j = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            q = 1; l = 0; d = 1; j = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            q = 1; l = 1; d = 0; j = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            q = 1; l = 1; d = 0; j = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            q = 1; l = 1; d = 1; j = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            q = 1; l = 1; d = 1; j = 1;
            #1;

            check_outputs(0);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: g=%b",
                         g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%b",
                         expected_g);
                $display("  Got:      g=%b",
                         g);
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
