`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg e;
    reg [3:0] w;
    wire W1;
    wire W2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .w(w),
        .W1(W1),
        .W2(W2)
    );
    task testcase001;

        begin
            test_num = 1;
            w = 4'b0001; e = 1;
            $display("Test %0d: State G (0001), e=1 -> Expect W1=1, W2=0", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            w = 4'b0001; e = 0;
            $display("Test %0d: State G (0001), e=0 -> Expect W1=0, W2=0", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            w = 4'b0010; e = 1;
            $display("Test %0d: State H (0010), e=1 -> Expect W1=0, W2=1", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            w = 4'b0010; e = 0;
            $display("Test %0d: State H (0010), e=0 -> Expect W1=0, W2=0", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            w = 4'b0100; e = 1;
            $display("Test %0d: State I (0100), e=1 -> Expect W1=0, W2=0", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            w = 4'b0100; e = 0;
            $display("Test %0d: State I (0100), e=0 -> Expect W1=0, W2=0", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            w = 4'b1000; e = 1;
            $display("Test %0d: State J (1000), e=1 -> Expect W1=1, W2=0", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            w = 4'b1000; e = 0;
            $display("Test %0d: State J (1000), e=0 -> Expect W1=0, W2=0", test_num);
            #1;

            check_outputs(0, 0);
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
        input expected_W1;
        input expected_W2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_W1 === (expected_W1 ^ W1 ^ expected_W1) &&
                expected_W2 === (expected_W2 ^ W2 ^ expected_W2)) begin
                $display("PASS");
                $display("  Outputs: W1=%b, W2=%b",
                         W1, W2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: W1=%b, W2=%b",
                         expected_W1, expected_W2);
                $display("  Got:      W1=%b, W2=%b",
                         W1, W2);
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
