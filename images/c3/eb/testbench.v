`timescale 1ns/1ps

module four_input_gate_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg C1;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_input_gate dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .C1(C1),
        .X(X)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A1=0, B1=0, C1=0 (All 0s) -> Expected X=0", test_num);
            A1 = 0; A2 = 0; B1 = 0; C1 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A1=1, A2=1 (A1 and A2 High) -> Expected X=1", test_num);
            A1 = 1; A2 = 1; B1 = 0; C1 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A1=1, A2=0 (A1 high, A2 low - A1 path dominates) -> Expected X=0", test_num);
            A1 = 1; A2 = 0; B1 = 1; C1 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A1=0, B1=1 (A1 low, B1 high) -> Expected X=1", test_num);
            A1 = 0; A2 = 1; B1 = 1; C1 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A1=0, B1=0, C1=1 (A1 low, B1 low, C1 high) -> Expected X=1", test_num);
            A1 = 0; A2 = 0; B1 = 0; C1 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A1=0, A2=1, B1=0, C1=0 (A1 path low, B/C path low) -> Expected X=0", test_num);
            A1 = 0; A2 = 1; B1 = 0; C1 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A1=0, B1=1, C1=1 (B1 and C1 High) -> Expected X=1", test_num);
            A1 = 0; A2 = 0; B1 = 1; C1 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A1=1, A2=1, B1=1, C1=1 (All 1s) -> Expected X=1", test_num);
            A1 = 1; A2 = 1; B1 = 1; C1 = 1;
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
        $display("four_input_gate Testbench");
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
