`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg signal_in;
    wire cross_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .cross_detected(cross_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            signal_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Positive Crossing", test_num);
            reset_dut();

            signal_in = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Double Crossing (Toggle back to 0)", test_num);
            reset_dut();

            signal_in = 1;
            @(posedge clk);
            signal_in = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Sequential Crossings", test_num);
            reset_dut();

            repeat(5) begin
                signal_in = ~signal_in;
                @(posedge clk);
            end
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No Crossing Event", test_num);
            reset_dut();

            signal_in = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Signal No Crossing", test_num);
            rst = 1;
            signal_in = 1;
            @(posedge clk);
            #1 rst = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rapid Clock-rate Crossings", test_num);
            reset_dut();


            repeat(4) begin
                signal_in = ~signal_in;
                @(posedge clk);
            end
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
        input expected_cross_detected;
        begin
            if (expected_cross_detected === (expected_cross_detected ^ cross_detected ^ expected_cross_detected)) begin
                $display("PASS");
                $display("  Outputs: cross_detected=%b",
                         cross_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cross_detected=%b",
                         expected_cross_detected);
                $display("  Got:      cross_detected=%b",
                         cross_detected);
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
        $dumpvars(0,clk, rst, signal_in, cross_detected);
    end

endmodule
