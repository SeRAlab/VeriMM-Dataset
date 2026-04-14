`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] sample0;
    reg [7:0] sample1;
    reg [7:0] sample2;
    reg [7:0] sample3;
    reg [7:0] sample4;
    wire [7:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .sample0(sample0),
        .sample1(sample1),
        .sample2(sample2),
        .sample3(sample3),
        .sample4(sample4),
        .median(median)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Ascending Sequence", test_num);
        sample0 = 8'd10;
        sample1 = 8'd20;
        sample2 = 8'd30;
        sample3 = 8'd40;
        sample4 = 8'd50;

        #1;


        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Descending Sequence", test_num);
        sample0 = 8'd255;
        sample1 = 8'd200;
        sample2 = 8'd150;
        sample3 = 8'd100;
        sample4 = 8'd50;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Samples Identical", test_num);
        sample0 = 8'd128;
        sample1 = 8'd128;
        sample2 = 8'd128;
        sample3 = 8'd128;
        sample4 = 8'd128;

        #1;


        check_outputs(8'd128);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Unsorted Mix", test_num);
        sample0 = 8'd45;
        sample1 = 8'd12;
        sample2 = 8'd250;
        sample3 = 8'd88;
        sample4 = 8'd5;

        #1;


        check_outputs(8'd45);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Duplicates", test_num);
        sample0 = 8'd100;
        sample1 = 8'd10;
        sample2 = 8'd100;
        sample3 = 8'd10;
        sample4 = 8'd50;

        #1;


        check_outputs(8'd50);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Median is a Duplicate Value", test_num);
        sample0 = 8'd5;
        sample1 = 8'd70;
        sample2 = 8'd70;
        sample3 = 8'd70;
        sample4 = 8'd255;

        #1;


        check_outputs(8'd70);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Values (Min/Max)", test_num);
        sample0 = 8'd0;
        sample1 = 8'd255;
        sample2 = 8'd0;
        sample3 = 8'd255;
        sample4 = 8'd127;

        #1;


        check_outputs(8'd127);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small Range Variation", test_num);
        sample0 = 8'd41;
        sample1 = 8'd42;
        sample2 = 8'd40;
        sample3 = 8'd44;
        sample4 = 8'd43;

        #1;


        check_outputs(8'd42);
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
