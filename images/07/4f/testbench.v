`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] weight1;
    reg [4:0] weight2;
    wire [4:0] optimized_weight1;
    wire [4:0] optimized_weight2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .weight1(weight1),
        .weight2(weight2),
        .optimized_weight1(optimized_weight1),
        .optimized_weight2(optimized_weight2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum < 16 (w1=5, w2=5)", test_num);
            weight1 = 5'd5;
            weight2 = 5'd5;
            #10;
            #1;

            check_outputs(5'd5, 5'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum = 16 (w1=10, w2=6)", test_num);
            weight1 = 5'd10;
            weight2 = 5'd6;
            #10;
            #1;

            check_outputs(5'd10, 5'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum = 32 (w1=16, w2=16)", test_num);
            weight1 = 5'd16;
            weight2 = 5'd16;
            #10;

            #1;


            check_outputs(5'd8, 5'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum = 32 (w1=24, w2=8)", test_num);
            weight1 = 5'd24;
            weight2 = 5'd8;
            #10;


            #1;



            check_outputs(5'd12, 5'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum = 20 (w1=15, w2=5)", test_num);
            weight1 = 5'd15;
            weight2 = 5'd5;
            #10;


            #1;



            check_outputs(5'd12, 5'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Inputs (w1=31, w2=31)", test_num);
            weight1 = 5'd31;
            weight2 = 5'd31;
            #10;

            #1;


            check_outputs(5'd8, 5'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One input zero (w1=20, w2=0)", test_num);
            weight1 = 5'd20;
            weight2 = 5'd0;
            #10;

            #1;


            check_outputs(5'd16, 5'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scaling with truncation (w1=10, w2=20)", test_num);
            weight1 = 5'd10;
            weight2 = 5'd20;
            #10;



            #1;




            check_outputs(5'd5, 5'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
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
        input [4:0] expected_optimized_weight1;
        input [4:0] expected_optimized_weight2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_optimized_weight1 === (expected_optimized_weight1 ^ optimized_weight1 ^ expected_optimized_weight1) &&
                expected_optimized_weight2 === (expected_optimized_weight2 ^ optimized_weight2 ^ expected_optimized_weight2)) begin
                $display("PASS");
                $display("  Outputs: optimized_weight1=%h, optimized_weight2=%h",
                         optimized_weight1, optimized_weight2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimized_weight1=%h, optimized_weight2=%h",
                         expected_optimized_weight1, expected_optimized_weight2);
                $display("  Got:      optimized_weight1=%h, optimized_weight2=%h",
                         optimized_weight1, optimized_weight2);
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
