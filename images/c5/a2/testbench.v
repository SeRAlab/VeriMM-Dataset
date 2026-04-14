`timescale 1ns/1ps

module mod4sum_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mod4sum dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All inputs 0 (Sum=0)", test_num);
            A = 0; B = 0; C = 0; D = 0;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: One input high (Sum=1)", test_num);
            A = 1; B = 0; C = 0; D = 0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Two inputs high (Sum=2)", test_num);
            A = 1; B = 1; C = 0; D = 0;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Three inputs high (Sum=3)", test_num);
            A = 1; B = 1; C = 1; D = 0;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Four inputs high (Sum=4 -> Modulo 4 = 0)", test_num);
            A = 1; B = 1; C = 1; D = 1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Different single input high (Sum=1)", test_num);
            A = 0; B = 0; C = 1; D = 0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Different two inputs high (Sum=2)", test_num);
            A = 0; B = 1; C = 0; D = 1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Different three inputs high (Sum=3)", test_num);
            A = 0; B = 1; C = 1; D = 1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mod4sum Testbench");
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
        input [1:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
