`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg start;
    wire done;
    wire [31:0] sorted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .done(done),
        .sorted_data(sorted_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_for_done;

        begin
            while (!done) begin
                @(posedge clk);
            end

            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Already Sorted Input", test_num);
            reset_dut();
            data_in = 32'h01020304;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, 32'h01020304);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reverse Sorted Input", test_num);
            reset_dut();
            data_in = 32'h04030201;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, 32'h01020304);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unsorted Random Mix", test_num);
            reset_dut();
            data_in = 32'h0A051402;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, 32'h02050A14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Identical Values", test_num);
            reset_dut();
            data_in = 32'hFF_FF_FF_FF;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, 32'hFF_FF_FF_FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input with Duplicates", test_num);
            reset_dut();
            data_in = 32'h10_02_10_08;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, 32'h02_08_10_10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Extreme Values (0 and 255)", test_num);
            reset_dut();
            data_in = 32'hFF_00_80_01;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, 32'h00_01_80_FF);
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
        input [31:0] expected_sorted_data;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_sorted_data === (expected_sorted_data ^ sorted_data ^ expected_sorted_data)) begin
                $display("PASS");
                $display("  Outputs: done=%b, sorted_data=%h",
                         done, sorted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, sorted_data=%h",
                         expected_done, expected_sorted_data);
                $display("  Got:      done=%b, sorted_data=%h",
                         done, sorted_data);
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
        $dumpvars(0,clk, data_in, start, done, sorted_data);
    end

endmodule
