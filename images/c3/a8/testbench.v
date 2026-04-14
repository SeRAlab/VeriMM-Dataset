`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg areset;
    wire C;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .areset(areset),
        .C(C),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Asynchronous Reset Active");
        areset = 1;
        A = 4'b0101;
        B = 4'b0010;
        #10;

        #1;


        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Basic Addition (2 + 3 = 5)");
        areset = 1; #5; areset = 0;
        A = 4'b0010;
        B = 4'b0011;
        #10;
        #1;

        check_outputs(1'b0, 4'b0101);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Addition with Carry Out (-1 + 1 = 0)");
        areset = 1; #5; areset = 0;
        A = 4'b1111;
        B = 4'b0001;
        #10;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Maximum Positive Sum (7 + 7 = 14)");
        areset = 1; #5; areset = 0;
        A = 4'b0111;
        B = 4'b0111;
        #10;
        #1;

        check_outputs(1'b0, 4'b1110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Negative Addition (-1 + -1 = -2)");
        areset = 1; #5; areset = 0;
        A = 4'b1111;
        B = 4'b1111;
        #10;
        #1;

        check_outputs(1'b1, 4'b1110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Zero Addition (0 + 0)");
        areset = 1; #5; areset = 0;
        A = 4'b0000;
        B = 4'b0000;
        #10;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Minimum Values (-8 + -8)");
        areset = 1; #5; areset = 0;
        A = 4'b1000;
        B = 4'b1000;
        #10;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Mixed Signs (-5 + 3 = -2)");
        areset = 1; #5; areset = 0;
        A = 4'b1011;
        B = 4'b0011;
        #10;
        #1;

        check_outputs(1'b0, 4'b1110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_carry_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_C;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%b, S=%h",
                         C, S);
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
