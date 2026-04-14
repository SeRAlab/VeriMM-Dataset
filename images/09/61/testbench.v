`timescale 1ns/1ps

module stop_and_wait_flow_control_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait_flow_control dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
        .busy(busy),
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
            send = 0;
            ack = 0;
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
            $display("Testcase 001: Checking idle state after reset...");
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Initiating send, checking for busy high...");
            reset_dut();
            send = 1;
            @(posedge clk);
            #1;
            send = 0;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Performing full handshake (Send followed by ACK)...");
            reset_dut();

            send = 1;
            @(posedge clk);
            #1;
            send = 0;

            @(posedge clk);
            #1;
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Verifying busy stays high during delayed ACK...");
            reset_dut();
            send = 1;
            @(posedge clk);
            #1;
            send = 0;

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Sending two consecutive packets with ACKs...");
            reset_dut();


            send = 1;
            @(posedge clk);
            #1;
            send = 0;
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;


            @(posedge clk);
            #1;
            send = 1;
            @(posedge clk);
            #1;
            send = 0;
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Verifying busy remains low if ACK is high but Send is low...");
            reset_dut();
            ack = 1;
            repeat(2) @(posedge clk);
            #1;
            ack = 0;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait_flow_control Testbench");
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
        input expected_busy;
        input [7:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,ack, clk, reset, send, busy, data_out);
    end

endmodule
