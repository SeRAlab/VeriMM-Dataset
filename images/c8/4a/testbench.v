`timescale 1ns/1ps

module boolean_function_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    boolean_function dut (
        .A(A),
        .B(B),
        .C(C),
        .X(X)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0;
        $display("Testcase %0d: A=%b, B=%b, C=%b", test_num, A, B, C);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 1;
        $display("Testcase %0d: A=%b, B=%b, C=%b", test_num, A, B, C);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 0; B = 1; C = 0;
        $display("Testcase %0d: A=%b, B=%b, C=%b", test_num, A, B, C);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 0; B = 1; C = 1;
        $display("Testcase %0d: A=%b, B=%b, C=%b", test_num, A, B, C);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 1; B = 0; C = 0;
        $display("Testcase %0d: A=%b, B=%b, C=%b", test_num, A, B, C);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 1; B = 0; C = 1;
        $display("Testcase %0d: A=%b, B=%b, C=%b", test_num, A, B, C);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 1; B = 1; C = 0;
        $display("Testcase %0d: A=%b, B=%b, C=%b", test_num, A, B, C);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 1; B = 1; C = 1;
        $display("Testcase %0d: A=%b, B=%b, C=%b", test_num, A, B, C);
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
        $display("boolean_function Testbench");
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
