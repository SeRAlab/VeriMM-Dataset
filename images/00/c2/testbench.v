`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_request;
    wire [3:0] ack_count;
    wire can_send;
    wire [3:0] sent_count;
    wire [3:0] window_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_request(send_request),
        .ack_count(ack_count),
        .can_send(can_send),
        .sent_count(sent_count),
        .window_size(window_size)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_request = 0;
            ack = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();


            #1;



            check_outputs(4'h0, 1'b1, 4'h0, window_size);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Send a single message", test_num);
            reset_dut();

            @(posedge clk);
            send_request = 1;
            @(posedge clk);
            send_request = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h0, 1'b1, 4'h1, window_size);
        end
        endtask

    task testcase003;

        integer i;
        reg [3:0] current_window;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Fill the window completely", test_num);
            reset_dut();

            current_window = window_size;


            for (i = 0; i < current_window; i = i + 1) begin
                @(posedge clk);
                send_request = 1;
            end
            @(posedge clk);
            send_request = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0, 1'b0, current_window, current_window);
        end
        endtask

    task testcase004;

        integer i;
        reg [3:0] current_window;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Fill window and then acknowledge one message", test_num);
            reset_dut();

            current_window = window_size;


            for (i = 0; i < current_window; i = i + 1) begin
                @(posedge clk);
                send_request = 1;
            end
            @(posedge clk);
            send_request = 0;


            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h1, 1'b1, current_window, current_window);
        end
        endtask

    task testcase005;

        integer i;
        reg [3:0] current_window;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Send request ignored when window is full", test_num);
            reset_dut();

            current_window = window_size;


            for (i = 0; i < current_window; i = i + 1) begin
                @(posedge clk);
                send_request = 1;
            end

            @(posedge clk);
            send_request = 1;
            @(posedge clk);
            send_request = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0, 1'b0, current_window, current_window);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %0d: Counter wrap-around test", test_num);
            reset_dut();


            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
                send_request = 1;
                ack = 1;
            end

            @(posedge clk);
            send_request = 1;
            ack = 1;
            @(posedge clk);
            send_request = 0;
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0, 1'b1, 4'h0, window_size);
        end
        endtask

    task testcase007;

        integer i;
        reg [3:0] current_window;
        begin
            test_num = 7;
            $display("\nTestcase %0d: Simultaneous Send and Ack at full window", test_num);
            reset_dut();

            current_window = window_size;


            for (i = 0; i < current_window; i = i + 1) begin
                @(posedge clk);
                send_request = 1;
            end



            @(posedge clk);
            send_request = 1;
            ack = 1;
            @(posedge clk);
            send_request = 0;
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h1, 1'b0, current_window + 4'h1, current_window);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_controller Testbench");
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
        input [3:0] expected_ack_count;
        input expected_can_send;
        input [3:0] expected_sent_count;
        input [3:0] expected_window_size;
        begin
            if (expected_ack_count === (expected_ack_count ^ ack_count ^ expected_ack_count) &&
                expected_can_send === (expected_can_send ^ can_send ^ expected_can_send) &&
                expected_sent_count === (expected_sent_count ^ sent_count ^ expected_sent_count) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: ack_count=%h, can_send=%b, sent_count=%h, window_size=%h",
                         ack_count, can_send, sent_count, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_count=%h, can_send=%b, sent_count=%h, window_size=%h",
                         expected_ack_count, expected_can_send, expected_sent_count, expected_window_size);
                $display("  Got:      ack_count=%h, can_send=%b, sent_count=%h, window_size=%h",
                         ack_count, can_send, sent_count, window_size);
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
        $dumpvars(0,ack, clk, reset, send_request, ack_count, can_send, sent_count, window_size);
    end

endmodule
