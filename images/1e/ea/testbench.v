`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] signal_in;
    wire neg_cross;
    wire pos_cross;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .signal_in(signal_in),
        .neg_cross(neg_cross),
        .pos_cross(pos_cross)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            signal_in = 8'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Positive to Negative transition (10 to -10)", test_num);
            reset_dut();
            signal_in = 8'sd10;
            @(posedge clk);
            #1;
            signal_in = -8'sd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Negative to Positive transition (-15 to 15)", test_num);
            reset_dut();
            signal_in = -8'sd15;
            @(posedge clk);
            #1;
            signal_in = 8'sd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative to Zero transition (-5 to 0)", test_num);
            reset_dut();
            signal_in = -8'sd5;
            @(posedge clk);
            #1;
            signal_in = 8'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero to Negative transition (0 to -5)", test_num);
            reset_dut();
            signal_in = 8'sd0;
            @(posedge clk);
            #1;
            signal_in = -8'sd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Positive to Zero transition (5 to 0)", test_num);
            reset_dut();
            signal_in = 8'sd5;
            @(posedge clk);
            #1;
            signal_in = 8'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Zero to Positive transition (0 to 5)", test_num);
            reset_dut();
            signal_in = 8'sd0;
            @(posedge clk);
            #1;
            signal_in = 8'sd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Steady Positive signal (20 to 20)", test_num);
            reset_dut();
            signal_in = 8'sd20;
            @(posedge clk);
            #1;
            signal_in = 8'sd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Steady Negative signal (-20 to -20)", test_num);
            reset_dut();
            signal_in = -8'sd20;
            @(posedge clk);
            #1;
            signal_in = -8'sd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Max negative to Max positive (-128 to 127)", test_num);
            reset_dut();
            signal_in = -8'sd128;
            @(posedge clk);
            #1;
            signal_in = 8'sd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Max positive to Max negative (127 to -128)", test_num);
            reset_dut();
            signal_in = 8'sd127;
            @(posedge clk);
            #1;
            signal_in = -8'sd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
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
        input expected_neg_cross;
        input expected_pos_cross;
        begin
            if (expected_neg_cross === (expected_neg_cross ^ neg_cross ^ expected_neg_cross) &&
                expected_pos_cross === (expected_pos_cross ^ pos_cross ^ expected_pos_cross)) begin
                $display("PASS");
                $display("  Outputs: neg_cross=%b, pos_cross=%b",
                         neg_cross, pos_cross);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: neg_cross=%b, pos_cross=%b",
                         expected_neg_cross, expected_pos_cross);
                $display("  Got:      neg_cross=%b, pos_cross=%b",
                         neg_cross, pos_cross);
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
        $dumpvars(0,clk, signal_in, neg_cross, pos_cross);
    end

endmodule
