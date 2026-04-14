`timescale 1ns/1ps

module booth_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Positive * Positive (2 * 3)", test_num);
            A = 4'sd2;
            B = 4'sd3;
            #1;

            check_outputs(8'sd6);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Positive * Positive Max (7 * 7)", test_num);
            A = 4'sd7;
            B = 4'sd7;
            #1;

            check_outputs(8'sd49);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Positive * Negative (4 * -2)", test_num);
            A = 4'sd4;
            B = -4'sd2;
            #1;

            check_outputs(-8'sd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Positive * Negative (-1) (5 * -1)", test_num);
            A = 4'sd5;
            B = -4'sd1;
            #1;

            check_outputs(-8'sd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Negative * Positive (-5 * 2)", test_num);
            A = -4'sd5;
            B = 4'sd2;
            #1;

            check_outputs(-8'sd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Negative * Positive (-8 * 7)", test_num);
            A = -4'sd8;
            B = 4'sd7;
            #1;

            check_outputs(-8'sd56);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Negative * Negative (-3 * -4)", test_num);
            A = -4'sd3;
            B = -4'sd4;
            #1;

            check_outputs(8'sd12);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Negative * Negative Max (-8 * -8)", test_num);
            A = -4'sd8;
            B = -4'sd8;
            #1;

            check_outputs(8'sd64);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Zero Multiplication (0 * -5)", test_num);
            A = 4'sd0;
            B = -4'sd5;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Zero Multiplication (6 * 0)", test_num);
            A = 4'sd6;
            B = 4'sd0;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Identity Multiplication (1 * -8)", test_num);
            A = 4'sd1;
            B = -4'sd8;
            #1;

            check_outputs(-8'sd8);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Symmetry Test (-2 * 3 vs 3 * -2)", test_num);
            A = -4'sd2;
            B = 4'sd3;
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_multiplier Testbench");
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
