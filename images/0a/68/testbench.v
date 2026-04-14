`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg end_signal;
    reg reset;
    reg sleep;
    reg start;
    reg wakeup;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .end_signal(end_signal),
        .reset(reset),
        .sleep(sleep),
        .start(start),
        .wakeup(wakeup),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            end_signal = 0;
            sleep = 0;
            start = 0;
            wakeup = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: IDLE -> ACTIVE via start signal");
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: ACTIVE -> SLEEP via sleep signal");
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;

            sleep = 1;
            @(posedge clk);
            #1 sleep = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: SLEEP -> ACTIVE via wakeup signal");
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            sleep = 1;
            @(posedge clk);
            #1 sleep = 0;

            wakeup = 1;
            @(posedge clk);
            #1 wakeup = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: ACTIVE -> IDLE via end signal");
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;

            end_signal = 1;
            @(posedge clk);
            #1 end_signal = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Stay in IDLE (No signal)");
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Full Sequence Cycle (IDLE-ACTIVE-SLEEP-ACTIVE-IDLE)");
            reset_dut();


            start = 1; @(posedge clk); #1 start = 0;

            sleep = 1; @(posedge clk); #1 sleep = 0;

            wakeup = 1; @(posedge clk); #1 wakeup = 0;

            end_signal = 1; @(posedge clk); #1 end_signal = 0;

            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Ignore wakeup signal while in IDLE");
            reset_dut();
            wakeup = 1;
            @(posedge clk);
            #1 wakeup = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, end_signal, reset, sleep, start, wakeup, state);
    end

endmodule
