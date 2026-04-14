`timescale 1ns/1ps

module quick_sort_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] arr;
    wire [19:0] sorted_arr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quick_sort dut (
        .arr(arr),
        .sorted_arr(sorted_arr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random unsorted unique numbers", test_num);
            arr = 20'h52917;
            #1;

            check_outputs(20'h12579);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Already sorted numbers", test_num);
            arr = 20'h13579;
            #1;

            check_outputs(20'h13579);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reverse sorted numbers", test_num);
            arr = 20'h97531;
            #1;

            check_outputs(20'h13579);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All identical numbers", test_num);
            arr = 20'hAAAAA;
            #1;

            check_outputs(20'hAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Numbers with duplicates", test_num);
            arr = 20'h28258;
            #1;

            check_outputs(20'h22588);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Extreme values (0 and 15)", test_num);
            arr = 20'hF0F07;
            #1;

            check_outputs(20'h007FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed sequence with one high value", test_num);
            arr = 20'h43B21;
            #1;

            check_outputs(20'h1234B);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequence with zeros", test_num);
            arr = 20'h06030;
            #1;

            check_outputs(20'h00036);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quick_sort Testbench");
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
        input [19:0] expected_sorted_arr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted_arr === (expected_sorted_arr ^ sorted_arr ^ expected_sorted_arr)) begin
                $display("PASS");
                $display("  Outputs: sorted_arr=%h",
                         sorted_arr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted_arr=%h",
                         expected_sorted_arr);
                $display("  Got:      sorted_arr=%h",
                         sorted_arr);
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
