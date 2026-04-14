`timescale 1ns/1ps

module adder_tb;

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
    adder dut (
        .A(A),
        .B(B),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero addition (0 + 0)", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic addition (10 + 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Max value without carry (255 + 0)", test_num);
            A = 8'hFF;
            B = 8'h00;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Minimum carry out (255 + 1)", test_num);
            A = 8'hFF;
            B = 8'h01;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Midpoint carry out (128 + 128)", test_num);
            A = 8'h80;
            B = 8'h80;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Maximum carry out (255 + 255)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Sum to boundary (127 + 128)", test_num);
            A = 8'd127;
            B = 8'd128;
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Random addition with carry (200 + 100)", test_num);
            A = 8'd200;
            B = 8'd100;
            #1;

            check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Toggle bits pattern 1 (170 + 85)", test_num);
            A = 8'b10101010;
            B = 8'b01010101;
            #1;

            check_outputs(1'b0, 8'b11111111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Toggle bits pattern 2 (170 + 170)", test_num);
            A = 8'b10101010;
            B = 8'b10101010;
            #1;

            check_outputs(1'b1, 8'b01010100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
