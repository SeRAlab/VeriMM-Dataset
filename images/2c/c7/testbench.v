`timescale 1ns/1ps

module carry_lookahead_adder_tb;

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
    carry_lookahead_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All zeros (0 + 0 + 0)", test_num);
            A = 4'd0; B = 4'd0; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Small numbers without carry (2 + 3 + 0)", test_num);
            A = 4'd2; B = 4'd3; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Generate carry-out at MSB (8 + 8 + 0)", test_num);
            A = 4'd8; B = 4'd8; Cin = 1'b0;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Addition with Cin only (0 + 0 + 1)", test_num);
            A = 4'd0; B = 4'd0; Cin = 1'b1;
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Max values with Cin (15 + 15 + 1)", test_num);
            A = 4'd15; B = 4'd15; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Propagate carry through all stages (15 + 0 + 1)", test_num);
            A = 4'b1111; B = 4'b0000; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Partial carry generation (7 + 1 + 0)", test_num);
            A = 4'd7; B = 4'd1; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Alternating bits (10 + 5 + 0)", test_num);
            A = 4'b1010; B = 4'b0101; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Alternating bits with carry (10 + 5 + 1)", test_num);
            A = 4'b1010; B = 4'b0101; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Random bit pattern (12 + 7 + 0)", test_num);
            A = 4'd12; B = 4'd7; Cin = 1'b0;
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
        $display("carry_lookahead_adder Testbench");
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
