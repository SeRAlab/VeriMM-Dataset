`timescale 1ns/1ps

module comparator_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire A_gt_B;
    wire A_lt_B;
    wire Equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_2bit dut (
        .A(A),
        .B(B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B),
        .Equal(Equal)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 2'b00; B = 2'b00;
        $display("Testcase %0d: A=%b, B=%b (Expect: Equal=1)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 2'b01; B = 2'b00;
        $display("Testcase %0d: A=%b, B=%b (Expect: A_gt_B=1)", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 2'b00; B = 2'b10;
        $display("Testcase %0d: A=%b, B=%b (Expect: A_lt_B=1)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 2'b11; B = 2'b11;
        $display("Testcase %0d: A=%b, B=%b (Expect: Equal=1)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 2'b11; B = 2'b01;
        $display("Testcase %0d: A=%b, B=%b (Expect: A_gt_B=1)", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 2'b01; B = 2'b11;
        $display("Testcase %0d: A=%b, B=%b (Expect: A_lt_B=1)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 2'b10; B = 2'b10;
        $display("Testcase %0d: A=%b, B=%b (Expect: Equal=1)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 2'b10; B = 2'b01;
        $display("Testcase %0d: A=%b, B=%b (Expect: A_gt_B=1)", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 2'b01; B = 2'b10;
        $display("Testcase %0d: A=%b, B=%b (Expect: A_lt_B=1)", test_num, A, B);
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
        $display("comparator_2bit Testbench");
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
        input expected_A_gt_B;
        input expected_A_lt_B;
        input expected_Equal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_gt_B === (expected_A_gt_B ^ A_gt_B ^ expected_A_gt_B) &&
                expected_A_lt_B === (expected_A_lt_B ^ A_lt_B ^ expected_A_lt_B) &&
                expected_Equal === (expected_Equal ^ Equal ^ expected_Equal)) begin
                $display("PASS");
                $display("  Outputs: A_gt_B=%b, A_lt_B=%b, Equal=%b",
                         A_gt_B, A_lt_B, Equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_gt_B=%b, A_lt_B=%b, Equal=%b",
                         expected_A_gt_B, expected_A_lt_B, expected_Equal);
                $display("  Got:      A_gt_B=%b, A_lt_B=%b, Equal=%b",
                         A_gt_B, A_lt_B, Equal);
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
