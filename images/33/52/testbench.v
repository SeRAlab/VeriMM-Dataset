`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] signal_in;
    reg [7:0] threshold;
    wire is_high_pitch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .clk(clk),
        .reset(reset),
        .signal_in(signal_in),
        .threshold(threshold),
        .is_high_pitch(is_high_pitch)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            signal_in = 0;
            threshold = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal > Threshold", test_num);
            reset_dut();
            signal_in = 8'd200;
            threshold = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal < Threshold", test_num);
            reset_dut();
            signal_in = 8'd50;
            threshold = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal == Threshold", test_num);
            reset_dut();
            signal_in = 8'd128;
            threshold = 8'd128;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal just above Threshold (T+1)", test_num);
            reset_dut();
            signal_in = 8'd129;
            threshold = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Signal and Threshold", test_num);
            reset_dut();
            signal_in = 8'd255;
            threshold = 8'd254;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Threshold, Non-zero Signal", test_num);
            reset_dut();
            signal_in = 8'd1;
            threshold = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            reset_dut();
            signal_in = 8'd0;
            threshold = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify output during Reset", test_num);
            @(posedge clk);
            reset = 1;
            signal_in = 8'd255;
            threshold = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detector Testbench");
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
        input expected_is_high_pitch;
        begin
            if (expected_is_high_pitch === (expected_is_high_pitch ^ is_high_pitch ^ expected_is_high_pitch)) begin
                $display("PASS");
                $display("  Outputs: is_high_pitch=%b",
                         is_high_pitch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_high_pitch=%b",
                         expected_is_high_pitch);
                $display("  Got:      is_high_pitch=%b",
                         is_high_pitch);
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
        $dumpvars(0,clk, reset, signal_in, threshold, is_high_pitch);
    end

endmodule
