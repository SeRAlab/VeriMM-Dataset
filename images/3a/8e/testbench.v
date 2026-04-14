`timescale 1ns/1ps

module lu_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] matrix_a;
    wire [15:0] lower;
    wire [15:0] upper;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lu_decomposition dut (
        .matrix_a(matrix_a),
        .lower(lower),
        .upper(upper)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Matrix", test_num);
        matrix_a = 16'h1001;
        #1;

        check_outputs(16'h1001, 16'h1001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Integer LU", test_num);
        matrix_a = 16'h2246;
        #1;

        check_outputs(16'h1021, 16'h2202);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero in a21", test_num);
        matrix_a = 16'h4507;
        #1;

        check_outputs(16'h1001, 16'h4507);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative u22 result", test_num);
        matrix_a = 16'h1523;
        #1;

        check_outputs(16'h1021, 16'h1509);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiples", test_num);
        matrix_a = 16'h3195;
        #1;

        check_outputs(16'h1031, 16'h3102);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: u22 is zero", test_num);
        matrix_a = 16'h2448;
        #1;

        check_outputs(16'h1021, 16'h2400);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Integer Truncation", test_num);
        matrix_a = 16'h3258;
        #1;

        check_outputs(16'h1011, 16'h3206);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lu_decomposition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_lower;
        input [15:0] expected_upper;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lower === (expected_lower ^ lower ^ expected_lower) &&
                expected_upper === (expected_upper ^ upper ^ expected_upper)) begin
                $display("PASS");
                $display("  Outputs: lower=%h, upper=%h",
                         lower, upper);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lower=%h, upper=%h",
                         expected_lower, expected_upper);
                $display("  Got:      lower=%h, upper=%h",
                         lower, upper);
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
