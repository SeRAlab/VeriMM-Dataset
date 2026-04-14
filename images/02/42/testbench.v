`timescale 1ns/1ps

module merge_sort_4inputs_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [15:0] sorted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4inputs dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sorted(sorted)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Already in ascending order", test_num);
        a = 4'h1; b = 4'h2; c = 4'h3; d = 4'h4;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reverse sorted order", test_num);
        a = 4'hF; b = 4'hE; c = 4'hD; d = 4'hC;
        #1;

        check_outputs(16'hCDEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random distribution 1", test_num);
        a = 4'h7; b = 4'h2; c = 4'hA; d = 4'h5;
        #1;

        check_outputs(16'h257A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random distribution 2", test_num);
        a = 4'hB; b = 4'h0; c = 4'hF; d = 4'h3;
        #1;

        check_outputs(16'h03BF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two pairs of duplicates", test_num);
        a = 4'h3; b = 4'h8; c = 4'h3; d = 4'h8;
        #1;

        check_outputs(16'h3388);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Three identical values", test_num);
        a = 4'h5; b = 4'h1; c = 4'h5; d = 4'h5;
        #1;

        check_outputs(16'h1555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All values identical", test_num);
        a = 4'h9; b = 4'h9; c = 4'h9; d = 4'h9;
        #1;

        check_outputs(16'h9999);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum and maximum extremes", test_num);
        a = 4'hF; b = 4'h0; c = 4'hF; d = 4'h0;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single large value at different positions", test_num);
        a = 4'hE; b = 4'h2; c = 4'h1; d = 4'h0;
        #1;

        check_outputs(16'h012E);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum possible 4-bit values", test_num);
        a = 4'hF; b = 4'hF; c = 4'hF; d = 4'hF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4inputs Testbench");
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
        input [15:0] expected_sorted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted === (expected_sorted ^ sorted ^ expected_sorted)) begin
                $display("PASS");
                $display("  Outputs: sorted=%h",
                         sorted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted=%h",
                         expected_sorted);
                $display("  Got:      sorted=%h",
                         sorted);
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
