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
        $display("\nTestcase %0d: 0 + 0 + 0", test_num);
        A = 4'b0000; B = 4'b0000; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: 2 + 2 + 1", test_num);
        A = 4'd2; B = 4'd2; Cin = 1'b1;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: 7 + 8 + 0", test_num);
        A = 4'd7; B = 4'd8; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: 8 + 8 + 0", test_num);
        A = 4'b1000; B = 4'b1000; Cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: 10 + 5 + 0 (Skip Logic P=1111)", test_num);
        A = 4'b1010; B = 4'b0101; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: 10 + 5 + 1 (Skip Logic Cin -> Cout)", test_num);
        A = 4'b1010; B = 4'b0101; Cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: 15 + 1 + 0", test_num);
        A = 4'b1111; B = 4'b0001; Cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: 15 + 15 + 1", test_num);
        A = 4'b1111; B = 4'b1111; Cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: 12 + 3 + 1", test_num);
        A = 4'b1100; B = 4'b0011; Cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: 6 + 9 + 0", test_num);
        A = 4'b0110; B = 4'b1001; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
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
