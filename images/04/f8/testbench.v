`timescale 1ns/1ps

module magnitude_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire A_eq_B;
    wire A_gt_B;
    wire A_lt_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    magnitude_comparator dut (
        .A(A),
        .B(B),
        .A_eq_B(A_eq_B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: A=00, B=00 (Equal)", test_num);
        A = 2'b00; B = 2'b00;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: A=01, B=01 (Equal)", test_num);
        A = 2'b01; B = 2'b01;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: A=10, B=10 (Equal)", test_num);
        A = 2'b10; B = 2'b10;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: A=11, B=11 (Equal)", test_num);
        A = 2'b11; B = 2'b11;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: A=01, B=00 (A > B)", test_num);
        A = 2'b01; B = 2'b00;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: A=10, B=00 (A > B)", test_num);
        A = 2'b10; B = 2'b00;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: A=11, B=00 (A > B)", test_num);
        A = 2'b11; B = 2'b00;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest %0d: A=10, B=01 (A > B)", test_num);
        A = 2'b10; B = 2'b01;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest %0d: A=11, B=01 (A > B)", test_num);
        A = 2'b11; B = 2'b01;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest %0d: A=11, B=10 (A > B)", test_num);
        A = 2'b11; B = 2'b10;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("\nTest %0d: A=00, B=01 (A < B)", test_num);
        A = 2'b00; B = 2'b01;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("\nTest %0d: A=00, B=10 (A < B)", test_num);
        A = 2'b00; B = 2'b10;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("\nTest %0d: A=00, B=11 (A < B)", test_num);
        A = 2'b00; B = 2'b11;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("\nTest %0d: A=01, B=10 (A < B)", test_num);
        A = 2'b01; B = 2'b10;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("\nTest %0d: A=01, B=11 (A < B)", test_num);
        A = 2'b01; B = 2'b11;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("\nTest %0d: A=10, B=11 (A < B)", test_num);
        A = 2'b10; B = 2'b11;
        #1;

        check_outputs(0, 0, 1);
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
        input expected_A_eq_B;
        input expected_A_gt_B;
        input expected_A_lt_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_eq_B === (expected_A_eq_B ^ A_eq_B ^ expected_A_eq_B) &&
                expected_A_gt_B === (expected_A_gt_B ^ A_gt_B ^ expected_A_gt_B) &&
                expected_A_lt_B === (expected_A_lt_B ^ A_lt_B ^ expected_A_lt_B)) begin
                $display("PASS");
                $display("  Outputs: A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         A_eq_B, A_gt_B, A_lt_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         expected_A_eq_B, expected_A_gt_B, expected_A_lt_B);
                $display("  Got:      A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         A_eq_B, A_gt_B, A_lt_B);
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
