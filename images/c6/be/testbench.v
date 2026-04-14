`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg serial_in;
    reg shift;
    wire [3:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .serial_in(serial_in),
        .shift(shift),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        shift = 0;
        forever #5 shift = ~shift;
    end

        task reset_dut;

        begin
            serial_in = 0;
            repeat (4) @(posedge shift);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: Shift in 1111");
            reset_dut();
            serial_in = 1;
            repeat (4) @(posedge shift);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Shift in 1010");
            reset_dut();
            @(negedge shift) serial_in = 1;
            @(negedge shift) serial_in = 0;
            @(negedge shift) serial_in = 1;
            @(negedge shift) serial_in = 0;
            @(posedge shift);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Shift in 0110");
            reset_dut();
            @(negedge shift) serial_in = 0;
            @(negedge shift) serial_in = 1;
            @(negedge shift) serial_in = 1;
            @(negedge shift) serial_in = 0;
            @(posedge shift);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Overflow check (11110)");
            reset_dut();
            @(negedge shift) serial_in = 1;
            repeat(3) @(negedge shift);
            @(negedge shift) serial_in = 0;
            @(posedge shift);
            #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase005;

        begin
            $display("Running Test Case 005: Shift in 1000");
            reset_dut();
            @(negedge shift) serial_in = 1;
            @(negedge shift) serial_in = 0;
            @(negedge shift) serial_in = 0;
            @(negedge shift) serial_in = 0;
            @(posedge shift);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,serial_in, shift, parallel_out);
    end

endmodule
