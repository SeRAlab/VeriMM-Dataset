`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_frame;
    wire busy;
    wire frame_sent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_frame(send_frame),
        .busy(busy),
        .frame_sent(frame_sent)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_frame = 0;
            ack = 0;
            test_num = test_num + 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: Basic successful transmission");
            reset_dut();


            send_frame = 1;
            @(posedge clk);
            send_frame = 0;


            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Verify busy signal is high during wait");
            reset_dut();


            send_frame = 1;
            @(posedge clk);
            send_frame = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Consecutive successful transmissions");
            reset_dut();


            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Ignore new send_frame while busy");
            reset_dut();


            send_frame = 1;
            @(posedge clk);
            send_frame = 0;


            repeat(2) @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;


            ack = 1;
            @(posedge clk);
            ack = 0;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Reset during active transmission");
            reset_dut();


            send_frame = 1;
            @(posedge clk);
            send_frame = 0;


            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: ACK received while idle");
            reset_dut();


            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


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
        input expected_frame_sent;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, frame_sent=%b",
                         busy, frame_sent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, frame_sent=%b",
                         expected_busy, expected_frame_sent);
                $display("  Got:      busy=%b, frame_sent=%b",
                         busy, frame_sent);
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
        $dumpvars(0,ack, clk, reset, send_frame, busy, frame_sent);
    end

endmodule
