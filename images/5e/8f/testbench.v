`timescale 1ns/1ps

module comparator_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire a_eq_b;
    wire a_gt_b;
    wire a_lt_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator dut (
        .a(a),
        .b(b),
        .a_eq_b(a_eq_b),
        .a_gt_b(a_gt_b),
        .a_lt_b(a_lt_b)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=00, b=00 (Equal)", test_num);
        a = 2'b00; b = 2'b00;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=01, b=01 (Equal)", test_num);
        a = 2'b01; b = 2'b01;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=10, b=10 (Equal)", test_num);
        a = 2'b10; b = 2'b10;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=11, b=11 (Equal)", test_num);
        a = 2'b11; b = 2'b11;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=01, b=00 (a > b)", test_num);
        a = 2'b01; b = 2'b00;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=10, b=00 (a > b)", test_num);
        a = 2'b10; b = 2'b00;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=11, b=00 (a > b)", test_num);
        a = 2'b11; b = 2'b00;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=10, b=01 (a > b)", test_num);
        a = 2'b10; b = 2'b01;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=11, b=01 (a > b)", test_num);
        a = 2'b11; b = 2'b01;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=11, b=10 (a > b)", test_num);
        a = 2'b11; b = 2'b10;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=00, b=01 (a < b)", test_num);
        a = 2'b00; b = 2'b01;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=00, b=10 (a < b)", test_num);
        a = 2'b00; b = 2'b10;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=00, b=11 (a < b)", test_num);
        a = 2'b00; b = 2'b11;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=01, b=10 (a < b)", test_num);
        a = 2'b01; b = 2'b10;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=01, b=11 (a < b)", test_num);
        a = 2'b01; b = 2'b11;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=10, b=11 (a < b)", test_num);
        a = 2'b10; b = 2'b11;
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
        $display("comparator Testbench");
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
        input expected_a_eq_b;
        input expected_a_gt_b;
        input expected_a_lt_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_eq_b === (expected_a_eq_b ^ a_eq_b ^ expected_a_eq_b) &&
                expected_a_gt_b === (expected_a_gt_b ^ a_gt_b ^ expected_a_gt_b) &&
                expected_a_lt_b === (expected_a_lt_b ^ a_lt_b ^ expected_a_lt_b)) begin
                $display("PASS");
                $display("  Outputs: a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         a_eq_b, a_gt_b, a_lt_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         expected_a_eq_b, expected_a_gt_b, expected_a_lt_b);
                $display("  Got:      a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         a_eq_b, a_gt_b, a_lt_b);
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
