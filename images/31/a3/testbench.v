`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (sequential circuit)
    reg start;
    reg [19:0] unsorted;
    wire done;
    wire [19:0] sorted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .start(start),
        .unsorted(unsorted),
        .done(done),
        .sorted(sorted)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

        begin
            unsorted = 20'h0;

            repeat (2) @(posedge start);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Already sorted array", test_num);
            reset_dut();
            unsorted = 20'h12345;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, 20'h12345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reverse sorted array", test_num);
            reset_dut();
            unsorted = 20'h54321;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, 20'h12345);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All elements same", test_num);
            reset_dut();
            unsorted = 20'hAAAAA;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, 20'hAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed values", test_num);
            reset_dut();
            unsorted = 20'hF0817;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, 20'h0178F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Duplicate values", test_num);
            reset_dut();
            unsorted = 20'h39239;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, 20'h23399);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max and Min values", test_num);
            reset_dut();
            unsorted = 20'hF0F05;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, 20'h005FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Smallest element at end", test_num);
            reset_dut();
            unsorted = 20'hBCD10;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, 20'h01BCD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bubble_sort Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_done;
        input [19:0] expected_sorted;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_sorted === (expected_sorted ^ sorted ^ expected_sorted)) begin
                $display("PASS");
                $display("  Outputs: done=%b, sorted=%h",
                         done, sorted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, sorted=%h",
                         expected_done, expected_sorted);
                $display("  Got:      done=%b, sorted=%h",
                         done, sorted);
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
        $dumpvars(0,start, unsorted, done, sorted);
    end

endmodule
