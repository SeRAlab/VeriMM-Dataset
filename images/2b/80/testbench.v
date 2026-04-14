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
        $display("Test %0d: Sorted distinct values (a < b < c)", test_num);
        a = 8'd10; b = 8'd20; c = 8'd30;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Permutation (b < a < c)", test_num);
        a = 8'd20; b = 8'd10; c = 8'd30;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Permutation (c < b < a)", test_num);
        a = 8'd30; b = 8'd20; c = 8'd10;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Two values equal (a = b < c)", test_num);
        a = 8'd50; b = 8'd50; c = 8'd100;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Two values equal (a < b = c)", test_num);
        a = 8'd5; b = 8'd55; c = 8'd55;
        #1;

        check_outputs(8'd55);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All values equal", test_num);
        a = 8'hFF; b = 8'hFF; c = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum and maximum bounds", test_num);
        a = 8'd0; b = 8'd255; c = 8'd128;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros", test_num);
        a = 8'd0; b = 8'd0; c = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Values very close together", test_num);
        a = 8'd127; b = 8'd128; c = 8'd126;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed hex values", test_num);
        a = 8'hAA; b = 8'h55; c = 8'hEE;

        #1;


        check_outputs(8'hAA);
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
