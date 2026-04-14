`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [99:0] a;
    reg [99:0] b;
    reg cin;
    wire cout;
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
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition", test_num);
            a = 100'h0000000000000000000000005;
            b = 100'h000000000000000000000000A;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 100'h000000000000000000000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in Only", test_num);
            a = 100'h0;
            b = 100'h0;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 100'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow / Carry-out", test_num);

            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            b = 100'h0000000000000000000000001;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 100'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Patterns", test_num);

            a = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            b = 100'h5555555555555555555555555;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Sum (All ones with carry-out)", test_num);

            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            b = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Half-range Carry", test_num);

            a = 100'h000000000000A000000000000;
            b = 100'h0000000000006000000000000;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 100'h0000000000010000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zeros", test_num);
            a = 100'h0;
            b = 100'h0;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 100'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry Propagation Ripple Test", test_num);

            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFE;
            b = 100'h0;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
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
        input expected_cout;
        input [99:0] expected_sum;
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
