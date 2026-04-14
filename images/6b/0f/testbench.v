`timescale 1ns/1ps

module custom_logic_tb;

    // Testbench signals (combinational circuit)
    reg k;
    reg l;
    reg m;
    reg n;
    wire control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    custom_logic dut (
        .k(k),
        .l(l),
        .m(m),
        .n(n),
        .control(control)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: k=1, l=1, m=0, n=1 -> control=0");
            k = 1; l = 1; m = 0; n = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: k=0, l=0, m=1, n=0 -> control=1");
            k = 0; l = 0; m = 1; n = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: k=1, l=0, m=1, n=1 -> control=1");
            k = 1; l = 0; m = 1; n = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: k=0, l=1, m=0, n=0 -> control=0");
            k = 0; l = 1; m = 0; n = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: k=1, l=1, m=1, n=0 -> control=1");
            k = 1; l = 1; m = 1; n = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: k=0, l=1, m=1, n=1 -> control=0");
            k = 0; l = 1; m = 1; n = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: k=1, l=0, m=0, n=1 -> control=1");
            k = 1; l = 0; m = 0; n = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: k=0, l=0, m=0, n=1 -> control=0");
            k = 0; l = 0; m = 0; n = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: k=1, l=1, m=1, n=1 -> control=1");
            k = 1; l = 1; m = 1; n = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: k=0, l=1, m=1, n=0 -> control=0");
            k = 0; l = 1; m = 1; n = 0;
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
        $display("custom_logic Testbench");
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
        input expected_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control === (expected_control ^ control ^ expected_control)) begin
                $display("PASS");
                $display("  Outputs: control=%b",
                         control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%b",
                         expected_control);
                $display("  Got:      control=%b",
                         control);
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
