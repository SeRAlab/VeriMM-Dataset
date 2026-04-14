`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read;
    reg reset;
    reg start;
    reg stop;
    reg write;
    wire ack;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .clk(clk),
        .read(read),
        .reset(reset),
        .start(start),
        .stop(stop),
        .write(write),
        .ack(ack),
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
            read = 0;
            write = 0;
            start = 0;
            stop = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Power-on Reset");
            reset_dut();
            #1;

            check_outputs(IDLE, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Transition to START");
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            #1;

            check_outputs(START, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: START followed by WRITE");
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            write = 1;
            @(posedge clk);
            write = 0;
            #1;

            check_outputs(WRITE, 1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: START followed by READ");
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            read = 1;
            @(posedge clk);
            read = 0;
            #1;

            check_outputs(READ, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: WRITE followed by STOP");
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            write = 1;
            @(posedge clk);
            write = 0;
            stop = 1;
            @(posedge clk);
            stop = 0;
            #1;

            check_outputs(STOP, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: STOP to IDLE transition");
            reset_dut();

            start = 1; @(posedge clk); start = 0;
            stop = 1; @(posedge clk); stop = 0;

            @(posedge clk);
            #1;

            check_outputs(IDLE, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input expected_ack;
        input expected_state;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, state=%b",
                         ack, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, state=%b",
                         expected_ack, expected_state);
                $display("  Got:      ack=%b, state=%b",
                         ack, state);
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
        $dumpvars(0,clk, read, reset, start, stop, write, ack, state);
    end

endmodule
