`timescale 1ns/1ps

module carry_skip_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire Cout;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_skip_adder dut (
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
        $display("Test %0d: Zero Addition - A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'h7; B = 4'h8; Cin = 1'b0;
        $display("Test %0d: Max Sum No Carry Out - A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'hF; B = 4'h1; Cin = 1'b0;
        $display("Test %0d: Ripple Carry Out - A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        A = 4'b1010; B = 4'b0101; Cin = 1'b0;
        $display("Test %0d: Skip Condition Active (Cin=0) - A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        A = 4'b1010; B = 4'b0101; Cin = 1'b1;
        $display("Test %0d: Skip Condition Active (Cin=1) - A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        A = 4'b1111; B = 4'b0000; Cin = 1'b1;
        $display("Test %0d: Skip Condition Active (Alt) - A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'h3; B = 4'h3; Cin = 1'b1;
        $display("Test %0d: Small Values with Cin - A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
        #1;

        check_outputs(1'b0, 4'h7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'hF; B = 4'hF; Cin = 1'b1;
        $display("Test %0d: Maximum Inputs - A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_skip_adder Testbench");
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
        input expected_Cout;
        input [3:0] expected_Sum;
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
