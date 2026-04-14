`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [99:0] a;
    reg [99:0] b;
    reg cin;
    wire [99:0] cout;
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
        .sum(sum)
    );
    task compute_expected;

        input [99:0] ia;
        input [99:0] ib;
        input icin;
        integer i;
        reg last_c;
        begin
            last_c = icin;
            for (i = 0; i < 100; i = i + 1) begin
                calc_sum[i] = ia[i] ^ ib[i] ^ last_c;
                last_c = (ia[i] & ib[i]) | (last_c & (ia[i] ^ ib[i]));
                calc_cout[i] = last_c;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            a = 100'h0; b = 100'h0; cin = 1'b0;
            compute_expected(a, b, cin);
            #1;

            check_outputs(calc_cout, calc_sum);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (1+1)", test_num);
            a = 100'h1; b = 100'h1; cin = 1'b0;
            compute_expected(a, b, cin);
            #1;

            check_outputs(calc_cout, calc_sum);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry Propagate Across All Bits (All Fs + 1)", test_num);
            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            b = 100'h0;
            cin = 1'b1;
            compute_expected(a, b, cin);
            #1;

            check_outputs(calc_cout, calc_sum);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits cin=0", test_num);
            a = 100'h5555555555555555555555555;
            b = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            cin = 1'b0;
            compute_expected(a, b, cin);
            #1;

            check_outputs(calc_cout, calc_sum);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits cin=1", test_num);
            a = 100'h5555555555555555555555555;
            b = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            cin = 1'b1;
            compute_expected(a, b, cin);
            #1;

            check_outputs(calc_cout, calc_sum);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values", test_num);
            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            b = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            cin = 1'b1;
            compute_expected(a, b, cin);
            #1;

            check_outputs(calc_cout, calc_sum);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 1", test_num);
            a = 100'h1234567890ABCDEF123456789;
            b = 100'hFEDCBA0987654321FEDCBA098;
            cin = 1'b0;
            compute_expected(a, b, cin);
            #1;

            check_outputs(calc_cout, calc_sum);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 2", test_num);
            a = 100'h00000FFFFF00000FFFFF00000;
            b = 100'h0000000000FFFFF00000FFFFF;
            cin = 1'b1;
            compute_expected(a, b, cin);
            #1;

            check_outputs(calc_cout, calc_sum);
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
        input [99:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%h, sum=%h",
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
