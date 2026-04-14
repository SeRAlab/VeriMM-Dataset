`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire carry_out;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .A(A),
        .B(B),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'd0;
            B = 8'd0;
            $display("Test Case %0d: Addition of zeros", test_num);
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'd15;
            B = 8'd32;
            $display("Test Case %0d: Small numbers without carry", test_num);
            #1;

            check_outputs(1'b0, 8'd47);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'd127;
            B = 8'd128;
            $display("Test Case %0d: Summing to maximum 8-bit value (255)", test_num);
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'd255;
            B = 8'd1;
            $display("Test Case %0d: Minimum carry-out scenario", test_num);
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'd255;
            B = 8'd255;
            $display("Test Case %0d: Addition of maximum possible values", test_num);
            #1;

            check_outputs(1'b1, 8'd254);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'b10101010;
            B = 8'b01010101;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            #1;

            check_outputs(1'b0, 8'b11111111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'd130;
            B = 8'd130;
            $display("Test Case %0d: Mid-range values with carry", test_num);
            #1;

            check_outputs(1'b1, 8'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_sum;
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
