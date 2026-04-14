`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire frame_sent;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
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
        reset = 1;
        send = 0;
        ack = 0;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: System Reset");
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Start Transmission");
        reset_dut();
        send = 1;
        @(posedge clk);
        #2;
        send = 0;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Complete Transmission");
        reset_dut();


        send = 1;
        @(posedge clk);
        #2;
        send = 0;


        ack = 1;
        @(posedge clk);
        #2;
        ack = 0;


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Persistent Wait");
        reset_dut();

        send = 1;
        @(posedge clk);
        #2;
        send = 0;


        repeat(5) @(posedge clk);
        #2;


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Ignore send during Wait");
        reset_dut();


        send = 1;
        @(posedge clk);
        #2;


        send = 1;
        repeat(2) @(posedge clk);
        #2;
        send = 0;


        ack = 1;
        @(posedge clk);
        #2;
        ack = 0;


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: ACK without SEND");
        reset_dut();

        ack = 1;
        repeat(2) @(posedge clk);
        #2;
        ack = 0;


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Sequential Transmissions");
        reset_dut();


        send = 1; @(posedge clk); #2; send = 0;
        ack = 1;  @(posedge clk); #2; ack = 0;


        send = 1; @(posedge clk); #2; send = 0;
        ack = 1;  @(posedge clk); #2; ack = 0;


        #1;



        check_outputs(1'b0, 1'b0);
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
        testcase007();
        
        
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
        input expected_state;
        begin
            if (expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: frame_sent=%b, state=%b",
                         frame_sent, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_sent=%b, state=%b",
                         expected_frame_sent, expected_state);
                $display("  Got:      frame_sent=%b, state=%b",
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
        $dumpvars(0,ack, clk, reset, send, frame_sent, state);
    end

endmodule
