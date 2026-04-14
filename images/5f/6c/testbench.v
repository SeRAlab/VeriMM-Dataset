`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [99:0] a;
    reg [99:0] b;
    reg cin;
    reg in;
    wire [99:0] cout;
    wire out;
    wire [99:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .in(in),
        .cout(cout),
        .out(out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 100'd0;
            b = 100'd0;
            cin = 0;
            in = 1;
            #1;

            check_outputs(100'h0, 1'b0, 100'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            a = {100{1'b1}};
            b = 100'd0;
            cin = 1;
            in = 1;
            #1;

            check_outputs({100{1'b1}}, 1'b0, 100'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;



            a = {1'b0, {99{1'b1}}};
            b = 100'd0;
            cin = 0;
            in = 0;



            #1;




            check_outputs(100'h0, 1'b1, {1'b0, {99{1'b1}}});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 100'h1;
            b = 100'h1;
            cin = 0;
            in = 1;

            #1;


            check_outputs(100'h1, 1'b0, 100'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = {1'b1, 99'd0};
            b = 100'd0;
            cin = 0;
            in = 1;
            #1;

            check_outputs(100'h0, 1'b1, {1'b1, 99'd0});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            a = {50{2'b01}};
            b = {50{2'b10}};
            cin = 1;
            in = 0;
            #1;

            check_outputs({100{1'b1}}, 1'b0, 100'h0);
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
        input [99:0] expected_cout;
        input expected_out;
        input [99:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, out=%b, sum=%h",
                         cout, out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, out=%b, sum=%h",
                         expected_cout, expected_out, expected_sum);
                $display("  Got:      cout=%h, out=%b, sum=%h",
                         cout, out, sum);
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
