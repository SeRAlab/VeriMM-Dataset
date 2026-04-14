`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    wire [7:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .median(median)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Sorted Ascending", test_num);
            in0 = 8'd10; in1 = 8'd20; in2 = 8'd30; in3 = 8'd40; in4 = 8'd50;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Sorted Descending", test_num);
            in0 = 8'd255; in1 = 8'd200; in2 = 8'd150; in3 = 8'd100; in4 = 8'd50;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shuffled Order", test_num);
            in0 = 8'd45; in1 = 8'd12; in2 = 8'd89; in3 = 8'd34; in4 = 8'd67;
            #1;

            check_outputs(8'd45);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: All Inputs Identical", test_num);
            in0 = 8'd128; in1 = 8'd128; in2 = 8'd128; in3 = 8'd128; in4 = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Four High, One Low", test_num);
            in0 = 8'd5; in1 = 8'd250; in2 = 8'd250; in3 = 8'd250; in4 = 8'd250;
            #1;

            check_outputs(8'd250);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Four Low, One High", test_num);
            in0 = 8'd10; in1 = 8'd10; in2 = 8'd10; in3 = 8'd10; in4 = 8'd255;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Boundary Values", test_num);
            in0 = 8'd0; in1 = 8'd0; in2 = 8'd255; in3 = 8'd255; in4 = 8'd127;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Multiple Pairs", test_num);
            in0 = 8'd60; in1 = 8'd100; in2 = 8'd60; in3 = 8'd100; in4 = 8'd80;
            #1;

            check_outputs(8'd80);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Tight Cluster with Outlier", test_num);
            in0 = 8'd40; in1 = 8'd41; in2 = 8'd42; in3 = 8'd255; in4 = 8'd39;
            #1;

            check_outputs(8'd41);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Alternating Large and Small", test_num);
            in0 = 8'd255; in1 = 8'd0; in2 = 8'd254; in3 = 8'd1; in4 = 8'd128;
            #1;

            check_outputs(8'd128);
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
