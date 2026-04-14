`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire carry_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .a(a),
        .b(b),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0", test_num);
            a = 4'b0000;
            b = 4'b0000;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition (1 + 1)", test_num);
            a = 4'b0001;
            b = 4'b0001;
            #1;

            check_outputs(1'b0, 4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum without carry (7 + 8)", test_num);
            a = 4'b0111;
            b = 4'b1000;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow carry-out (15 + 1)", test_num);
            a = 4'b1111;
            b = 4'b0001;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible inputs (15 + 15)", test_num);
            a = 4'b1111;
            b = 4'b1111;
            #1;

            check_outputs(1'b1, 4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (10 + 5)", test_num);
            a = 4'b1010;
            b = 4'b0101;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation check (13 + 3)", test_num);
            a = 4'b1101;
            b = 4'b0011;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random values (6 + 7)", test_num);
            a = 4'b0110;
            b = 4'b0111;
            #1;

            check_outputs(1'b0, 4'b1101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_carry_adder Testbench");
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
        input expected_carry_out;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
