`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] signal;
    reg x1;
    reg x2;
    reg x3;
    wire OUTPUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signal(signal),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .OUTPUT(OUTPUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=00, x1=0 (expecting OUTPUT=0)", test_num);
            signal = 2'b00;
            x1 = 0;
            x2 = 1;
            x3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=00, x1=1 (expecting OUTPUT=1)", test_num);
            signal = 2'b00;
            x1 = 1;
            x2 = 0;
            x3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=01, x2=0 (expecting OUTPUT=0)", test_num);
            signal = 2'b01;
            x1 = 1;
            x2 = 0;
            x3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=01, x2=1 (expecting OUTPUT=1)", test_num);
            signal = 2'b01;
            x1 = 0;
            x2 = 1;
            x3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=10, x3=0 (expecting OUTPUT=0)", test_num);
            signal = 2'b10;
            x1 = 1;
            x2 = 1;
            x3 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=10, x3=1 (expecting OUTPUT=1)", test_num);
            signal = 2'b10;
            x1 = 0;
            x2 = 0;
            x3 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=00 isolation check (ignore x2, x3)", test_num);
            signal = 2'b00;
            x1 = 1;
            x2 = 0;
            x3 = 0;
            #1;
            x2 = 1;
            x3 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=01 isolation check (ignore x1, x3)", test_num);
            signal = 2'b01;
            x1 = 0;
            x2 = 0;
            x3 = 0;
            #1;
            x1 = 1;
            x3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal=10 isolation check (ignore x1, x2)", test_num);
            signal = 2'b10;
            x1 = 1;
            x2 = 1;
            x3 = 1;
            #1;
            x1 = 0;
            x2 = 0;
            #1;

            check_outputs(1'b1);
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
        input expected_OUTPUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUTPUT === (expected_OUTPUT ^ OUTPUT ^ expected_OUTPUT)) begin
                $display("PASS");
                $display("  Outputs: OUTPUT=%b",
                         OUTPUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUTPUT=%b",
                         expected_OUTPUT);
                $display("  Got:      OUTPUT=%b",
                         OUTPUT);
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
