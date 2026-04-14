`timescale 1ns/1ps

module magnitude_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire A_equal_to_B;
    wire A_greater_than_B;
    wire A_less_than_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    magnitude_comparator dut (
        .A(A),
        .B(B),
        .A_equal_to_B(A_equal_to_B),
        .A_greater_than_B(A_greater_than_B),
        .A_less_than_B(A_less_than_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=0, B=0 (Equality check - Zero)", test_num);
            A = 4'd0; B = 4'd0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=15, B=15 (Equality check - Max)", test_num);
            A = 4'd15; B = 4'd15;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=7, B=7 (Equality check - Mid)", test_num);
            A = 4'd7; B = 4'd7;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=8, B=0 (A > B - MSB difference)", test_num);
            A = 4'b1000; B = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=1, B=0 (A > B - LSB difference)", test_num);
            A = 4'b0001; B = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=15, B=0 (A > B - Max difference)", test_num);
            A = 4'd15; B = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=0, B=8 (A < B - MSB difference)", test_num);
            A = 4'b0000; B = 4'b1000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=0, B=1 (A < B - LSB difference)", test_num);
            A = 4'b0000; B = 4'b0001;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=0, B=15 (A < B - Max difference)", test_num);
            A = 4'd0; B = 4'd15;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=10, B=5 (Random check A > B)", test_num);
            A = 4'd10; B = 4'd5;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=3, B=12 (Random check A < B)", test_num);
            A = 4'd3; B = 4'd12;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A=9, B=6 (Random check A > B)", test_num);
            A = 4'd9; B = 4'd6;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("magnitude_comparator Testbench");
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
        input expected_A_equal_to_B;
        input expected_A_greater_than_B;
        input expected_A_less_than_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_equal_to_B === (expected_A_equal_to_B ^ A_equal_to_B ^ expected_A_equal_to_B) &&
                expected_A_greater_than_B === (expected_A_greater_than_B ^ A_greater_than_B ^ expected_A_greater_than_B) &&
                expected_A_less_than_B === (expected_A_less_than_B ^ A_less_than_B ^ expected_A_less_than_B)) begin
                $display("PASS");
                $display("  Outputs: A_equal_to_B=%b, A_greater_than_B=%b, A_less_than_B=%b",
                         A_equal_to_B, A_greater_than_B, A_less_than_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_equal_to_B=%b, A_greater_than_B=%b, A_less_than_B=%b",
                         expected_A_equal_to_B, expected_A_greater_than_B, expected_A_less_than_B);
                $display("  Got:      A_equal_to_B=%b, A_greater_than_B=%b, A_less_than_B=%b",
                         A_equal_to_B, A_greater_than_B, A_less_than_B);
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
