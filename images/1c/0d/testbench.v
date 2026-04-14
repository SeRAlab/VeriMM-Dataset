`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg ack_nack;
    reg clk;
    reg [4:0] data_in;
    reg reset;
    wire [4:0] data_out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .ack_nack(ack_nack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
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
            ack_nack = 0;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset Behavior");
            reset_dut();

            #1;


            check_outputs(5'h00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Successful Transmission with ACK");
            reset_dut();
            data_in = 5'h1A;
            ack_nack = 1;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(5'h1A, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Retransmission on NACK");
            reset_dut();
            data_in = 5'h0F;
            ack_nack = 0;
            repeat(2) @(posedge clk);
            #1;



            if (data_out === 5'h0F && state != 2'b00) begin
                pass_count = pass_count + 1;
                $display("PASS: Data 0x%h held due to NACK. State: %b", data_out, state);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Data not held or state returned to IDLE unexpectedly. State: %b", state);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Recovery from NACK to ACK");
            reset_dut();
            data_in = 5'h05;
            ack_nack = 0;
            @(posedge clk);
            #1;
            ack_nack = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(5'h05, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_system Testbench");
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
        input [4:0] expected_data_out;
        input [1:0] expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, state=%h",
                         data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, state=%h",
                         expected_data_out, expected_state);
                $display("  Got:      data_out=%h, state=%h",
                         data_out, state);
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
        $dumpvars(0,ack_nack, clk, data_in, reset, data_out, state);
    end

endmodule
