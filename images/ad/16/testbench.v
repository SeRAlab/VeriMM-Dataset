`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg GATE;
    reg RESET_B;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .GATE(GATE),
        .RESET_B(RESET_B),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Asynchronous Reset Assertion", test_num);

            RESET_B = 0;
            D = 1;
            GATE = 1;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Transparent Mode (GATE=1, D=1)", test_num);

            RESET_B = 0; #5; RESET_B = 1;

            GATE = 1;
            D = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Transparent Mode (GATE=1, D=0)", test_num);

            RESET_B = 0; #5; RESET_B = 1;

            GATE = 1;
            D = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Latch Hold Mode (GATE 1->0, holding D=1)", test_num);

            RESET_B = 0; #5; RESET_B = 1;

            GATE = 1; D = 1;
            #5;

            GATE = 0;
            #5;

            D = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Latch Hold Mode (GATE 1->0, holding D=0)", test_num);

            RESET_B = 0; #5; RESET_B = 1;

            GATE = 1; D = 0;
            #5;

            GATE = 0;
            #5;

            D = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Reset Priority Over Gate/Data", test_num);

            RESET_B = 0; #5; RESET_B = 1;

            GATE = 1; D = 1;
            #5;

            RESET_B = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Latch Retaining State during Reset transition", test_num);

            RESET_B = 0; #5; RESET_B = 1;

            GATE = 1; D = 1; #5;
            GATE = 0; #5;

            D = 0;
            #10;
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
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
