`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire carry;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
            a = 8'h00;
            b = 8'h00;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Simple Addition without Carry (10 + 20)", test_num);
            a = 8'd10;
            b = 8'd20;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Maximum value without carry out (127 + 128)", test_num);
            a = 8'd127;
            b = 8'd128;
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Addition producing Carry Out (255 + 1)", test_num);
            a = 8'hFF;
            b = 8'h01;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating Bits (0xAA + 0x55)", test_num);
            a = 8'hAA;
            b = 8'h55;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Carry Out with High Values (200 + 100)", test_num);
            a = 8'd200;
            b = 8'd100;

            #1;


            check_outputs(1'b1, 8'h2C);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Max values addition (255 + 255)", test_num);
            a = 8'hFF;
            b = 8'hFF;

            #1;


            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Single bit addition (0x80 + 0x80)", test_num);
            a = 8'h80;
            b = 8'h80;
            #1;

            check_outputs(1'b1, 8'h00);
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
        input [7:0] expected_sum;
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
