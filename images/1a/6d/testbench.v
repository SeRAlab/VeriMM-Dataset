`timescale 1ns/1ps

module SR_latch_tb;

    // Testbench signals (combinational circuit)
    reg R;
    reg S;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SR_latch dut (
        .R(R),
        .S(S),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asserting Reset (S=0, R=1)", test_num);

        S = 0; R = 1;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Set Operation (Reset -> Set)", test_num);

        S = 0; R = 1;
        #10;

        S = 1; R = 0;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold State (Reset -> Set -> Hold)", test_num);

        S = 0; R = 1;
        #10;

        S = 1; R = 0;
        #10;

        S = 0; R = 0;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset after Set (Reset -> Set -> Reset)", test_num);

        S = 0; R = 1;
        #10;

        S = 1; R = 0;
        #10;

        S = 0; R = 1;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold State after Reset (Reset -> Hold)", test_num);

        S = 0; R = 1;
        #10;

        S = 0; R = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Toggles (Reset -> Set -> Reset -> Set)", test_num);

        S = 0; R = 1;
        #10;
        S = 1; R = 0;
        #10;
        S = 0; R = 1;
        #10;
        S = 1; R = 0;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SR_latch Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
