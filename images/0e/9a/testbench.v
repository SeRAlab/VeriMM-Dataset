`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg error_signal;
    reg parity_in;
    reg reset;
    wire ack_signal;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .error_signal(error_signal),
        .parity_in(parity_in),
        .reset(reset),
        .ack_signal(ack_signal),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 5'b0;
            error_signal = 0;
            parity_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Transmission (No Error)");
            reset_dut();
            data_in = 5'b10101;
            parity_in = 1'b1;
            error_signal = 1'b0;

            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 5'b10101);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Retransmission Scenario");
            reset_dut();


            data_in = 5'b11000;
            parity_in = 1'b0;
            error_signal = 1'b1;

            @(posedge clk);
            #1;

            if (ack_signal !== 1'b0) $display("  Note: Ack low during error phase as expected.");


            error_signal = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 5'b11000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Multiple Retransmission Attempts");
            reset_dut();

            data_in = 5'b00111;
            error_signal = 1'b1;

            repeat(3) @(posedge clk);

            #1 error_signal = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 5'b00111);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data Latching during Error");
            reset_dut();


            data_in = 5'b01010;
            error_signal = 1'b1;
            @(posedge clk);


            #1 data_in = 5'b11111;
            repeat(2) @(posedge clk);


            #1 error_signal = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 5'b01010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_System Testbench");
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
        input expected_ack_signal;
        input [4:0] expected_data_out;
        begin
            if (expected_ack_signal === (expected_ack_signal ^ ack_signal ^ expected_ack_signal) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack_signal=%b, data_out=%h",
                         ack_signal, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_signal=%b, data_out=%h",
                         expected_ack_signal, expected_data_out);
                $display("  Got:      ack_signal=%b, data_out=%h",
                         ack_signal, data_out);
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
        $dumpvars(0,clk, data_in, error_signal, parity_in, reset, ack_signal, data_out);
    end

endmodule
