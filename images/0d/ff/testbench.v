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
            $display("\nTestcase %0d: Already sorted inputs (1, 2, 3, 4)", test_num);
            a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;
            #1;

            check_outputs(16'h4321);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reverse sorted inputs (9, 7, 5, 2)", test_num);
            a = 4'd9; b = 4'd7; c = 4'd5; d = 4'd2;
            #1;

            check_outputs(16'h9752);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All identical inputs (8, 8, 8, 8)", test_num);
            a = 4'd8; b = 4'd8; c = 4'd8; d = 4'd8;
            #1;

            check_outputs(16'h8888);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Duplicate values (15, 0, 15, 0)", test_num);
            a = 4'd15; b = 4'd0; c = 4'd15; d = 4'd0;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random scramble (12, 4, 9, 1)", test_num);
            a = 4'd12; b = 4'd4; c = 4'd9; d = 4'd1;
            #1;

            check_outputs(16'hC941);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Near values (3, 2, 3, 4)", test_num);
            a = 4'd3; b = 4'd2; c = 4'd3; d = 4'd4;
            #1;

            check_outputs(16'h4332);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single large value (1, 1, 15, 1)", test_num);
            a = 4'd1; b = 4'd1; c = 4'd15; d = 4'd1;
            #1;

            check_outputs(16'hF111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single small value (14, 0, 14, 14)", test_num);
            a = 4'd14; b = 4'd0; c = 4'd14; d = 4'd14;
            #1;

            check_outputs(16'hEEE0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating values (10, 5, 10, 5)", test_num);
            a = 4'd10; b = 4'd5; c = 4'd10; d = 4'd5;
            #1;

            check_outputs(16'hAA55);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary values (0, 1, 14, 15)", test_num);
            a = 4'd15; b = 4'd0; c = 4'd1; d = 4'd14;
            #1;

            check_outputs(16'hFE10);
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
