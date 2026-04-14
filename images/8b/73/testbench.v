`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd0; b = 4'd0; cin = 1'b0;
            $display("Test %0d: All Zeros (0 + 0 + 0)", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'd5; b = 4'd3; cin = 1'b0;
            $display("Test %0d: Simple Addition (5 + 3 + 0)", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'd5; b = 4'd3; cin = 1'b1;
            $display("Test %0d: Simple Addition with Carry-In (5 + 3 + 1)", test_num);
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'd15; b = 4'd15; cin = 1'b1;
            $display("Test %0d: Maximum Values (15 + 15 + 1)", test_num);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'd8; b = 4'd8; cin = 1'b0;
            $display("Test %0d: Carry-Out Boundary (8 + 8 + 0 = 16)", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'd10; b = 4'd5; cin = 1'b0;
            $display("Test %0d: Sum to 15 (10 + 5 + 0)", test_num);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'd10; b = 4'd5; cin = 1'b1;
            $display("Test %0d: Sum to 16 via Cin (10 + 5 + 1)", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'd12; b = 4'd7; cin = 1'b0;
            $display("Test %0d: Large Sum with Carry (12 + 7 + 0 = 19)", test_num);
            #1;

            check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 4'b1010; b = 4'b0101; cin = 1'b0;
            $display("Test %0d: Alternating Bits", test_num);
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 4'd0; b = 4'd0; cin = 1'b1;
            $display("Test %0d: Only Carry-In", test_num);
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
