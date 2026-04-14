`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg [4:0] data_in;
    reg send;
    wire [4:0] data_out;
    wire send_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .data_in(data_in),
        .send(send),
        .data_out(data_out),
        .send_done(send_done)
    );

    // Clock generation (10ns period)
    initial begin
        ack = 0;
        forever #5 ack = ~ack;
    end

        task reset_dut;

        begin
            send = 1'b0;
            data_in = 5'b0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: Basic Transmission (0x15)");
            reset_dut();
            data_in = 5'b10101;
            send = 1'b1;
            #10;
            send = 1'b0;
            #40;
            #1;

            check_outputs(5'b10101, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Basic Transmission (0x0A)");
            reset_dut();
            data_in = 5'b01010;
            send = 1'b1;
            #10;
            send = 1'b0;
            #40;
            #1;

            check_outputs(5'b01010, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Maximum Value (0x1F)");
            reset_dut();
            data_in = 5'b11111;
            send = 1'b1;
            #10;
            send = 1'b0;
            #40;
            #1;

            check_outputs(5'b11111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Minimum Value (0x00)");
            reset_dut();
            data_in = 5'b00000;
            send = 1'b1;
            #10;
            send = 1'b0;
            #40;
            #1;

            check_outputs(5'b00000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Test Case 005: Idle State Verification");
            reset_dut();
            #50;


            #1;



            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Test Case 006: Consecutive Transmissions");
            reset_dut();

            data_in = 5'h01;
            send = 1'b1;
            #10;
            send = 1'b0;
            #40;


            data_in = 5'h1E;
            send = 1'b1;
            #10;
            send = 1'b0;
            #40;
            #1;

            check_outputs(5'h1E, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait Testbench");
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
        input [4:0] expected_data_out;
        input expected_send_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_send_done === (expected_send_done ^ send_done ^ expected_send_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, send_done=%b",
                         data_out, send_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, send_done=%b",
                         expected_data_out, expected_send_done);
                $display("  Got:      data_out=%h, send_done=%b",
                         data_out, send_done);
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
        $dumpvars(0,ack, data_in, send, data_out, send_done);
    end

endmodule
