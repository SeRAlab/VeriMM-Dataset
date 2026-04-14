`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg data_ready;
    reg rst;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .data_ready(data_ready),
        .rst(rst),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack = 0;
            data_ready = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Normal Operation Cycle");
            reset_dut();

            data_ready = 1;
            @(posedge clk); #1;
            data_ready = 0;

            @(posedge clk); #1;

            ack = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Idle Persistence");
            reset_dut();

            data_ready = 0;
            repeat(3) @(posedge clk); #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: IDLE to SEND Transition");
            reset_dut();

            data_ready = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(SEND);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: WAIT State Persistence");
            reset_dut();

            data_ready = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;

            ack = 0;
            repeat(4) @(posedge clk); #1;

            #1;


            check_outputs(WAIT);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Mid-transaction Reset");
            reset_dut();

            data_ready = 1;
            @(posedge clk); #1;

            rst = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Sequential Transactions");
            reset_dut();


            data_ready = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            ack = 1;
            @(posedge clk); #1;


            data_ready = 1;
            ack = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(SEND);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_protocol Testbench");
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
        $dumpvars(0,ack, clk, data_ready, rst, state);
    end

endmodule
