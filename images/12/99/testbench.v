`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg signal_a;
    reg signal_b;
    wire phase_diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .clk(clk),
        .signal_a(signal_a),
        .signal_b(signal_b),
        .phase_diff(phase_diff)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            signal_a = 0;
            signal_b = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Signal A leads Signal B");
            reset_dut();

            @(posedge clk);
            signal_a <= 1;
            signal_b <= 0;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Signal B leads Signal A");
            reset_dut();

            @(posedge clk);
            signal_a <= 0;
            signal_b <= 1;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Signals In-Phase (Both High)");
            reset_dut();

            @(posedge clk);
            signal_a <= 1;
            signal_b <= 1;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Signals In-Phase (Both Low)");
            reset_dut();

            @(posedge clk);
            signal_a <= 0;
            signal_b <= 0;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Transition from Lead to In-Phase");
            reset_dut();


            @(posedge clk);
            signal_a <= 1;
            signal_b <= 0;
            repeat (2) @(posedge clk);


            signal_b <= 1;
            repeat (2) @(posedge clk);

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
        $display("phase_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_phase_diff;
        begin
            if (expected_phase_diff === (expected_phase_diff ^ phase_diff ^ expected_phase_diff)) begin
                $display("PASS");
                $display("  Outputs: phase_diff=%b",
                         phase_diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_diff=%b",
                         expected_phase_diff);
                $display("  Got:      phase_diff=%b",
                         phase_diff);
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
        $dumpvars(0,clk, signal_a, signal_b, phase_diff);
    end

endmodule
