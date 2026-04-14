`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_frame;
    reg clk;
    reg reset;
    reg send_frame;
    wire frame_acknowledged;
    wire frame_sent;
    wire [3:0] window_end;
    wire [3:0] window_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_frame(ack_frame),
        .clk(clk),
        .reset(reset),
        .send_frame(send_frame),
        .frame_acknowledged(frame_acknowledged),
        .frame_sent(frame_sent),
        .window_end(window_end),
        .window_start(window_start)
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
            ack_frame = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();


            #1;



            check_outputs(0, 0, 4, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Frame Transmission", test_num);
            reset_dut();

            send_frame = 1;
            @(posedge clk);
            #1;

            if (frame_sent == 1) begin
                send_frame = 0;
                @(posedge clk);
                #1;

                check_outputs(0, 0, 4, 0);
            end else begin
                $display("FAIL: frame_sent did not assert");
                fail_count = fail_count + 1;
                send_frame = 0;
            end
            endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single ACK Processing", test_num);
            reset_dut();


            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);


            ack_frame = 1;
            @(posedge clk);
            #1;


            ack_frame = 0;
            @(posedge clk);


            #1;



            check_outputs(0, 0, 5, 1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill Window", test_num);
            reset_dut();


            repeat (4) begin
                send_frame = 1;
                @(posedge clk);
            end
            send_frame = 0;
            @(posedge clk);


            #1;



            check_outputs(0, 0, 4, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple ACKs sliding window", test_num);
            reset_dut();


            send_frame = 1;
            repeat (2) @(posedge clk);
            send_frame = 0;


            ack_frame = 1;
            repeat (2) @(posedge clk);
            ack_frame = 0;
            @(posedge clk);




            #1;





            check_outputs(0, 0, 6, 2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Send when window is full", test_num);
            reset_dut();


            send_frame = 1;
            repeat (4) @(posedge clk);



            @(posedge clk);
            #1;
            if (frame_sent == 1) begin
                $display("FAIL: frame_sent asserted when window was full");
                fail_count = fail_count + 1;
            end else begin
                send_frame = 0;
                @(posedge clk);

                #1;


                check_outputs(0, 0, 4, 0);
            end
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
        input expected_frame_acknowledged;
        input expected_frame_sent;
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
        begin
            if (expected_frame_acknowledged === (expected_frame_acknowledged ^ frame_acknowledged ^ expected_frame_acknowledged) &&
                expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: frame_acknowledged=%b, frame_sent=%b, window_end=%h, window_start=%h",
                         frame_acknowledged, frame_sent, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_acknowledged=%b, frame_sent=%b, window_end=%h, window_start=%h",
                         expected_frame_acknowledged, expected_frame_sent, expected_window_end, expected_window_start);
                $display("  Got:      frame_acknowledged=%b, frame_sent=%b, window_end=%h, window_start=%h",
                         frame_acknowledged, frame_sent, window_end, window_start);
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
        $dumpvars(0,ack_frame, clk, reset, send_frame, frame_acknowledged, frame_sent, window_end, window_start);
    end

endmodule
