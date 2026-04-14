`timescale 1ns/1ps

module comparator_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_2bit dut (
        .A(A),
        .B(B),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 2'b00; B = 2'b00;
        $display("Test %0d: A=%b, B=%b (Expected EQ)", test_num, A, B);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 2'b00; B = 2'b01;
        $display("Test %0d: A=%b, B=%b (Expected LT)", test_num, A, B);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 2'b00; B = 2'b10;
        $display("Test %0d: A=%b, B=%b (Expected LT)", test_num, A, B);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 2'b00; B = 2'b11;
        $display("Test %0d: A=%b, B=%b (Expected LT)", test_num, A, B);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 2'b01; B = 2'b00;
        $display("Test %0d: A=%b, B=%b (Expected GT)", test_num, A, B);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 2'b01; B = 2'b01;
        $display("Test %0d: A=%b, B=%b (Expected EQ)", test_num, A, B);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 2'b01; B = 2'b10;
        $display("Test %0d: A=%b, B=%b (Expected LT)", test_num, A, B);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 2'b01; B = 2'b11;
        $display("Test %0d: A=%b, B=%b (Expected LT)", test_num, A, B);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 2'b10; B = 2'b00;
        $display("Test %0d: A=%b, B=%b (Expected GT)", test_num, A, B);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 2'b10; B = 2'b01;
        $display("Test %0d: A=%b, B=%b (Expected GT)", test_num, A, B);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        A = 2'b10; B = 2'b10;
        $display("Test %0d: A=%b, B=%b (Expected EQ)", test_num, A, B);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        A = 2'b10; B = 2'b11;
        $display("Test %0d: A=%b, B=%b (Expected LT)", test_num, A, B);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        A = 2'b11; B = 2'b00;
        $display("Test %0d: A=%b, B=%b (Expected GT)", test_num, A, B);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        A = 2'b11; B = 2'b01;
        $display("Test %0d: A=%b, B=%b (Expected GT)", test_num, A, B);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        A = 2'b11; B = 2'b10;
        $display("Test %0d: A=%b, B=%b (Expected GT)", test_num, A, B);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        A = 2'b11; B = 2'b11;
        $display("Test %0d: A=%b, B=%b (Expected EQ)", test_num, A, B);
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
