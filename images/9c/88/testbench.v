`timescale 1ns/1ps

module adder_4bit_tb;

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
    adder_4bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros (0 + 0 + 0)", test_num);
        A = 4'b0000;
        B = 4'b0000;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Simple addition without carry (5 + 3 + 0)", test_num);
        A = 4'd5;
        B = 4'd3;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Simple addition with Cin (5 + 3 + 1)", test_num);
        A = 4'd5;
        B = 4'd3;
        Cin = 1'b1;
        #1;

        check_outputs(1'b0, 4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Maximum sum without Cout (7 + 8 + 0)", test_num);
        A = 4'd7;
        B = 4'd8;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Result resulting in exact Cout (15 + 1 + 0)", test_num);
        A = 4'd15;
        B = 4'd1;
        Cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Result resulting in Cout and Sum (15 + 2 + 0)", test_num);
        A = 4'd15;
        B = 4'd2;
        Cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: All ones with Cin=0 (15 + 15 + 0)", test_num);
        A = 4'b1111;
        B = 4'b1111;
        Cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'b1110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: All ones with Cin=1 (15 + 15 + 1)", test_num);
        A = 4'b1111;
        B = 4'b1111;
        Cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Alternating bits (10 + 5 + 0)", test_num);
        A = 4'b1010;
        B = 4'b0101;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Mixed bits resulting in carry (12 + 6 + 1)", test_num);
        A = 4'd12;
        B = 4'd6;
        Cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_4bit Testbench");
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
