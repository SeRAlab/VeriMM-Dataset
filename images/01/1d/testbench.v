`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire Cout;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000; B = 4'b0000; Cin = 1'b0;
        $display("Test Case %0d: All Zeros (0 + 0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b0101; B = 4'b0011; Cin = 1'b0;
        $display("Test Case %0d: Simple Addition (5 + 3 + 0)", test_num);
        #1;

        check_outputs(1'b0, 5'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b0101; B = 4'b0011; Cin = 1'b1;
        $display("Test Case %0d: Addition with Carry-in (5 + 3 + 1)", test_num);
        #1;

        check_outputs(1'b0, 5'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b1111; B = 4'b0000; Cin = 1'b0;
        $display("Test Case %0d: Max 4-bit value (15 + 0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1111; B = 4'b0000; Cin = 1'b1;
        $display("Test Case %0d: Boundary Overflow (15 + 0 + 1)", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1010; B = 4'b0110; Cin = 1'b0;
        $display("Test Case %0d: Carry Generation (10 + 6 + 0)", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b1111; B = 4'b1111; Cin = 1'b0;
        $display("Test Case %0d: Large Addition (15 + 15 + 0)", test_num);
        #1;

        check_outputs(1'b1, 5'd30);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b1111; B = 4'b1111; Cin = 1'b1;
        $display("Test Case %0d: Maximum Possible Sum (15 + 15 + 1)", test_num);
        #1;

        check_outputs(1'b1, 5'd31);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b1001; B = 4'b0110; Cin = 1'b0;
        $display("Test Case %0d: Bit Pattern 1 (9 + 6 + 0)", test_num);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b0110; B = 4'b1001; Cin = 1'b1;
        $display("Test Case %0d: Bit Pattern 2 (6 + 9 + 1)", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
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
        input expected_Cout;
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
