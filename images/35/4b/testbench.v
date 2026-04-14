`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] sorted0;
    wire [7:0] sorted1;
    wire [7:0] sorted2;
    wire [7:0] sorted3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sorted0(sorted0),
        .sorted1(sorted1),
        .sorted2(sorted2),
        .sorted3(sorted3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Already sorted ascending", test_num);
            a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40;
            #1;

            check_outputs(8'd10, 8'd20, 8'd30, 8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reverse sorted (descending)", test_num);
            a = 8'd100; b = 8'd75; c = 8'd50; d = 8'd25;
            #1;

            check_outputs(8'd25, 8'd50, 8'd75, 8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All elements identical", test_num);
            a = 8'd55; b = 8'd55; c = 8'd55; d = 8'd55;
            #1;

            check_outputs(8'd55, 8'd55, 8'd55, 8'd55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Two pairs of duplicates", test_num);
            a = 8'd12; b = 8'd99; c = 8'd12; d = 8'd99;
            #1;

            check_outputs(8'd12, 8'd12, 8'd99, 8'd99);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Minimum and maximum values", test_num);
            a = 8'hFF; b = 8'h00; c = 8'h01; d = 8'hFE;
            #1;

            check_outputs(8'h00, 8'h01, 8'hFE, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: One very large value, others small", test_num);
            a = 8'd5; b = 8'd255; c = 8'd3; d = 8'd8;
            #1;

            check_outputs(8'd3, 8'd5, 8'd8, 8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Alternating values", test_num);
            a = 8'd50; b = 8'd10; c = 8'd50; d = 8'd10;
            #1;

            check_outputs(8'd10, 8'd10, 8'd50, 8'd50);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Random permutation 1", test_num);
            a = 8'd42; b = 8'd7; c = 8'd88; d = 8'd19;
            #1;

            check_outputs(8'd7, 8'd19, 8'd42, 8'd88);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Random permutation 2", test_num);
            a = 8'd128; b = 8'd64; c = 8'd192; d = 8'd32;
            #1;

            check_outputs(8'd32, 8'd64, 128, 192);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Zero values", test_num);
            a = 8'd0; b = 8'd0; c = 8'd5; d = 8'd0;
            #1;

            check_outputs(8'd0, 8'd0, 8'd0, 8'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort Testbench");
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
        input [7:0] expected_sorted0;
        input [7:0] expected_sorted1;
        input [7:0] expected_sorted2;
        input [7:0] expected_sorted3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted0 === (expected_sorted0 ^ sorted0 ^ expected_sorted0) &&
                expected_sorted1 === (expected_sorted1 ^ sorted1 ^ expected_sorted1) &&
                expected_sorted2 === (expected_sorted2 ^ sorted2 ^ expected_sorted2) &&
                expected_sorted3 === (expected_sorted3 ^ sorted3 ^ expected_sorted3)) begin
                $display("PASS");
                $display("  Outputs: sorted0=%h, sorted1=%h, sorted2=%h, sorted3=%h",
                         sorted0, sorted1, sorted2, sorted3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted0=%h, sorted1=%h, sorted2=%h, sorted3=%h",
                         expected_sorted0, expected_sorted1, expected_sorted2, expected_sorted3);
                $display("  Got:      sorted0=%h, sorted1=%h, sorted2=%h, sorted3=%h",
                         sorted0, sorted1, sorted2, sorted3);
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
