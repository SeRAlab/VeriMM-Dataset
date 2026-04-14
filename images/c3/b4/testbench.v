`timescale 1ns/1ps

module sky130_fd_sc_lp__o31a_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sky130_fd_sc_lp__o31a dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .X(X)
    );
    task testcase001;

        begin
            test_num = 1;
            A1 = 0; A2 = 0; A3 = 0; B1 = 0;
            $display("Test %0d: A1=0, A2=0, A3=0, B1=0 (Logic Rule: A1=A2, X=A3)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A1 = 0; A2 = 0; A3 = 0; B1 = 1;
            $display("Test %0d: A1=0, A2=0, A3=0, B1=1 (Logic Rule: A1=A2, X=~A3)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A1 = 0; A2 = 0; A3 = 1; B1 = 0;
            $display("Test %0d: A1=0, A2=0, A3=1, B1=0 (Logic Rule: A1=A2, X=A3)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A1 = 0; A2 = 0; A3 = 1; B1 = 1;
            $display("Test %0d: A1=0, A2=0, A3=1, B1=1 (Logic Rule: A1=A2, X=~A3)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A1 = 0; A2 = 1; A3 = 0; B1 = 0;
            $display("Test %0d: A1=0, A2=1, A3=0, B1=0 (Logic Rule: A1=0, A2=1, X=0)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A1 = 0; A2 = 1; A3 = 0; B1 = 1;
            $display("Test %0d: A1=0, A2=1, A3=0, B1=1 (Logic Rule: A1=0, A2=1, X=~0)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A1 = 0; A2 = 1; A3 = 1; B1 = 0;
            $display("Test %0d: A1=0, A2=1, A3=1, B1=0 (Logic Rule: A1=0, A2=1, X=0)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A1 = 0; A2 = 1; A3 = 1; B1 = 1;
            $display("Test %0d: A1=0, A2=1, A3=1, B1=1 (Logic Rule: A1=0, A2=1, X=~0)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A1 = 1; A2 = 0; A3 = 0; B1 = 0;
            $display("Test %0d: A1=1, A2=0, A3=0, B1=0 (Logic Rule: A1=1, A2=0, X=1)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A1 = 1; A2 = 0; A3 = 0; B1 = 1;
            $display("Test %0d: A1=1, A2=0, A3=0, B1=1 (Logic Rule: A1=1, A2=0, X=~1)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            A1 = 1; A2 = 0; A3 = 1; B1 = 0;
            $display("Test %0d: A1=1, A2=0, A3=1, B1=0 (Logic Rule: A1=1, A2=0, X=1)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            A1 = 1; A2 = 0; A3 = 1; B1 = 1;
            $display("Test %0d: A1=1, A2=0, A3=1, B1=1 (Logic Rule: A1=1, A2=0, X=~1)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            A1 = 1; A2 = 1; A3 = 0; B1 = 0;
            $display("Test %0d: A1=1, A2=1, A3=0, B1=0 (Logic Rule: A1=A2, X=A3)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            A1 = 1; A2 = 1; A3 = 0; B1 = 1;
            $display("Test %0d: A1=1, A2=1, A3=0, B1=1 (Logic Rule: A1=A2, X=~A3)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            A1 = 1; A2 = 1; A3 = 1; B1 = 0;
            $display("Test %0d: A1=1, A2=1, A3=1, B1=0 (Logic Rule: A1=A2, X=A3)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            A1 = 1; A2 = 1; A3 = 1; B1 = 1;
            $display("Test %0d: A1=1, A2=1, A3=1, B1=1 (Logic Rule: A1=A2, X=~A3)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sky130_fd_sc_lp__o31a Testbench");
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
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
