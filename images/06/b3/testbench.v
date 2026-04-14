`timescale 1ns/1ps

module merge_sort_4_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] sorted1;
    wire [7:0] sorted2;
    wire [7:0] sorted3;
    wire [7:0] sorted4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sorted1(sorted1),
        .sorted2(sorted2),
        .sorted3(sorted3),
        .sorted4(sorted4)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Ascending Order (Already Sorted)", test_num);
        a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40;
        #1;

        check_outputs(8'd10, 8'd20, 8'd30, 8'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Descending Order", test_num);
        a = 8'd40; b = 8'd30; c = 8'd20; d = 8'd10;
        #1;

        check_outputs(8'd10, 8'd20, 8'd30, 8'd40);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Unsorted", test_num);
        a = 8'd45; b = 8'd12; c = 8'd89; d = 8'd3;
        #1;

        check_outputs(8'd3, 8'd12, 8'd45, 8'd89);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Identical Values", test_num);
        a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd255;
        #1;

        check_outputs(8'd255, 8'd255, 8'd255, 8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two Duplicate Pairs", test_num);
        a = 8'd15; b = 8'd5; c = 8'd15; d = 8'd5;
        #1;

        check_outputs(8'd5, 8'd5, 8'd15, 8'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: One Zero, One Max, Two Medium", test_num);
        a = 8'h00; b = 8'hFF; c = 8'h7F; d = 8'h80;
        #1;

        check_outputs(8'h00, 8'h7F, 8'h80, 8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Merge Step Logic Check (Small/Large pairs)", test_num);

        a = 8'd10; b = 8'd30;
        c = 8'd20; d = 8'd40;
        #1;

        check_outputs(8'd10, 8'd20, 8'd30, 8'd40);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shifted Order", test_num);
        a = 8'd20; b = 8'd30; c = 8'd40; d = 8'd10;
        #1;

        check_outputs(8'd10, 8'd20, 8'd30, 8'd40);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4 Testbench");
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
        input [7:0] expected_sorted1;
        input [7:0] expected_sorted2;
        input [7:0] expected_sorted3;
        input [7:0] expected_sorted4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted1 === (expected_sorted1 ^ sorted1 ^ expected_sorted1) &&
                expected_sorted2 === (expected_sorted2 ^ sorted2 ^ expected_sorted2) &&
                expected_sorted3 === (expected_sorted3 ^ sorted3 ^ expected_sorted3) &&
                expected_sorted4 === (expected_sorted4 ^ sorted4 ^ expected_sorted4)) begin
                $display("PASS");
                $display("  Outputs: sorted1=%h, sorted2=%h, sorted3=%h, sorted4=%h",
                         sorted1, sorted2, sorted3, sorted4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted1=%h, sorted2=%h, sorted3=%h, sorted4=%h",
                         expected_sorted1, expected_sorted2, expected_sorted3, expected_sorted4);
                $display("  Got:      sorted1=%h, sorted2=%h, sorted3=%h, sorted4=%h",
                         sorted1, sorted2, sorted3, sorted4);
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
