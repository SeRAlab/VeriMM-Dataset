`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] current_frame;
    wire [3:0] window_end;
    wire [3:0] window_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send(send),
        .current_frame(current_frame),
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
            rst = 1;
            send = 0;
            ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd7, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending frames within window", test_num);
            reset_dut();


            repeat (3) begin
                send = 1;
                @(posedge clk);
                #1;
            end
            send = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd3, 4'd7, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Filling the window", test_num);
            reset_dut();


            repeat (10) begin
                send = 1;
                @(posedge clk);
                #1;
            end
            send = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd8, 4'd7, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sliding window with ACK", test_num);
            reset_dut();


            repeat (5) begin
                send = 1;
                @(posedge clk);
                #1;
            end
            send = 0;



            ack = 4'd2;
            @(posedge clk);
            #1;
            ack = 0;


            #1;



            check_outputs(4'd5, 4'd10, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequence wrap-around", test_num);
            reset_dut();



            ack = 4'd10;
            @(posedge clk);
            #1;
            ack = 0;





            repeat (2) begin
                send = 1;
                @(posedge clk);
                #1;
            end
            send = 0;




            #1;





            check_outputs(4'd2, 4'd2, 4'd11);
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
        input [3:0] expected_current_frame;
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
        begin
            if (expected_current_frame === (expected_current_frame ^ current_frame ^ expected_current_frame) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: current_frame=%h, window_end=%h, window_start=%h",
                         current_frame, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_frame=%h, window_end=%h, window_start=%h",
                         expected_current_frame, expected_window_end, expected_window_start);
                $display("  Got:      current_frame=%h, window_end=%h, window_start=%h",
                         current_frame, window_end, window_start);
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
        $dumpvars(0,ack, clk, rst, send, current_frame, window_end, window_start);
    end

endmodule
