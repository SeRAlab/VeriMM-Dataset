`timescale 1ns/1ps

module fixed_point_addition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_addition dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero addition (0.0 + 0.0)", test_num);
            a = 8'h00; b = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pure integer addition (1.0 + 2.0 = 3.0)", test_num);
            a = 8'h10; b = 8'h20;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pure fractional addition (0.125 + 0.25 = 0.375)", test_num);

            a = 8'h02; b = 8'h04;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fractional carry to integer (0.5 + 0.5 = 1.0)", test_num);

            a = 8'h08; b = 8'h08;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed addition (3.75 + 2.125 = 5.875)", test_num);

            a = 8'h3C; b = 8'h22;
            #1;

            check_outputs(8'h5E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary saturation (15.0 + 1.0 = 15.9375 saturated)", test_num);

            a = 8'hF0; b = 8'h10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value addition (Saturation)", test_num);
            a = 8'hFF; b = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small fractional overflow (15.9375 + 0.0625)", test_num);

            a = 8'hFF; b = 8'h01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_addition Testbench");
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
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
