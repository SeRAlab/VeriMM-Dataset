`timescale 1ns/1ps

module my_or4_1_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_or4_1 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .X(X)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs Low", test_num);
            A = 0; B = 0; C = 0; D = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: D High", test_num);
            A = 0; B = 0; C = 0; D = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: C High", test_num);
            A = 0; B = 0; C = 1; D = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: C and D High", test_num);
            A = 0; B = 0; C = 1; D = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: B High", test_num);
            A = 0; B = 1; C = 0; D = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: B and D High", test_num);
            A = 0; B = 1; C = 0; D = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: B and C High", test_num);
            A = 0; B = 1; C = 1; D = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: B, C, and D High", test_num);
            A = 0; B = 1; C = 1; D = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: A High", test_num);
            A = 1; B = 0; C = 0; D = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: A and D High", test_num);
            A = 1; B = 0; C = 0; D = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: A and C High", test_num);
            A = 1; B = 0; C = 1; D = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: A, C, and D High", test_num);
            A = 1; B = 0; C = 1; D = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Testcase %0d: A and B High", test_num);
            A = 1; B = 1; C = 0; D = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Testcase %0d: A, B, and D High", test_num);
            A = 1; B = 1; C = 0; D = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Testcase %0d: A, B, and C High", test_num);
            A = 1; B = 1; C = 1; D = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Testcase %0d: All inputs High", test_num);
            A = 1; B = 1; C = 1; D = 1;
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
        $display("my_or4_1 Testbench");
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
