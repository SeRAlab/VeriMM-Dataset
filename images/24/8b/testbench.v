`timescale 1ns/1ps

module fixed_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'h10;
            b = 8'h20;
            $display("Test %0d: Simple Positive Addition (1.0 + 2.0)", test_num);
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'h08;
            b = 8'h04;
            $display("Test %0d: Fractional Addition (0.5 + 0.25)", test_num);
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'hF0;
            b = 8'hF0;
            $display("Test %0d: Negative Addition (-1.0 + -1.0)", test_num);
            #1;

            check_outputs(8'hE0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'h70;
            b = 8'h10;
            $display("Test %0d: Positive Saturation (7.0 + 1.0 = 8.0 -> Saturation)", test_num);


            #1;



            check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'h90;
            b = 8'hEF;
            $display("Test %0d: Negative Saturation (-7.0 + -1.0625 = -8.0625 -> Saturation)", test_num);

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 8'h00;
            b = 8'h00;
            $display("Test %0d: Zero Addition", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 8'h18;
            b = 8'hE8;
            $display("Test %0d: Mixed Sign Addition (1.5 + -1.5)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 8'h7F;
            b = 8'h7F;
            $display("Test %0d: Maximum Positive Saturation (Max + Max)", test_num);
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 8'h80;
            b = 8'h80;
            $display("Test %0d: Maximum Negative Saturation (Min + Min)", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 8'h40;
            b = 8'hC0;
            $display("Test %0d: Zero crossing from large values", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_adder Testbench");
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
