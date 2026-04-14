`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg trigger;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .clk(clk),
        .reset(reset),
        .trigger(trigger),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            trigger = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Single Pulse", test_num);
            reset_dut();
            @(posedge clk);
            trigger = 1;
            @(posedge clk);
            trigger = 0;

            repeat(P_DUR + 2) @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long Trigger Pulse", test_num);
            reset_dut();
            @(posedge clk);
            trigger = 1;

            repeat(P_DUR + 5) @(posedge clk);
            trigger = 0;
            @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Back-to-back Pulses", test_num);
            reset_dut();
            @(posedge clk);
            trigger = 1;
            @(posedge clk);
            trigger = 0;
            repeat(P_DUR) @(posedge clk);

            trigger = 1;
            @(posedge clk);
            trigger = 0;
            repeat(P_DUR + 1) @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during active pulse", test_num);
            reset_dut();
            @(posedge clk);
            trigger = 1;
            @(posedge clk);
            trigger = 0;
            repeat(2) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pulse_generator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        $dumpvars(0,clk, reset, trigger, pulse);
    end

endmodule
