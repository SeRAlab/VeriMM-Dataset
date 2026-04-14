`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] unsorted;
    wire [31:0] sorted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .clk(clk),
        .unsorted(unsorted),
        .sorted(sorted)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            unsorted = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Already Sorted", test_num);
            unsorted = 32'h04_03_02_01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h04_03_02_01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Order", test_num);
            unsorted = 32'h01_02_03_04;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h04_03_02_01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Values", test_num);
            unsorted = 32'hA5_22_FF_00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFF_A5_22_00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Identical", test_num);
            unsorted = 32'hEE_EE_EE_EE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hEE_EE_EE_EE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Two Pairs", test_num);
            unsorted = 32'h10_20_10_20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h20_20_10_10);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Single High Outlier", test_num);
            unsorted = 32'h00_FF_00_00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFF_00_00_00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max and Min Values", test_num);
            unsorted = 32'hFF_00_FF_00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFF_FF_00_00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Small Primes", test_num);
            unsorted = 32'h07_02_05_03;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h07_05_03_02);
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
        input [31:0] expected_sorted;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, unsorted, sorted);
    end

endmodule
