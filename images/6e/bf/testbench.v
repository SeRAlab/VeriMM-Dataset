`timescale 1ns/1ps

module logic_module_tb;

    // Testbench signals (combinational circuit)
    reg m;
    reg n;
    reg o;
    reg p;
    wire t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_module dut (
        .m(m),
        .n(n),
        .o(o),
        .p(p),
        .t(t)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: m=0, n=0, o=1, p=1");
            m = 1'b0; n = 1'b0; o = 1'b1; p = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: m=1, n=1, o=0, p=0");
            m = 1'b1; n = 1'b1; o = 1'b0; p = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: m=0, n=1, o=1, p=0");
            m = 1'b0; n = 1'b1; o = 1'b1; p = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: m=1, n=0, o=0, p=1");
            m = 1'b1; n = 1'b0; o = 1'b0; p = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: m=1, n=1, o=1, p=1");
            m = 1'b1; n = 1'b1; o = 1'b1; p = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: m=0, n=0, o=0, p=0");
            m = 1'b0; n = 1'b0; o = 1'b0; p = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: m=1, n=1, o=1, p=0");
            m = 1'b1; n = 1'b1; o = 1'b1; p = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: m=0, n=1, o=0, p=1");
            m = 1'b0; n = 1'b1; o = 1'b0; p = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: m=1, n=0, o=1, p=0");
            m = 1'b1; n = 1'b0; o = 1'b1; p = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: m=0, n=0, o=1, p=0");
            m = 1'b0; n = 1'b0; o = 1'b1; p = 1'b0;
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
        $display("logic_module Testbench");
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
        input expected_t;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_t === (expected_t ^ t ^ expected_t)) begin
                $display("PASS");
                $display("  Outputs: t=%b",
                         t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: t=%b",
                         expected_t);
                $display("  Got:      t=%b",
                         t);
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
