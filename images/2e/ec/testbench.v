`timescale 1ns/1ps

module binary_search_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] arr0;
    reg [4:0] arr1;
    reg [4:0] arr2;
    reg [4:0] arr3;
    reg [4:0] arr4;
    reg [2:0] search_val;
    wire found;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_search dut (
        .arr0(arr0),
        .arr1(arr1),
        .arr2(arr2),
        .arr3(arr3),
        .arr4(arr4),
        .search_val(search_val),
        .found(found)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Search value found at the start (index 0)", test_num);
            arr0 = 5'd1; arr1 = 5'd2; arr2 = 5'd3; arr3 = 5'd4; arr4 = 5'd5;
            search_val = 3'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Search value found in the middle (index 2)", test_num);
            arr0 = 5'd1; arr1 = 5'd2; arr2 = 5'd3; arr3 = 5'd4; arr4 = 5'd5;
            search_val = 3'd3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Search value found at the end (index 4)", test_num);
            arr0 = 5'd1; arr1 = 5'd2; arr2 = 5'd3; arr3 = 5'd4; arr4 = 5'd5;
            search_val = 3'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Search value not found (smaller than all elements)", test_num);
            arr0 = 5'd2; arr1 = 5'd3; arr2 = 5'd4; arr3 = 5'd5; arr4 = 5'd6;
            search_val = 3'd1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Search value not found (larger than all elements)", test_num);
            arr0 = 5'd1; arr1 = 5'd2; arr2 = 5'd3; arr3 = 5'd4; arr4 = 5'd5;
            search_val = 3'd7;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Search value not found (falls in a gap)", test_num);
            arr0 = 5'd1; arr1 = 5'd2; arr2 = 5'd4; arr3 = 5'd5; arr4 = 5'd6;
            search_val = 3'd3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Search value found in array with duplicates", test_num);
            arr0 = 5'd2; arr1 = 5'd2; arr2 = 5'd4; arr3 = 5'd4; arr4 = 5'd6;
            search_val = 3'd4;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Search value 0 found at start", test_num);
            arr0 = 5'd0; arr1 = 5'd1; arr2 = 5'd2; arr3 = 5'd3; arr4 = 5'd4;
            search_val = 3'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All elements identical and matching", test_num);
            arr0 = 5'd3; arr1 = 5'd3; arr2 = 5'd3; arr3 = 5'd3; arr4 = 5'd3;
            search_val = 3'd3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array elements exceed 3-bit range (not found)", test_num);
            arr0 = 5'd10; arr1 = 5'd11; arr2 = 5'd12; arr3 = 5'd13; arr4 = 5'd14;
            search_val = 3'd7;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_search Testbench");
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
        input expected_found;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_found === (expected_found ^ found ^ expected_found)) begin
                $display("PASS");
                $display("  Outputs: found=%b",
                         found);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b",
                         expected_found);
                $display("  Got:      found=%b",
                         found);
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
