`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg start_transmit;
    wire frame_sent;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .ack_received(ack_received),
        .clk(clk),
        .reset(reset),
        .start_transmit(start_transmit),
        .frame_sent(frame_sent),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            start_transmit = 0;
            done_transmitting = 0;
            ack_received = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: IDLE to TRANSMIT transition", test_num);
            reset_dut();
            start_transmit = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, TRANSMIT);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: TRANSMIT to WAIT_FOR_ACK transition", test_num);
            reset_dut();

            start_transmit = 1;
            @(posedge clk);
            #1;

            start_transmit = 0;
            done_transmitting = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, WAIT_FOR_ACK);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Complete cycle (IDLE->TX->WAIT->IDLE)", test_num);
            reset_dut();

            start_transmit = 1;
            @(posedge clk); #1;

            start_transmit = 0;
            done_transmitting = 1;
            @(posedge clk); #1;

            done_transmitting = 0;
            ack_received = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Persistence in TRANSMIT state", test_num);
            reset_dut();
            start_transmit = 1;
            @(posedge clk); #1;

            start_transmit = 0;
            done_transmitting = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, TRANSMIT);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Persistence in WAIT_FOR_ACK state", test_num);
            reset_dut();
            start_transmit = 1; @(posedge clk); #1;
            done_transmitting = 1; @(posedge clk); #1;
            done_transmitting = 0;
            ack_received = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, WAIT_FOR_ACK);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input expected_frame_sent;
        input [1:0] expected_state;
        begin
            if (expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: frame_sent=%b, state=%h",
                         frame_sent, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_sent=%b, state=%h",
                         expected_frame_sent, expected_state);
                $display("  Got:      frame_sent=%b, state=%h",
                         frame_sent, state);
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
        $dumpvars(0,ack_received, clk, reset, start_transmit, frame_sent, state);
    end

endmodule
