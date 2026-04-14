`timescale 1ns/1ps

module sliding_window_fsm_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_packet;
    wire [1:0] current_packet;
    wire [1:0] state;
    wire window_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_fsm dut (
        .ack_received(ack_received),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
        .current_packet(current_packet),
        .state(state),
        .window_full(window_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_packet = 0;
            ack_received = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(2'd0, 2'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Send one packet", test_num);
            reset_dut();
            send_packet = 1;
            @(posedge clk);
            #1;
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd1, 2'd2, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fill the window completely", test_num);
            reset_dut();
            repeat(3) begin
                send_packet = 1;
                @(posedge clk);
                #1;
                send_packet = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(2'd3, 2'd2, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Send 3 packets and receive 1 ACK", test_num);
            reset_dut();

            repeat(3) begin
                send_packet = 1; @(posedge clk); #1;
                send_packet = 0; @(posedge clk); #1;
            end

            ack_received = 1;
            @(posedge clk);
            #1;
            ack_received = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd3, 2'd2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Block send when window full", test_num);
            reset_dut();

            repeat(3) begin
                send_packet = 1; @(posedge clk); #1;
                send_packet = 0; @(posedge clk); #1;
            end

            send_packet = 1;
            @(posedge clk);
            #1;
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd3, 2'd2, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_fsm Testbench");
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
        input [1:0] expected_current_packet;
        input [1:0] expected_state;
        input expected_window_full;
        begin
            if (expected_current_packet === (expected_current_packet ^ current_packet ^ expected_current_packet) &&
                expected_state === (expected_state ^ state ^ expected_state) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full)) begin
                $display("PASS");
                $display("  Outputs: current_packet=%h, state=%h, window_full=%b",
                         current_packet, state, window_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_packet=%h, state=%h, window_full=%b",
                         expected_current_packet, expected_state, expected_window_full);
                $display("  Got:      current_packet=%h, state=%h, window_full=%b",
                         current_packet, state, window_full);
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
        $dumpvars(0,ack_received, clk, reset, send_packet, current_packet, state, window_full);
    end

endmodule
