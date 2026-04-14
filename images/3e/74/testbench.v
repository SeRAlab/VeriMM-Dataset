`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg audio_signal;
    reg clk;
    wire pitch_in_range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .audio_signal(audio_signal),
        .clk(clk),
        .pitch_in_range(pitch_in_range)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        audio_signal = 0;

        repeat(20) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: In-Range Frequency", test_num);
        reset_dut();


        apply_audio_signal(500, 20);


        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: High Frequency (Out of Range)", test_num);
        reset_dut();


        apply_audio_signal(100, 50);

        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Low Frequency (Out of Range)", test_num);
        reset_dut();


        apply_audio_signal(2000, 5);

        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Static High Signal", test_num);
        reset_dut();

        audio_signal = 1;
        repeat(100) @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Static Low Signal", test_num);
        reset_dut();

        audio_signal = 0;
        repeat(100) @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Boundary Frequency (Lower Edge)", test_num);
        reset_dut();

        apply_audio_signal(410, 20);

        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Boundary Frequency (Upper Edge)", test_num);
        reset_dut();

        apply_audio_signal(590, 20);

        @(posedge clk);
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
        input expected_pitch_in_range;
        begin
            if (expected_pitch_in_range === (expected_pitch_in_range ^ pitch_in_range ^ expected_pitch_in_range)) begin
                $display("PASS");
                $display("  Outputs: pitch_in_range=%b",
                         pitch_in_range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_in_range=%b",
                         expected_pitch_in_range);
                $display("  Got:      pitch_in_range=%b",
                         pitch_in_range);
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
        $dumpvars(0,audio_signal, clk, pitch_in_range);
    end

endmodule
