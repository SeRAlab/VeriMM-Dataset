`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in0;
    reg [2:0] in1;
    reg [2:0] in2;
    wire [2:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .median(median)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Ascending order (1, 2, 3)", test_num);
        in0 = 3'd1; in1 = 3'd2; in2 = 3'd3;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Descending order (7, 4, 1)", test_num);
        in0 = 3'd7; in1 = 3'd4; in2 = 3'd1;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two identical low values (2, 2, 5)", test_num);
        in0 = 3'd2; in1 = 3'd2; in2 = 3'd5;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two identical high values (1, 6, 6)", test_num);
        in0 = 3'd1; in1 = 3'd6; in2 = 3'd6;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All values identical (4, 4, 4)", test_num);
        in0 = 3'd4; in1 = 3'd4; in2 = 3'd4;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Permutation check 1 (5, 2, 7)", test_num);
        in0 = 3'd5; in1 = 3'd2; in2 = 3'd7;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Permutation check 2 (7, 5, 2)", test_num);
        in0 = 3'd7; in1 = 3'd5; in2 = 3'd2;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum values (0, 1, 0)", test_num);
        in0 = 3'd0; in1 = 3'd1; in2 = 3'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values (7, 6, 7)", test_num);
        in0 = 3'd7; in1 = 3'd6; in2 = 3'd7;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Middle values spread (0, 7, 3)", test_num);
        in0 = 3'd0; in1 = 3'd7; in2 = 3'd3;
        #1;

        check_outputs(3'd3);
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
