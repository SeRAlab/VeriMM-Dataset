`timescale 1ns/1ps

module carry_lookahead_adder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg cin;
    wire cout;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_lookahead_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 16'h0000;
            b = 16'h0000;
            cin = 0;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-in Only", test_num);
            a = 16'h0000;
            b = 16'h0000;
            cin = 1;
            #1;

            check_outputs(1'b0, 16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (No bit carries)", test_num);
            a = 16'h1234;
            b = 16'h4321;
            cin = 0;
            #1;

            check_outputs(1'b0, 16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Resulting in 0xFFFF", test_num);
            a = 16'hAAAA;
            b = 16'h5555;
            cin = 0;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry Across Nibbles", test_num);
            a = 16'h000F;
            b = 16'h0001;
            cin = 0;
            #1;

            check_outputs(1'b0, 16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max sum without Carry-out", test_num);
            a = 16'hFFFF;
            b = 16'h0000;
            cin = 0;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow to Carry-out (FFFF + 1)", test_num);
            a = 16'hFFFF;
            b = 16'h0000;
            cin = 1;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max inputs (FFFF + FFFF)", test_num);
            a = 16'hFFFF;
            b = 16'hFFFF;
            cin = 0;
            #1;

            check_outputs(1'b1, 16'hFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max inputs + Carry-in (FFFF + FFFF + 1)", test_num);
            a = 16'hFFFF;
            b = 16'hFFFF;
            cin = 1;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Propagation", test_num);
            a = 16'hA5A5;
            b = 16'h5A5B;
            cin = 0;

            #1;


            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Mixed Pattern", test_num);
            a = 16'h1234;
            b = 16'hABCD;
            cin = 0;

            #1;


            check_outputs(1'b0, 16'hBE01);
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
        testcase011();
        
        
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
        input [15:0] expected_sum;
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
