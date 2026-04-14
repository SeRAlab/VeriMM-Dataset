`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] pixel0;
    reg [2:0] pixel1;
    reg [2:0] pixel2;
    reg [2:0] pixel3;
    reg [2:0] pixel4;
    reg [2:0] pixel5;
    reg [2:0] pixel6;
    reg [2:0] pixel7;
    reg [2:0] pixel8;
    wire [2:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .pixel0(pixel0),
        .pixel1(pixel1),
        .pixel2(pixel2),
        .pixel3(pixel3),
        .pixel4(pixel4),
        .pixel5(pixel5),
        .pixel6(pixel6),
        .pixel7(pixel7),
        .pixel8(pixel8),
        .median(median)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All same values (4)", test_num);
            pixel0 = 3'd4; pixel1 = 3'd4; pixel2 = 3'd4;
            pixel3 = 3'd4; pixel4 = 3'd4; pixel5 = 3'd4;
            pixel6 = 3'd4; pixel7 = 3'd4; pixel8 = 3'd4;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increasing sequence", test_num);
            pixel0 = 3'd0; pixel1 = 3'd1; pixel2 = 3'd2;
            pixel3 = 3'd3; pixel4 = 3'd4; pixel5 = 3'd5;
            pixel6 = 3'd6; pixel7 = 3'd7; pixel8 = 3'd7;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decreasing sequence", test_num);
            pixel0 = 3'd7; pixel1 = 3'd6; pixel2 = 3'd5;
            pixel3 = 3'd4; pixel4 = 3'd3; pixel5 = 3'd2;
            pixel6 = 3'd1; pixel7 = 3'd0; pixel8 = 3'd0;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Salt Noise (majority 1s, some 7s)", test_num);
            pixel0 = 3'd7; pixel1 = 3'd1; pixel2 = 3'd7;
            pixel3 = 3'd1; pixel4 = 3'd7; pixel5 = 3'd1;
            pixel6 = 3'd7; pixel7 = 3'd1; pixel8 = 3'd1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pepper Noise (majority 6s, some 0s)", test_num);
            pixel0 = 3'd0; pixel1 = 3'd6; pixel2 = 3'd0;
            pixel3 = 3'd6; pixel4 = 3'd0; pixel5 = 3'd6;
            pixel6 = 3'd0; pixel7 = 3'd6; pixel8 = 3'd6;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random distribution 1", test_num);
            pixel0 = 3'd1; pixel1 = 3'd5; pixel2 = 3'd2;
            pixel3 = 3'd7; pixel4 = 3'd3; pixel5 = 3'd0;
            pixel6 = 3'd4; pixel7 = 3'd6; pixel8 = 3'd2;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random distribution 2", test_num);
            pixel0 = 3'd4; pixel1 = 3'd5; pixel2 = 3'd4;
            pixel3 = 3'd5; pixel4 = 3'd4; pixel5 = 3'd5;
            pixel6 = 3'd4; pixel7 = 3'd5; pixel8 = 3'd4;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            pixel0 = 3'd0; pixel1 = 3'd0; pixel2 = 3'd0;
            pixel3 = 3'd0; pixel4 = 3'd0; pixel5 = 3'd0;
            pixel6 = 3'd0; pixel7 = 3'd0; pixel8 = 3'd0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Sevens", test_num);
            pixel0 = 3'd7; pixel1 = 3'd7; pixel2 = 3'd7;
            pixel3 = 3'd7; pixel4 = 3'd7; pixel5 = 3'd7;
            pixel6 = 3'd7; pixel7 = 3'd7; pixel8 = 3'd7;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gap in values", test_num);
            pixel0 = 3'd5; pixel1 = 3'd0; pixel2 = 3'd7;
            pixel3 = 3'd1; pixel4 = 3'd6; pixel5 = 3'd2;
            pixel6 = 3'd7; pixel7 = 3'd3; pixel8 = 3'd5;
            #1;

            check_outputs(3'd5);
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
        input [2:0] expected_median;
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
