`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg sub;
    wire cout;
    wire overflow;
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
        .sub(sub),
        .cout(cout),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd2; b = 4'd3; sub = 0; cin = 0;
            #1;

            check_outputs(1'b0, 1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'hF; b = 4'h1; sub = 0; cin = 0;
            #1;

            check_outputs(1'b1, 1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'd1; b = 4'd1; sub = 0; cin = 1;
            #1;

            check_outputs(1'b0, 1'b0, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'd7; b = 4'd1; sub = 0; cin = 0;
            #1;

            check_outputs(1'b0, 1'b1, 4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'b1000; b = 4'b1111; sub = 0; cin = 0;
            #1;

            check_outputs(1'b1, 1'b1, 4'b0111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'd5; b = 4'd2; sub = 1; cin = 0;
            #1;

            check_outputs(1'b1, 1'b0, 4'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'd2; b = 4'd5; sub = 1; cin = 0;
            #1;

            check_outputs(1'b0, 1'b0, 4'hD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'b1000; b = 4'b0001; sub = 1; cin = 0;
            #1;

            check_outputs(1'b1, 1'b1, 4'h7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 4'd7; b = 4'b1110; sub = 1; cin = 0;
            #1;

            check_outputs(1'b0, 1'b1, 4'h9);
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
        input expected_overflow;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, overflow=%b, sum=%h",
                         cout, overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, overflow=%b, sum=%h",
                         expected_cout, expected_overflow, expected_sum);
                $display("  Got:      cout=%b, overflow=%b, sum=%h",
                         cout, overflow, sum);
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
