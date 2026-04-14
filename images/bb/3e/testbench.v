`timescale 1ns/1ps

module comparator_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire equal;
    wire greater;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_4bit dut (
        .a(a),
        .b(b),
        .equal(equal),
        .greater(greater),
        .less(less)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=0, b=0 (Equal)", test_num);
            a = 4'd0; b = 4'd0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=15, b=15 (Equal)", test_num);
            a = 4'd15; b = 4'd15;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=7, b=7 (Equal)", test_num);
            a = 4'd7; b = 4'd7;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=1, b=0 (Greater)", test_num);
            a = 4'd1; b = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=15, b=0 (Greater)", test_num);
            a = 4'd15; b = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=8, b=7 (Greater: 1000 vs 0111)", test_num);
            a = 4'b1000; b = 4'b0111;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=0, b=1 (Less)", test_num);
            a = 4'd0; b = 4'd1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=0, b=15 (Less)", test_num);
            a = 4'd0; b = 4'd15;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=7, b=8 (Less: 0111 vs 1000)", test_num);
            a = 4'b0111; b = 4'b1000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=10, b=12 (Less)", test_num);
            a = 4'd10; b = 4'd12;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=5, b=3 (Greater)", test_num);
            a = 4'd5; b = 4'd3;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_4bit Testbench");
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
        input expected_equal;
        input expected_greater;
        input expected_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater === (expected_greater ^ greater ^ expected_greater) &&
                expected_less === (expected_less ^ less ^ expected_less)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater=%b, less=%b",
                         equal, greater, less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater=%b, less=%b",
                         expected_equal, expected_greater, expected_less);
                $display("  Got:      equal=%b, greater=%b, less=%b",
                         equal, greater, less);
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
