`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg cin;
    wire cout;
    wire [2:0] sum;

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
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero (0 + 0 + 0)", test_num);
        a = 3'd0; b = 3'd0; cin = 1'b0;
        #1;

        check_outputs(1'b0, 3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only carry-in (0 + 0 + 1)", test_num);
        a = 3'd0; b = 3'd0; cin = 1'b1;
        #1;

        check_outputs(1'b0, 3'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple addition without carry-out (2 + 3 + 0)", test_num);
        a = 3'd2; b = 3'd3; cin = 1'b0;
        #1;

        check_outputs(1'b0, 3'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum sum without carry-out (3 + 4 + 0)", test_num);
        a = 3'd3; b = 3'd4; cin = 1'b0;
        #1;

        check_outputs(1'b0, 3'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum carry-out (4 + 4 + 0)", test_num);
        a = 3'd4; b = 3'd4; cin = 1'b0;
        #1;

        check_outputs(1'b1, 3'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with carry-in and carry-out (5 + 2 + 1)", test_num);
        a = 3'd5; b = 3'd2; cin = 1'b1;
        #1;

        check_outputs(1'b1, 3'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max values resulting in sum=7, cout=1 (7 + 7 + 1)", test_num);
        a = 3'd7; b = 3'd7; cin = 1'b1;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed bits (6 + 1 + 0)", test_num);
        a = 3'b110; b = 3'b001; cin = 1'b0;
        #1;

        check_outputs(1'b0, 3'b111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Resulting in power of 2 (1 + 0 + 1)", test_num);
        a = 3'd1; b = 3'd0; cin = 1'b1;
        #1;

        check_outputs(1'b0, 3'd2);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow check (7 + 1 + 0)", test_num);
        a = 3'd7; b = 3'd1; cin = 1'b0;
        #1;

        check_outputs(1'b1, 3'd0);
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
        input [2:0] expected_sum;
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
