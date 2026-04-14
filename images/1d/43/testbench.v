`timescale 1ns/1ps

module pitch_detection_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_data;
    wire pitch_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detection dut (
        .clk(clk),
        .reset(reset),
        .serial_data(serial_data),
        .pitch_detected(pitch_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            serial_data = 0;
            repeat(10) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Correct Target Frequency", test_num);
            reset_dut();


            repeat(10) begin
                serial_data = 1;
                repeat(TARGET_HALF_PERIOD) @(posedge clk);
                serial_data = 0;
                repeat(TARGET_HALF_PERIOD) @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Frequency Too High (Wrong Pitch)", test_num);
            reset_dut();

            repeat(20) begin
                serial_data = 1;
                repeat(TARGET_HALF_PERIOD / 2) @(posedge clk);
                serial_data = 0;
                repeat(TARGET_HALF_PERIOD / 2) @(posedge clk);
            end

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Frequency Too Low (Wrong Pitch)", test_num);
            reset_dut();

            repeat(5) begin
                serial_data = 1;
                repeat(TARGET_HALF_PERIOD * 2) @(posedge clk);
                serial_data = 0;
                repeat(TARGET_HALF_PERIOD * 2) @(posedge clk);
            end

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Static Low Signal", test_num);
            reset_dut();

            serial_data = 0;
            repeat(TARGET_HALF_PERIOD * 10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Static High Signal", test_num);
            reset_dut();

            serial_data = 1;
            repeat(TARGET_HALF_PERIOD * 10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Inconsistent Signal (Noise)", test_num);
            reset_dut();

            repeat(5) begin
                serial_data = 1; repeat(TARGET_HALF_PERIOD - 500) @(posedge clk);
                serial_data = 0; repeat(TARGET_HALF_PERIOD + 500) @(posedge clk);
                serial_data = 1; repeat(TARGET_HALF_PERIOD + 1000) @(posedge clk);
                serial_data = 0; repeat(TARGET_HALF_PERIOD - 1000) @(posedge clk);
            end

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
        $display("pitch_detection Testbench");
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
        input expected_pitch_detected;
        begin
            if (expected_pitch_detected === (expected_pitch_detected ^ pitch_detected ^ expected_pitch_detected)) begin
                $display("PASS");
                $display("  Outputs: pitch_detected=%b",
                         pitch_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_detected=%b",
                         expected_pitch_detected);
                $display("  Got:      pitch_detected=%b",
                         pitch_detected);
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
        $dumpvars(0,clk, reset, serial_data, pitch_detected);
    end

endmodule
