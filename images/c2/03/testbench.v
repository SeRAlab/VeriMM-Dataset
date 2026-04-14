`timescale 1ns/1ps

module one_shot_tb;

    // Testbench signals (sequential circuit)
    reg trigger;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    one_shot dut (
        .trigger(trigger),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        trigger = 0;
        forever #5 trigger = ~trigger;
    end

        task reset_dut;

        begin
            trigger = 0;
            rst_n = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse Start Verification", test_num);
            reset_dut();
            @(posedge clk);
            trigger <= 1;
            @(posedge clk);
            trigger <= 0;

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse Mid-duration Verification", test_num);
            reset_dut();
            @(posedge clk);
            trigger <= 1;
            @(posedge clk);
            trigger <= 0;

            repeat(PULSE_WIDTH_TICKS / 2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse Completion Verification", test_num);
            reset_dut();
            @(posedge clk);
            trigger <= 1;
            @(posedge clk);
            trigger <= 0;

            repeat(PULSE_WIDTH_TICKS + 1) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Non-retriggerable Verification", test_num);
            reset_dut();
            @(posedge clk);
            trigger <= 1;
            @(posedge clk);
            trigger <= 0;
            repeat(2) @(posedge clk);
            trigger <= 1;
            @(posedge clk);
            trigger <= 0;

            repeat(PULSE_WIDTH_TICKS) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Long Trigger Verification", test_num);
            reset_dut();
            @(posedge clk);
            trigger <= 1;

            repeat(PULSE_WIDTH_TICKS + 5) @(posedge clk);
            #2;
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
        $display("one_shot Testbench");
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
        input expected_pulse;
        begin
            if (expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: pulse=%b",
                         pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse=%b",
                         expected_pulse);
                $display("  Got:      pulse=%b",
                         pulse);
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
        $dumpvars(0,trigger, pulse);
    end

endmodule
