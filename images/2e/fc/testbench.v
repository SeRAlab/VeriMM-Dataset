`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] pixels;
    wire [7:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .pixels(pixels),
        .median(median)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All pixels identical", test_num);
            pixels = {9{8'd128}};
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequentially increasing values", test_num);
            pixels = {8'd90, 8'd80, 8'd70, 8'd60, 8'd50, 8'd40, 8'd30, 8'd20, 8'd10};

            #1;


            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequentially decreasing values", test_num);
            pixels = {8'd11, 8'd22, 8'd33, 8'd44, 8'd55, 8'd66, 8'd77, 8'd88, 8'd99};

            #1;


            check_outputs(8'd55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random set A", test_num);
            pixels = {8'd15, 8'd2, 8'd250, 8'd100, 8'd45, 8'd12, 8'd88, 8'd3, 8'd7};

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Salt noise (mostly black, one white)", test_num);
            pixels = {8'd0, 8'd0, 8'd255, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pepper noise (mostly white, one black)", test_num);
            pixels = {8'd255, 8'd255, 8'd255, 8'd255, 8'd0, 8'd255, 8'd255, 8'd255, 8'd255};

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple duplicates", test_num);
            pixels = {8'd50, 8'd50, 8'd200, 8'd50, 8'd200, 8'd50, 8'd200, 8'd200, 8'd200};

            #1;


            check_outputs(8'd200);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random set B", test_num);
            pixels = {8'd42, 8'd10, 8'd33, 8'd5, 8'd120, 8'd8, 8'd19, 8'd77, 8'd21};

            #1;


            check_outputs(8'd21);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-range spread", test_num);
            pixels = {8'd255, 8'd254, 8'd253, 8'd252, 8'd251, 8'd0, 8'd1, 8'd2, 8'd3};

            #1;


            check_outputs(8'd251);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating extremes", test_num);
            pixels = {8'd0, 8'd255, 8'd0, 8'd255, 8'd128, 8'd255, 8'd0, 8'd255, 8'd0};

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
