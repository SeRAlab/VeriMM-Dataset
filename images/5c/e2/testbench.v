`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg e;
    reg [2:0] w;
    wire W2;
    wire W3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .w(w),
        .W2(W2),
        .W3(W3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: From State P (w=3'b001), e=0 -> Expected Next State: Q (W2=1, W3=0)", test_num);
            w = 3'b001;
            e = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: From State P (w=3'b001), e=1 -> Expected Next State: R (W2=0, W3=1)", test_num);
            w = 3'b001;
            e = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: From State Q (w=3'b010), e=0 -> Expected Next State: P (W2=0, W3=0)", test_num);
            w = 3'b010;
            e = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: From State Q (w=3'b010), e=1 -> Expected Next State: R (W2=0, W3=1)", test_num);
            w = 3'b010;
            e = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: From State R (w=3'b100), e=0 -> Expected Next State: Q (W2=1, W3=0)", test_num);
            w = 3'b100;
            e = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: From State R (w=3'b100), e=1 -> Expected Next State: P (W2=0, W3=0)", test_num);
            w = 3'b100;
            e = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Boundary Case - Invalid One-Hot (w=3'b000), e=0 -> Expected Outputs: 0, 0", test_num);
            w = 3'b000;
            e = 0;
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
        input expected_W2;
        input expected_W3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_W2 === (expected_W2 ^ W2 ^ expected_W2) &&
                expected_W3 === (expected_W3 ^ W3 ^ expected_W3)) begin
                $display("PASS");
                $display("  Outputs: W2=%b, W3=%b",
                         W2, W3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: W2=%b, W3=%b",
                         expected_W2, expected_W3);
                $display("  Got:      W2=%b, W3=%b",
                         W2, W3);
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
