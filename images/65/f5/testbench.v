`timescale 1ns/1ps

module doorbell_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg button_pressed;
    reg clk;
    reg ring_duration_elapsed;
    wire ring;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    doorbell dut (
        .areset(areset),
        .button_pressed(button_pressed),
        .clk(clk),
        .ring_duration_elapsed(ring_duration_elapsed),
        .ring(ring)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            button_pressed = 0;
            ring_duration_elapsed = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Button Pressed Transition");
            reset_dut();
            @(posedge clk);
            button_pressed = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Ring Duration Elapsed Transition");
            reset_dut();
            @(posedge clk);
            button_pressed = 1;
            @(posedge clk);
            button_pressed = 0;
            ring_duration_elapsed = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Hold Ring State");
            reset_dut();
            @(posedge clk);
            button_pressed = 1;
            @(posedge clk);
            button_pressed = 0;
            ring_duration_elapsed = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Stay in Idle State");
            reset_dut();
            button_pressed = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Async Reset while Ringing");
            reset_dut();
            @(posedge clk);
            button_pressed = 1;
            @(posedge clk);
            #2;
            areset = 1;
            #1;
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
        $display("doorbell Testbench");
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
        input expected_ring;
        begin
            if (expected_ring === (expected_ring ^ ring ^ expected_ring)) begin
                $display("PASS");
                $display("  Outputs: ring=%b",
                         ring);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ring=%b",
                         expected_ring);
                $display("  Got:      ring=%b",
                         ring);
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
        $dumpvars(0,areset, button_pressed, clk, ring_duration_elapsed, ring);
    end

endmodule
