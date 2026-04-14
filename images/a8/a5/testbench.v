`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [99:0] a;
    reg [99:0] b;
    reg cin;
    wire [99:0] cout;
    wire [99:0] final_output;
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
        .cout(cout),
        .final_output(final_output),
        .sum(sum)
    );
    task calculate_expected;

        input [99:0] a_in;
        input [99:0] b_in;
        input cin_in;
        output [99:0] e_cout;
        output [99:0] e_sum;
        output [99:0] e_final;
        reg [100:0] c;
        integer i;
        begin
            c[0] = cin_in;
            for (i = 0; i < 100; i = i + 1) begin
                e_sum[i] = a_in[i] ^ b_in[i] ^ c[i];
                e_cout[i] = (a_in[i] & b_in[i]) | (c[i] & (a_in[i] ^ b_in[i]));
                c[i+1] = e_cout[i];
            end
            e_final = e_sum + (e_cout << 1);
        end
        endtask

    task testcase001;

        reg [99:0] ec, ef, es;
        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            a = 100'd0; b = 100'd0; cin = 0;
            calculate_expected(a, b, cin, ec, es, ef);
            #1;

            check_outputs(ec, ef, es);
        end
        endtask

    task testcase002;

        reg [99:0] ec, ef, es;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in only", test_num);
            a = 100'd0; b = 100'd0; cin = 1;
            calculate_expected(a, b, cin, ec, es, ef);
            #1;

            check_outputs(ec, ef, es);
        end
        endtask

    task testcase003;

        reg [99:0] ec, ef, es;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple small values", test_num);
            a = 100'h5; b = 100'hA; cin = 0;
            calculate_expected(a, b, cin, ec, es, ef);
            #1;

            check_outputs(ec, ef, es);
        end
        endtask

    task testcase004;

        reg [99:0] ec, ef, es;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Worst-case carry propagation (All 1s + cin)", test_num);
            a = {100{1'b1}}; b = 100'd0; cin = 1;
            calculate_expected(a, b, cin, ec, es, ef);
            #1;

            check_outputs(ec, ef, es);
        end
        endtask

    task testcase005;

        reg [99:0] ec, ef, es;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns", test_num);
            a = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            b = 100'h5555555555555555555555555;
            cin = 0;
            calculate_expected(a, b, cin, ec, es, ef);
            #1;

            check_outputs(ec, ef, es);
        end
        endtask

    task testcase006;

        reg [99:0] ec, ef, es;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns with carry-in", test_num);
            a = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            b = 100'h5555555555555555555555555;
            cin = 1;
            calculate_expected(a, b, cin, ec, es, ef);
            #1;

            check_outputs(ec, ef, es);
        end
        endtask

    task testcase007;

        reg [99:0] ec, ef, es;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern", test_num);
            a = 100'h6A09E667F3BCC908B2FB1366E;
            b = 100'hBB67AE8584CAA73B25742D72B;
            cin = 0;
            calculate_expected(a, b, cin, ec, es, ef);
            #1;

            check_outputs(ec, ef, es);
        end
        endtask

    task testcase008;

        reg [99:0] ec, ef, es;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum possible values", test_num);
            a = {100{1'b1}}; b = {100{1'b1}}; cin = 1;
            calculate_expected(a, b, cin, ec, es, ef);
            #1;

            check_outputs(ec, ef, es);
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
        input [99:0] expected_final_output;
        input [99:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, final_output=%h, sum=%h",
                         cout, final_output, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, final_output=%h, sum=%h",
                         expected_cout, expected_final_output, expected_sum);
                $display("  Got:      cout=%h, final_output=%h, sum=%h",
                         cout, final_output, sum);
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
