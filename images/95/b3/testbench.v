`timescale 1ns/1ps

module comparator_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_4bit dut (
        .a(a),
        .b(b),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd0; b = 4'd0;
        $display("Testcase %0d: a=%d, b=%d (Expect EQ)", test_num, a, b);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd15; b = 4'd15;
        $display("Testcase %0d: a=%d, b=%d (Expect EQ)", test_num, a, b);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd15; b = 4'd0;
        $display("Testcase %0d: a=%d, b=%d (Expect GT)", test_num, a, b);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd0; b = 4'd15;
        $display("Testcase %0d: a=%d, b=%d (Expect LT)", test_num, a, b);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd8; b = 4'd7;
        $display("Testcase %0d: a=%d, b=%d (Expect GT)", test_num, a, b);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd7; b = 4'd8;
        $display("Testcase %0d: a=%d, b=%d (Expect LT)", test_num, a, b);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd5; b = 4'd5;
        $display("Testcase %0d: a=%d, b=%d (Expect EQ)", test_num, a, b);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd10; b = 4'd2;
        $display("Testcase %0d: a=%d, b=%d (Expect GT)", test_num, a, b);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'd3; b = 4'd12;
        $display("Testcase %0d: a=%d, b=%d (Expect LT)", test_num, a, b);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'd1; b = 4'd1;
        $display("Testcase %0d: a=%d, b=%d (Expect EQ)", test_num, a, b);
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
        input expected_eq;
        input expected_gt;
        input expected_lt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt=%b, lt=%b",
                         expected_eq, expected_gt, expected_lt);
                $display("  Got:      eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
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
