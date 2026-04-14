`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_frame;
    reg clk;
    reg reset;
    reg send_frame;
    wire [3:0] acknowledged_frames;
    wire [3:0] sent_frames;
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
        .acknowledged_frames(acknowledged_frames),
        .sent_frames(sent_frames),
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
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h4, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Send Single Frame", test_num);
            reset_dut();

            send_frame = 1;
            @(posedge clk);
            #1;
            send_frame = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 4'h1, 4'h4, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill Window Capacity", test_num);
            reset_dut();

            repeat(4) begin
                send_frame = 1;
                @(posedge clk);
                #1;
            end
            send_frame = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 4'h4, 4'h4, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Receive Acknowledgment", test_num);
            reset_dut();


            repeat(2) begin
                send_frame = 1;
                @(posedge clk);
                #1;
            end
            send_frame = 0;


            ack_frame = 1;
            @(posedge clk);
            #1;
            ack_frame = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h1, 4'h2, 4'h5, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Window Full Blockage and Recovery", test_num);
            reset_dut();


            repeat(6) begin
                send_frame = 1;
                @(posedge clk);
                #1;
            end
            send_frame = 0;



            repeat(2) begin
                ack_frame = 1;
                @(posedge clk);
                #1;
            end
            ack_frame = 0;


            send_frame = 1;
            @(posedge clk);
            #1;
            send_frame = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'h2, 4'h5, 4'h6, 4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Wrap-around handling", test_num);
            reset_dut();


            repeat(3) begin
                repeat(4) begin
                    send_frame = 1;
                    @(posedge clk);
                    #1;
                end
                send_frame = 0;
                repeat(4) begin
                    ack_frame = 1;
                    @(posedge clk);
                    #1;
                end
                ack_frame = 0;
            end



            #1;




            check_outputs(4'hC, 4'hC, 4'h0, 4'hC);
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
        input [3:0] expected_acknowledged_frames;
        input [3:0] expected_sent_frames;
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
        begin
            if (expected_acknowledged_frames === (expected_acknowledged_frames ^ acknowledged_frames ^ expected_acknowledged_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: acknowledged_frames=%h, sent_frames=%h, window_end=%h, window_start=%h",
                         acknowledged_frames, sent_frames, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acknowledged_frames=%h, sent_frames=%h, window_end=%h, window_start=%h",
                         expected_acknowledged_frames, expected_sent_frames, expected_window_end, expected_window_start);
                $display("  Got:      acknowledged_frames=%h, sent_frames=%h, window_end=%h, window_start=%h",
                         acknowledged_frames, sent_frames, window_end, window_start);
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
        $dumpvars(0,ack_frame, clk, reset, send_frame, acknowledged_frames, sent_frames, window_end, window_start);
    end

endmodule
