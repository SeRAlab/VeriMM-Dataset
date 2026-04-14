`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] duration;
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
        .duration(duration),
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
            duration = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Verify pulse is HIGH during active duration (dur=5)", test_num);
            reset_dut();
            duration = 5;
            trigger = 1;
            @(posedge clk);
            #1 trigger = 0;


            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Verify pulse returns to LOW after duration (dur=5)", test_num);
            reset_dut();
            duration = 5;
            trigger = 1;
            @(posedge clk);
            #1 trigger = 0;


            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Minimum duration (dur=1) - Check active", test_num);
            reset_dut();
            duration = 1;
            trigger = 1;
            @(posedge clk);
            #1 trigger = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Minimum duration (dur=1) - Check completion", test_num);
            reset_dut();
            duration = 1;
            trigger = 1;
            @(posedge clk);
            #1 trigger = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Maximum duration (dur=15) - Check completion", test_num);
            reset_dut();
            duration = 15;
            trigger = 1;
            @(posedge clk);
            #1 trigger = 0;

            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Duration 0 behavior", test_num);
            reset_dut();
            duration = 0;
            trigger = 1;
            @(posedge clk);
            #1 trigger = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Overlapping trigger - Should ignore second trigger", test_num);
            reset_dut();
            duration = 4;
            trigger = 1;
            @(posedge clk);
            #1 trigger = 0;

            repeat(2) @(posedge clk);
            trigger = 1;
            @(posedge clk);
            #1 trigger = 0;

            repeat(3) @(posedge clk);
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
        $display("pulse_generator Testbench");
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
        $dumpvars(0,clk, duration, reset, trigger, pulse);
    end

endmodule
