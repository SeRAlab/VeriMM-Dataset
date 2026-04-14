`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ack;
    reg clk;
    reg receive;
    reg rst;
    reg send;
    wire [1:0] acknowledged_frames;
    wire [1:0] sent_frames;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack(ack),
        .clk(clk),
        .receive(receive),
        .rst(rst),
        .send(send),
        .acknowledged_frames(acknowledged_frames),
        .sent_frames(sent_frames)
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
            receive = 0;
            ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("DUT Reset.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Transmission", test_num);
            reset_dut();

            send = 1;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);


            #1;



            check_outputs(2'd0, 2'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Acknowledgment Handling", test_num);
            reset_dut();


            repeat(3) begin
                send = 1; @(posedge clk);
            end
            send = 0;


            ack = 2'd1;
            receive = 1;
            @(posedge clk);
            receive = 0;
            @(posedge clk);


            #1;



            check_outputs(2'd1, 2'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill Window and Wrap Around", test_num);
            reset_dut();

            repeat(4) begin
                send = 1; @(posedge clk);
            end
            send = 0;
            @(posedge clk);


            #1;



            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Window Full Protection", test_num);
            reset_dut();


            repeat(4) begin
                send = 1; @(posedge clk);
            end


            send = 1; @(posedge clk);
            send = 0;
            @(posedge clk);



            #1;




            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Cycle Wrap", test_num);
            reset_dut();


            repeat(4) begin
                send = 1; @(posedge clk);
            end
            send = 0;


            ack = 2'd2;
            receive = 1;
            @(posedge clk);
            receive = 0;


            send = 1;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);


            #1;



            check_outputs(2'd2, 2'd2);
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
        input [1:0] expected_acknowledged_frames;
        input [1:0] expected_sent_frames;
        begin
            if (expected_acknowledged_frames === (expected_acknowledged_frames ^ acknowledged_frames ^ expected_acknowledged_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames)) begin
                $display("PASS");
                $display("  Outputs: acknowledged_frames=%h, sent_frames=%h",
                         acknowledged_frames, sent_frames);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acknowledged_frames=%h, sent_frames=%h",
                         expected_acknowledged_frames, expected_sent_frames);
                $display("  Got:      acknowledged_frames=%h, sent_frames=%h",
                         acknowledged_frames, sent_frames);
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
        $dumpvars(0,ack, clk, receive, rst, send, acknowledged_frames, sent_frames);
    end

endmodule
