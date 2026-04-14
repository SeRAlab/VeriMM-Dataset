`timescale 1ns/1ps

module comparator_2bit_tb;

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
    comparator_2bit dut (
        .A(A),
        .B(B),
        .A_eq_B(A_eq_B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B)
    );
    task testcase001;

    begin
        A = 2'b00; B = 2'b00;
        $display("Test 001: A=0, B=0");
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        A = 2'b11; B = 2'b11;
        $display("Test 002: A=3, B=3");
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        A = 2'b10; B = 2'b01;
        $display("Test 003: A=2, B=1");
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        A = 2'b11; B = 2'b10;
        $display("Test 004: A=3, B=2");
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        A = 2'b11; B = 2'b00;
        $display("Test 005: A=3, B=0");
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        A = 2'b01; B = 2'b10;
        $display("Test 006: A=1, B=2");
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        A = 2'b00; B = 2'b01;
        $display("Test 007: A=0, B=1");
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        A = 2'b00; B = 2'b11;
        $display("Test 008: A=0, B=3");
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        A = 2'b01; B = 2'b01;
        $display("Test 009: A=1, B=1");
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase010;

    begin
        A = 2'b10; B = 2'b10;
        $display("Test 010: A=2, B=2");
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
