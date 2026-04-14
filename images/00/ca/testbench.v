`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] frequency;
    reg reset;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .clk(clk),
        .frequency(frequency),
        .reset(reset),
        .detected(detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frequency = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency 9 (Below range 10-20)", test_num);
            reset_dut();
            frequency = 5'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency 10 (On lower boundary)", test_num);
            reset_dut();
            frequency = 5'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency 15 (Inside range)", test_num);
            reset_dut();
            frequency = 5'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency 20 (On upper boundary)", test_num);
            reset_dut();
            frequency = 5'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency 21 (Above range 10-20)", test_num);
            reset_dut();
            frequency = 5'd21;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency 0 (Minimum input)", test_num);
            reset_dut();
            frequency = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency 31 (Maximum input)", test_num);
            reset_dut();
            frequency = 5'd31;
            @(posedge clk);
            #1;
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
        $display("pitch_detector Testbench");
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
        $dumpvars(0,clk, frequency, reset, detected);
    end

endmodule
