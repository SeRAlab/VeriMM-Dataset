`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] x;
    reg [1:0] y;
    wire carry;
    wire [1:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .x(x),
        .y(y),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            x = 2'b00;
            y = 2'b00;
            $display("Test Case %0d: %d + %d", test_num, x, y);
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            x = 2'b01;
            y = 2'b00;
            $display("Test Case %0d: %d + %d", test_num, x, y);
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            x = 2'b01;
            y = 2'b01;
            $display("Test Case %0d: %d + %d", test_num, x, y);
            #1;

            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            x = 2'b10;
            y = 2'b01;
            $display("Test Case %0d: %d + %d", test_num, x, y);
            #1;

            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            x = 2'b10;
            y = 2'b10;
            $display("Test Case %0d: %d + %d", test_num, x, y);
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            x = 2'b11;
            y = 2'b01;
            $display("Test Case %0d: %d + %d", test_num, x, y);
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            x = 2'b11;
            y = 2'b11;
            $display("Test Case %0d: %d + %d", test_num, x, y);
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            x = 2'b00;
            y = 2'b11;
            $display("Test Case %0d: %d + %d", test_num, x, y);
            #1;

            check_outputs(1'b0, 2'b11);
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
        input expected_carry;
        input [1:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, sum=%h",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, sum=%h",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%b, sum=%h",
                         carry, sum);
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
