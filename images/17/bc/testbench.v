`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    wire [7:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .a(a),
        .b(b),
        .c(c),
        .median(median)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Ascending order (10, 20, 30)", test_num);
        a = 8'd10; b = 8'd20; c = 8'd30;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Descending order (30, 20, 10)", test_num);
        a = 8'd30; b = 8'd20; c = 8'd10;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Median at first input (20, 10, 30)", test_num);
        a = 8'd20; b = 8'd10; c = 8'd30;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Median at last input (10, 30, 20)", test_num);
        a = 8'd10; b = 8'd30; c = 8'd20;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All inputs same (55, 55, 55)", test_num);
        a = 8'd55; b = 8'd55; c = 8'd55;
        #1;

        check_outputs(8'd55);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Two inputs same lower (10, 10, 100)", test_num);
        a = 8'd10; b = 8'd10; c = 8'd100;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Two inputs same higher (200, 50, 200)", test_num);
        a = 8'd200; b = 8'd50; c = 8'd200;
        #1;

        check_outputs(8'd200);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Boundary values (0, 128, 255)", test_num);
        a = 8'h00; b = 8'h80; c = 8'hFF;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Near boundary values (0, 1, 2)", test_num);
        a = 8'd0; b = 8'd2; c = 8'd1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max values and zero (255, 255, 0)", test_num);
        a = 8'hFF; b = 8'hFF; c = 8'h00;
        #1;

        check_outputs(8'hFF);
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
