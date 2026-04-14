`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] signal_in;
    wire crossing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .signal_in(signal_in),
        .crossing(crossing)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            signal_in = 8'd0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Positive to Negative (10 to -10)", test_num);
            reset_dut();
            signal_in = 8'sd10;
            @(posedge clk);
            #1;
            signal_in = -8'sd10;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Negative to Positive (-15 to 15)", test_num);
            reset_dut();
            signal_in = -8'sd15;
            @(posedge clk);
            #1;
            signal_in = 8'sd15;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary Crossing (127 to -1)", test_num);
            reset_dut();
            signal_in = 8'sd127;
            @(posedge clk);
            #1;
            signal_in = -8'sd1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary Crossing (-128 to 1)", test_num);
            reset_dut();
            signal_in = -8'sd128;
            @(posedge clk);
            #1;
            signal_in = 8'sd1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Slow Positive to Negative (5 -> 2 -> -3)", test_num);
            reset_dut();
            signal_in = 8'sd5;
            @(posedge clk);
            #1;
            signal_in = 8'sd2;
            @(posedge clk);
            #1;
            signal_in = -8'sd3;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Slow Negative to Positive (-10 -> -1 -> 5)", test_num);
            reset_dut();
            signal_in = -8'sd10;
            @(posedge clk);
            #1;
            signal_in = -8'sd1;
            @(posedge clk);
            #1;
            signal_in = 8'sd5;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zero_crossing_detector Testbench");
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
        input expected_crossing;
        begin
            if (expected_crossing === (expected_crossing ^ crossing ^ expected_crossing)) begin
                $display("PASS");
                $display("  Outputs: crossing=%b",
                         crossing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crossing=%b",
                         expected_crossing);
                $display("  Got:      crossing=%b",
                         crossing);
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
        $dumpvars(0,clk, signal_in, crossing);
    end

endmodule
