`timescale 1ns/1ps

module PitchDetector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] frequency;
    reg [15:0] max_threshold;
    reg [15:0] min_threshold;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PitchDetector dut (
        .clk(clk),
        .frequency(frequency),
        .max_threshold(max_threshold),
        .min_threshold(min_threshold),
        .detected(detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            frequency = 0;
            max_threshold = 0;
            min_threshold = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency in middle of range", test_num);
            min_threshold = 16'd440;
            max_threshold = 16'd880;
            frequency = 16'd660;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency below range", test_num);
            min_threshold = 16'd1000;
            max_threshold = 16'd2000;
            frequency = 16'd500;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency above range", test_num);
            min_threshold = 16'd1000;
            max_threshold = 16'd2000;
            frequency = 16'd2500;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency at min boundary", test_num);
            min_threshold = 16'd1000;
            max_threshold = 16'd2000;
            frequency = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency at max boundary", test_num);
            min_threshold = 16'd1000;
            max_threshold = 16'd2000;
            frequency = 16'd2000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Narrow threshold range", test_num);
            min_threshold = 16'd499;
            max_threshold = 16'd501;
            frequency = 16'd500;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Zero frequency input", test_num);
            min_threshold = 16'd10;
            max_threshold = 16'd100;
            frequency = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max frequency range", test_num);
            min_threshold = 16'h0000;
            max_threshold = 16'hFFFF;
            frequency = 16'h8000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PitchDetector Testbench");
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
        input expected_detected;
        begin
            if (expected_detected === (expected_detected ^ detected ^ expected_detected)) begin
                $display("PASS");
                $display("  Outputs: detected=%b",
                         detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detected=%b",
                         expected_detected);
                $display("  Got:      detected=%b",
                         detected);
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
        $dumpvars(0,clk, frequency, max_threshold, min_threshold, detected);
    end

endmodule
