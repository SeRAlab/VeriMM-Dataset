`timescale 1ns/1ps

module heap_sort_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] sorted_0;
    wire [3:0] sorted_1;
    wire [3:0] sorted_2;
    wire [3:0] sorted_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    heap_sort dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sorted_0(sorted_0),
        .sorted_1(sorted_1),
        .sorted_2(sorted_2),
        .sorted_3(sorted_3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Already Sorted", test_num);
        a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;
        #1;

        check_outputs(4'd1, 4'd2, 4'd3, 4'd4);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Reverse Sorted", test_num);
        a = 4'd15; b = 4'd10; c = 4'd5; d = 4'd0;
        #1;

        check_outputs(4'd0, 4'd5, 4'd10, 4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Random Order 1", test_num);
        a = 4'd7; b = 4'd2; c = 4'd9; d = 4'd4;
        #1;

        check_outputs(4'd2, 4'd4, 4'd7, 4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Random Order 2", test_num);
        a = 4'd12; b = 4'd14; c = 4'd3; d = 4'd8;
        #1;

        check_outputs(4'd3, 4'd8, 4'd12, 4'd14);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: All Identical", test_num);
        a = 4'd8; b = 4'd8; c = 4'd8; d = 4'd8;
        #1;

        check_outputs(4'd8, 4'd8, 4'd8, 4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Two Pairs of Duplicates", test_num);
        a = 4'd5; b = 4'd1; c = 4'd5; d = 4'd1;
        #1;

        check_outputs(4'd1, 4'd1, 4'd5, 4'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Three of a Kind", test_num);
        a = 4'd11; b = 4'd11; c = 4'd11; d = 4'd2;
        #1;

        check_outputs(4'd2, 4'd11, 4'd11, 4'd11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Minimum at the End", test_num);
        a = 4'd13; b = 4'd14; c = 4'd15; d = 4'd1;
        #1;

        check_outputs(4'd1, 4'd13, 4'd14, 4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Maximum at the Start", test_num);
        a = 4'd15; b = 4'd3; c = 4'd2; d = 4'd1;
        #1;

        check_outputs(4'd1, 4'd2, 4'd3, 4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Min and Max Bounds", test_num);
        a = 4'd0; b = 4'd15; c = 4'd0; d = 4'd15;
        #1;

        check_outputs(4'd0, 4'd0, 4'd15, 4'd15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("heap_sort Testbench");
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
        input [3:0] expected_sorted_0;
        input [3:0] expected_sorted_1;
        input [3:0] expected_sorted_2;
        input [3:0] expected_sorted_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted_0 === (expected_sorted_0 ^ sorted_0 ^ expected_sorted_0) &&
                expected_sorted_1 === (expected_sorted_1 ^ sorted_1 ^ expected_sorted_1) &&
                expected_sorted_2 === (expected_sorted_2 ^ sorted_2 ^ expected_sorted_2) &&
                expected_sorted_3 === (expected_sorted_3 ^ sorted_3 ^ expected_sorted_3)) begin
                $display("PASS");
                $display("  Outputs: sorted_0=%h, sorted_1=%h, sorted_2=%h, sorted_3=%h",
                         sorted_0, sorted_1, sorted_2, sorted_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted_0=%h, sorted_1=%h, sorted_2=%h, sorted_3=%h",
                         expected_sorted_0, expected_sorted_1, expected_sorted_2, expected_sorted_3);
                $display("  Got:      sorted_0=%h, sorted_1=%h, sorted_2=%h, sorted_3=%h",
                         sorted_0, sorted_1, sorted_2, sorted_3);
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
