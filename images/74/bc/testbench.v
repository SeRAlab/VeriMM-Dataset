`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg k;
    reg [3:0] m;
    wire M1;
    wire M2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .k(k),
        .m(m),
        .M1(M1),
        .M2(M2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State A (m=0001), k=1 -> Expected M1=1, M2=0", test_num);
            m = 4'b0001;
            k = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State A (m=0001), k=0 -> Expected M1=0, M2=0", test_num);
            m = 4'b0001;
            k = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State B (m=0010), k=1 -> Expected M1=0, M2=1", test_num);
            m = 4'b0010;
            k = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State B (m=0010), k=0 -> Expected M1=0, M2=0", test_num);
            m = 4'b0010;
            k = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State C (m=0100), k=1 -> Expected M1=0, M2=0", test_num);
            m = 4'b0100;
            k = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State C (m=0100), k=0 -> Expected M1=0, M2=0", test_num);
            m = 4'b0100;
            k = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: State D (m=1000), k=1 -> Expected M1=1, M2=0", test_num);
            m = 4'b1000;
            k = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: State D (m=1000), k=0 -> Expected M1=0, M2=0", test_num);
            m = 4'b1000;
            k = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Invalid State (m=0000), k=1 -> Expected M1=0, M2=0", test_num);
            m = 4'b0000;
            k = 1'b1;
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
        testcase008();
        testcase009();
        
        
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
        input expected_M1;
        input expected_M2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M1 === (expected_M1 ^ M1 ^ expected_M1) &&
                expected_M2 === (expected_M2 ^ M2 ^ expected_M2)) begin
                $display("PASS");
                $display("  Outputs: M1=%b, M2=%b",
                         M1, M2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M1=%b, M2=%b",
                         expected_M1, expected_M2);
                $display("  Got:      M1=%b, M2=%b",
                         M1, M2);
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
