`timescale 1ns/1ps

module vector_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire Overflow;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vector_adder dut (
        .A(A),
        .B(B),
        .Overflow(Overflow),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0;
        B = 4'd0;
        $display("Testcase %0d: Adding zero to zero", test_num);
        #1;

        check_outputs(1'b0, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd5;
        B = 4'd3;
        $display("Testcase %0d: Simple addition without overflow", test_num);
        #1;

        check_outputs(1'b0, 5'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd15;
        B = 4'd0;
        $display("Testcase %0d: Maximum 4-bit value plus zero", test_num);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd8;
        B = 4'd7;
        $display("Testcase %0d: Boundary case - sum equals 15 (No Overflow)", test_num);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd8;
        B = 4'd8;
        $display("Testcase %0d: Boundary case - sum equals 16 (Overflow)", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd15;
        B = 4'd1;
        $display("Testcase %0d: Overflow with max A and min non-zero B", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd10;
        B = 4'd10;
        $display("Testcase %0d: Addition with result 20 (Overflow)", test_num);
        #1;

        check_outputs(1'b1, 5'd20);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd15;
        B = 4'd15;
        $display("Testcase %0d: Maximum possible sum (30, Overflow)", test_num);
        #1;

        check_outputs(1'b1, 5'd30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vector_adder Testbench");
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
        input expected_Overflow;
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Overflow=%b, Sum=%h",
                         Overflow, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Overflow=%b, Sum=%h",
                         expected_Overflow, expected_Sum);
                $display("  Got:      Overflow=%b, Sum=%h",
                         Overflow, Sum);
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
