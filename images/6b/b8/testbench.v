`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [29:0] background_data;
    reg [39:0] foreground_data;
    wire [9:0] new_blue;
    wire [9:0] new_green;
    wire [9:0] new_red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .background_data(background_data),
        .foreground_data(foreground_data),
        .new_blue(new_blue),
        .new_green(new_green),
        .new_red(new_red)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alpha = 0 (Background selection)", test_num);


            background_data = {10'h123, 10'h234, 10'h345};
            foreground_data = {1'b0, 9'b0, 10'h001, 10'h002, 10'h003};
            #1;

            check_outputs(10'h345, 10'h234, 10'h123);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alpha = 1 (Foreground selection)", test_num);


            background_data = {10'h123, 10'h234, 10'h345};
            foreground_data = {1'b1, 9'b0, 10'h3FF, 10'h2AA, 10'h155};
            #1;

            check_outputs(10'h155, 10'h2AA, 10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alpha = 0, All Foreground ones vs All Background zeros", test_num);
            background_data = 30'h00000000;
            foreground_data = {1'b0, 39'h7FFFFFFFFF};
            #1;

            check_outputs(10'h000, 10'h000, 10'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alpha = 1, All Foreground ones vs All Background zeros", test_num);
            background_data = 30'h00000000;
            foreground_data = {1'b1, 39'h7FFFFFFFFF};
            #1;

            check_outputs(10'h3FF, 10'h3FF, 10'h3FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alpha = 0, Boundary Check Max Values", test_num);
            background_data = {10'h3FF, 10'h3FF, 10'h3FF};
            foreground_data = {1'b0, 39'h0000000000};
            #1;

            check_outputs(10'h3FF, 10'h3FF, 10'h3FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alpha = 1, Arbitrary Pattern", test_num);
            background_data = {10'h0AA, 10'h155, 10'h2AA};
            foreground_data = {1'b1, 9'h1FF, 10'h255, 10'h1AA, 10'h055};
            #1;

            check_outputs(10'h055, 10'h1AA, 10'h255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alpha = 0, Red only BG", test_num);
            background_data = {10'h3FF, 10'h000, 10'h000};
            foreground_data = {1'b0, 9'h000, 10'h000, 10'h3FF, 10'h3FF};
            #1;

            check_outputs(10'h000, 10'h000, 10'h3FF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alpha = 1, Green only FG", test_num);
            background_data = {10'h3FF, 10'h000, 10'h3FF};
            foreground_data = {1'b1, 9'h000, 10'h000, 10'h3FF, 10'h000};
            #1;

            check_outputs(10'h000, 10'h3FF, 10'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [9:0] expected_new_blue;
        input [9:0] expected_new_green;
        input [9:0] expected_new_red;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_blue === (expected_new_blue ^ new_blue ^ expected_new_blue) &&
                expected_new_green === (expected_new_green ^ new_green ^ expected_new_green) &&
                expected_new_red === (expected_new_red ^ new_red ^ expected_new_red)) begin
                $display("PASS");
                $display("  Outputs: new_blue=%h, new_green=%h, new_red=%h",
                         new_blue, new_green, new_red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_blue=%h, new_green=%h, new_red=%h",
                         expected_new_blue, expected_new_green, expected_new_red);
                $display("  Got:      new_blue=%h, new_green=%h, new_red=%h",
                         new_blue, new_green, new_red);
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
