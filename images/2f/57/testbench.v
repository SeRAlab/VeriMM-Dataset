`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [15:0] sorted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sorted(sorted)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Already Sorted Inputs (1, 2, 3, 4)", test_num);
            a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;

            #1;


            check_outputs(16'h4321);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Sorted Inputs (4, 3, 2, 1)", test_num);
            a = 4'd4; b = 4'd3; c = 4'd2; d = 4'd1;

            #1;


            check_outputs(16'h4321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs Identical (7, 7, 7, 7)", test_num);
            a = 4'd7; b = 4'd7; c = 4'd7; d = 4'd7;

            #1;


            check_outputs(16'h7777);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min and Max Values (0, 15, 0, 15)", test_num);
            a = 4'd0; b = 4'd15; c = 4'd0; d = 4'd15;

            #1;


            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Unsorted (10, 2, 15, 0)", test_num);
            a = 4'd10; b = 4'd2; c = 4'd15; d = 4'd0;

            #1;


            check_outputs(16'hFA20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three Identical Values (5, 2, 5, 5)", test_num);
            a = 4'd5; b = 4'd2; c = 4'd5; d = 4'd5;

            #1;


            check_outputs(16'h5552);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Pairs (9, 4, 9, 4)", test_num);
            a = 4'd9; b = 4'd4; c = 4'd9; d = 4'd4;

            #1;


            check_outputs(16'h9944);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single 0 with others (1, 0, 3, 2)", test_num);
            a = 4'd1; b = 4'd0; c = 4'd3; d = 4'd2;

            #1;


            check_outputs(16'h3210);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values mixed (14, 15, 13, 15)", test_num);
            a = 4'd14; b = 4'd15; c = 4'd13; d = 4'd15;

            #1;


            check_outputs(16'hFFED);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating values (6, 12, 6, 12)", test_num);
            a = 4'd6; b = 4'd12; c = 4'd6; d = 4'd12;

            #1;


            check_outputs(16'hCC66);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort Testbench");
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
        input [15:0] expected_sorted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted === (expected_sorted ^ sorted ^ expected_sorted)) begin
                $display("PASS");
                $display("  Outputs: sorted=%h",
                         sorted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted=%h",
                         expected_sorted);
                $display("  Got:      sorted=%h",
                         sorted);
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
