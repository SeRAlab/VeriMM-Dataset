`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg [1:0] y;
    wire T;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .y(y),
        .T(T)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: State E(00), d=0 -> Next State F(01), T=0", test_num);
            y = 2'b00; d = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: State E(00), d=1 -> Next State G(10), T=1", test_num);
            y = 2'b00; d = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: State F(01), d=0 -> Next State H(11), T=1", test_num);
            y = 2'b01; d = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: State F(01), d=1 -> Next State E(00), T=0", test_num);
            y = 2'b01; d = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: State G(10), d=0 -> Next State E(00), T=0", test_num);
            y = 2'b10; d = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: State G(10), d=1 -> Next State H(11), T=1", test_num);
            y = 2'b10; d = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: State H(11), d=0 -> Next State G(10), T=1", test_num);
            y = 2'b11; d = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: State H(11), d=1 -> Next State F(01), T=0", test_num);
            y = 2'b11; d = 1'b1;
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
        input expected_T;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_T === (expected_T ^ T ^ expected_T)) begin
                $display("PASS");
                $display("  Outputs: T=%b",
                         T);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: T=%b",
                         expected_T);
                $display("  Got:      T=%b",
                         T);
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
