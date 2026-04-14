`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] array1;
    reg [3:0] array2;
    wire [7:0] merged_array;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .array1(array1),
        .array2(array2),
        .merged_array(merged_array)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both arrays all zeros", test_num);
            array1 = 4'b0000;
            array2 = 4'b0000;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both arrays all ones", test_num);
            array1 = 4'b1111;
            array2 = 4'b1111;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array1 all zeros, Array2 all ones", test_num);
            array1 = 4'b0000;
            array2 = 4'b1111;
            #1;

            check_outputs(8'b00001111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array1 all ones, Array2 all zeros", test_num);
            array1 = 4'b1111;
            array2 = 4'b0000;
            #1;

            check_outputs(8'b00001111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Each array has one '1'", test_num);
            array1 = 4'b0001;
            array2 = 4'b0001;
            #1;

            check_outputs(8'b00000011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array1 has two '1's, Array2 has three '1's", test_num);
            array1 = 4'b0011;
            array2 = 4'b0111;
            #1;

            check_outputs(8'b00011111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array1 has three '1's, Array2 has one '1'", test_num);
            array1 = 4'b0111;
            array2 = 4'b0001;
            #1;

            check_outputs(8'b00001111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array1 has zero '1's, Array2 has two '1's", test_num);
            array1 = 4'b0000;
            array2 = 4'b0011;
            #1;

            check_outputs(8'b00000011);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array1 has four '1's, Array2 has two '1's", test_num);
            array1 = 4'b1111;
            array2 = 4'b0011;
            #1;

            check_outputs(8'b00111111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array1 has one '1', Array2 has zero '1's", test_num);
            array1 = 4'b0001;
            array2 = 4'b0000;
            #1;

            check_outputs(8'b00000001);
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
        input [7:0] expected_merged_array;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_merged_array === (expected_merged_array ^ merged_array ^ expected_merged_array)) begin
                $display("PASS");
                $display("  Outputs: merged_array=%h",
                         merged_array);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: merged_array=%h",
                         expected_merged_array);
                $display("  Got:      merged_array=%h",
                         merged_array);
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
