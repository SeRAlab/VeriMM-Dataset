`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] matrix;
    wire [7:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .matrix(matrix),
        .median(median)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: All Zeros", test_num);
            matrix = 72'h000000000000000000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: All Max Values", test_num);
            matrix = {9{8'hFF}};
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Sorted Ascending 1-9", test_num);
            matrix = {8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h08, 8'h09};

            #1;


            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Sorted Descending 9-1", test_num);
            matrix = {8'h09, 8'h08, 8'h07, 8'h06, 8'h05, 8'h04, 8'h03, 8'h02, 8'h01};

            #1;


            check_outputs(8'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Unsorted Distribution", test_num);

            matrix = {8'd50, 8'd10, 8'd90, 8'd20, 8'd80, 8'd30, 8'd70, 8'd40, 8'd60};

            #1;


            check_outputs(8'd50);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Multiple Duplicates", test_num);

            matrix = {8'd10, 8'd20, 8'd10, 8'd20, 8'd10, 8'd20, 8'd10, 8'd20, 8'd10};

            #1;


            check_outputs(8'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %03d: High Outlier", test_num);

            matrix = {8'd5, 8'd6, 8'd5, 8'd6, 8'd255, 8'd5, 8'd6, 8'd5, 8'd6};

            #1;


            check_outputs(8'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %03d: Low Outlier", test_num);

            matrix = {8'd100, 8'd101, 8'd100, 8'd101, 8'd0, 8'd100, 8'd101, 8'd100, 8'd101};

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %03d: Tight Range", test_num);

            matrix = {8'h7F, 8'h80, 8'h81, 8'h7E, 8'h82, 8'h7D, 8'h83, 8'h7C, 8'h84};

            #1;


            check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("median_filter Testbench");
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
        input [7:0] expected_median;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_median === (expected_median ^ median ^ expected_median)) begin
                $display("PASS");
                $display("  Outputs: median=%h",
                         median);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: median=%h",
                         expected_median);
                $display("  Got:      median=%h",
                         median);
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
