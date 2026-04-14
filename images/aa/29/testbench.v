`timescale 1ns/1ps

module logic_circuit_tb;

    // Testbench signals (combinational circuit)
    reg e;
    reg f;
    reg g;
    reg h;
    wire u;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_circuit dut (
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .u(u)
    );
    task testcase001;

        begin
            test_num = 1;
            e = 1; f = 1; g = 0; h = 1;
            $display("Test Case 001: e=1, f=1, g=0, h=1");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            e = 0; f = 0; g = 1; h = 0;
            $display("Test Case 002: e=0, f=0, g=1, h=0");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            e = 1; f = 0; g = 1; h = 1;
            $display("Test Case 003: e=1, f=0, g=1, h=1");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            e = 0; f = 1; g = 0; h = 0;
            $display("Test Case 004: e=0, f=1, g=0, h=0");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            e = 1; f = 1; g = 1; h = 0;
            $display("Test Case 005: e=1, f=1, g=1, h=0");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            e = 0; f = 0; g = 0; h = 1;
            $display("Test Case 006: e=0, f=0, g=0, h=1");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            e = 1; f = 0; g = 0; h = 0;
            $display("Test Case 007: e=1, f=0, g=0, h=0");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            e = 0; f = 1; g = 1; h = 1;
            $display("Test Case 008: e=0, f=1, g=1, h=1");
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
        $display("logic_circuit Testbench");
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
        input expected_u;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_u === (expected_u ^ u ^ expected_u)) begin
                $display("PASS");
                $display("  Outputs: u=%b",
                         u);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%b",
                         expected_u);
                $display("  Got:      u=%b",
                         u);
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
