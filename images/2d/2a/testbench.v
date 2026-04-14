`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire [1:0] receiver_window;
    wire [1:0] sender_window;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
        .receiver_window(receiver_window),
        .sender_window(sender_window)
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Send 3 Frames", test_num);
            reset_dut();
            repeat(3) begin
                send = 1; @(posedge clk); #1;
            end
            send = 0;

            #1;


            check_outputs(2'd0, 2'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved Send and Ack", test_num);
            reset_dut();
            repeat(2) begin
                send = 1; @(posedge clk); #1;
                send = 0; ack = 1; @(posedge clk); #1;
                ack = 0;
            end

            #1;


            check_outputs(2'd2, 2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complete Window Send (4 Frames)", test_num);
            reset_dut();
            repeat(4) begin
                send = 1; @(posedge clk); #1;
            end
            send = 0;

            #1;


            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sender Stall (Send 5, Ack 0)", test_num);
            reset_dut();
            repeat(5) begin
                send = 1; @(posedge clk); #1;
            end
            send = 0;


            #1;



            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Slide Window After Stall", test_num);
            reset_dut();

            repeat(4) begin
                send = 1; @(posedge clk); #1;
            end
            send = 0;

            ack = 1; @(posedge clk); #1;
            ack = 0;

            send = 1; @(posedge clk); #1;
            send = 0;

            #1;


            check_outputs(2'd1, 2'd1);
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
        input [1:0] expected_receiver_window;
        input [1:0] expected_sender_window;
        begin
            if (expected_receiver_window === (expected_receiver_window ^ receiver_window ^ expected_receiver_window) &&
                expected_sender_window === (expected_sender_window ^ sender_window ^ expected_sender_window)) begin
                $display("PASS");
                $display("  Outputs: receiver_window=%h, sender_window=%h",
                         receiver_window, sender_window);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: receiver_window=%h, sender_window=%h",
                         expected_receiver_window, expected_sender_window);
                $display("  Got:      receiver_window=%h, sender_window=%h",
                         receiver_window, sender_window);
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
        $dumpvars(0,ack, clk, reset, send, receiver_window, sender_window);
    end

endmodule
