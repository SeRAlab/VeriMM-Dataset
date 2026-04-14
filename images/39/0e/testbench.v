`timescale 1ns/1ps

module monte_carlo_simulation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] lower_bound;
    reg [7:0] random_number;
    reg [7:0] upper_bound;
    wire in_range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_simulation dut (
        .lower_bound(lower_bound),
        .random_number(random_number),
        .upper_bound(upper_bound),
        .in_range(in_range)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random number strictly inside range", test_num);
            lower_bound   = 8'd10;
            random_number = 8'd25;
            upper_bound   = 8'd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random number exactly at lower bound", test_num);
            lower_bound   = 8'd10;
            random_number = 8'd10;
            upper_bound   = 8'd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random number exactly at upper bound", test_num);
            lower_bound   = 8'd10;
            random_number = 8'd50;
            upper_bound   = 8'd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random number below lower bound", test_num);
            lower_bound   = 8'd100;
            random_number = 8'd99;
            upper_bound   = 8'd200;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random number above upper bound", test_num);
            lower_bound   = 8'd100;
            random_number = 8'd201;
            upper_bound   = 8'd200;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs identical", test_num);
            lower_bound   = 8'd128;
            random_number = 8'd128;
            upper_bound   = 8'd128;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full range [0-255]", test_num);
            lower_bound   = 8'd0;
            random_number = 8'd123;
            upper_bound   = 8'd255;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid range (lower > upper)", test_num);
            lower_bound   = 8'd200;
            random_number = 8'd150;
            upper_bound   = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge case 0", test_num);
            lower_bound   = 8'd0;
            random_number = 8'd0;
            upper_bound   = 8'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge case 255", test_num);
            lower_bound   = 8'd254;
            random_number = 8'd255;
            upper_bound   = 8'd255;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_simulation Testbench");
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
        input expected_in_range;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in_range === (expected_in_range ^ in_range ^ expected_in_range)) begin
                $display("PASS");
                $display("  Outputs: in_range=%b",
                         in_range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_range=%b",
                         expected_in_range);
                $display("  Got:      in_range=%b",
                         in_range);
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
