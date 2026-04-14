`timescale 1ns/1ps

module binary_2bit_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [2:0] state;
    wire [1:0] count;
    wire done;
    wire [2:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_2bit_counter dut (
        .clk(clk),
        .reset(reset),
        .state(state),
        .count(count),
        .done(done),
        .next_state(next_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            state = 3'b000;
            @(posedge clk);
            #1;
            reset = 0;
            $display("DUT Reset performed.");
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Checking INIT state logic...");
            reset_dut();
            state = INIT;
            #2;

            #1;


            check_outputs(2'b00, 1'b0, INCREMENT);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Checking INCREMENT state logic...");
            reset_dut();
            state = INCREMENT;
            #2;


            #1;



            check_outputs(2'b01, 1'b0, DONE);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Checking DONE state logic...");
            reset_dut();
            state = DONE;
            #2;

            #1;


            check_outputs(2'b11, 1'b1, DONE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_2bit_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [1:0] expected_count;
        input expected_done;
        input [2:0] expected_next_state;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: count=%h, done=%b, next_state=%h",
                         count, done, next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, done=%b, next_state=%h",
                         expected_count, expected_done, expected_next_state);
                $display("  Got:      count=%h, done=%b, next_state=%h",
                         count, done, next_state);
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
        $dumpvars(0,clk, reset, state, count, done, next_state);
    end

endmodule
