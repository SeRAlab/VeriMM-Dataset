`timescale 1ns/1ps

module comparator_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire A_EQ_B;
    wire A_GT_B;
    wire A_LT_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_4bit dut (
        .A(A),
        .B(B),
        .A_EQ_B(A_EQ_B),
        .A_GT_B(A_GT_B),
        .A_LT_B(A_LT_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros (A=0, B=0) -> Expected: EQ=1", test_num);
            A = 4'b0000;
            B = 4'b0000;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones (A=15, B=15) -> Expected: EQ=1", test_num);
            A = 4'b1111;
            B = 4'b1111;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=1, B=0 -> Expected: GT=1", test_num);
            A = 4'd1;
            B = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=1 -> Expected: LT=1", test_num);
            A = 4'd0;
            B = 4'd1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=15, B=0 -> Expected: GT=1", test_num);
            A = 4'd15;
            B = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=15 -> Expected: LT=1", test_num);
            A = 4'd0;
            B = 4'd15;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=10, B=5 -> Expected: GT=1", test_num);
            A = 4'd10;
            B = 4'd5;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=5, B=10 -> Expected: LT=1", test_num);
            A = 4'd5;
            B = 4'd10;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary crossing (A=8, B=7) -> Expected: GT=1", test_num);
            A = 4'b1000;
            B = 4'b0111;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random match (A=9, B=9) -> Expected: EQ=1", test_num);
            A = 4'd9;
            B = 4'd9;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_4bit Testbench");
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
        input expected_A_EQ_B;
        input expected_A_GT_B;
        input expected_A_LT_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_EQ_B === (expected_A_EQ_B ^ A_EQ_B ^ expected_A_EQ_B) &&
                expected_A_GT_B === (expected_A_GT_B ^ A_GT_B ^ expected_A_GT_B) &&
                expected_A_LT_B === (expected_A_LT_B ^ A_LT_B ^ expected_A_LT_B)) begin
                $display("PASS");
                $display("  Outputs: A_EQ_B=%b, A_GT_B=%b, A_LT_B=%b",
                         A_EQ_B, A_GT_B, A_LT_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_EQ_B=%b, A_GT_B=%b, A_LT_B=%b",
                         expected_A_EQ_B, expected_A_GT_B, expected_A_LT_B);
                $display("  Got:      A_EQ_B=%b, A_GT_B=%b, A_LT_B=%b",
                         A_EQ_B, A_GT_B, A_LT_B);
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
