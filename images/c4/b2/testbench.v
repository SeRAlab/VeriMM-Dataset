`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire C;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .A(A),
        .B(B),
        .C(C),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'sd10;
            B = 8'sd20;
            $display("Test %0d: Positive addition (10 + 20)", test_num);
            #1;

            check_outputs(1'b0, 8'sd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = -8'sd10;
            B = -8'sd20;
            $display("Test %0d: Negative addition (-10 + -20)", test_num);
            #1;

            check_outputs(1'b0, -8'sd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'sd50;
            B = -8'sd10;
            $display("Test %0d: Mixed signs (50 + -10)", test_num);
            #1;

            check_outputs(1'b0, 8'sd40);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'h7F;
            B = 8'h01;
            $display("Test %0d: Positive Overflow (127 + 1)", test_num);
            #1;

            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'h80;
            B = 8'hFF;
            $display("Test %0d: Negative Overflow (-128 + -1)", test_num);
            #1;

            check_outputs(1'b1, 8'h7F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'sd0;
            B = 8'sd0;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'sd127;
            B = -8'sd127;
            $display("Test %0d: Boundary resulting in zero (127 + -127)", test_num);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'sd64;
            B = 8'sd64;
            $display("Test %0d: Overflow Mid-range (64 + 64)", test_num);
            #1;

            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = -8'sd65;
            B = -8'sd64;
            $display("Test %0d: Negative Overflow Mid-range (-65 + -64)", test_num);
            #1;

            check_outputs(1'b1, 8'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'h80;
            B = 8'h01;
            $display("Test %0d: Boundary negative + 1 (-128 + 1)", test_num);
            #1;

            check_outputs(1'b0, 8'h81);
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
        input expected_C;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: C=%b, sum=%h",
                         C, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, sum=%h",
                         expected_C, expected_sum);
                $display("  Got:      C=%b, sum=%h",
                         C, sum);
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
