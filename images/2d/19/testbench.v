`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] acknowledged_frames;
    wire [3:0] sent_frames;

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
            ack = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: System Reset");
            reset_dut();
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Transmission");
            reset_dut();
            repeat (3) begin
                send = 1;
                @(posedge clk);
                #1;
                send = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Basic Acknowledgment");
            reset_dut();

            repeat (2) begin
                send = 1; @(posedge clk); #1;
                send = 0; @(posedge clk); #1;
            end

            ack = 1; @(posedge clk); #1;
            ack = 0; @(posedge clk); #1;
            #1;

            check_outputs(4'd1, 4'd2);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Window Limit Enforcement");
            reset_dut();

            repeat (6) begin
                send = 1; @(posedge clk); #1;
                send = 0; @(posedge clk); #1;
            end

            #1;


            check_outputs(4'd0, 4'd4);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Sliding the Window");
            reset_dut();

            repeat (4) begin
                send = 1; @(posedge clk); #1;
                send = 0; @(posedge clk); #1;
            end

            repeat (2) begin
                ack = 1; @(posedge clk); #1;
                ack = 0; @(posedge clk); #1;
            end

            repeat (2) begin
                send = 1; @(posedge clk); #1;
                send = 0; @(posedge clk); #1;
            end
            #1;

            check_outputs(4'd2, 4'd6);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Cumulative Operation");
            reset_dut();

            repeat (2) begin send = 1; @(posedge clk); #1; end
            send = 0;
            repeat (2) begin ack = 1; @(posedge clk); #1; end
            ack = 0;
            repeat (3) begin send = 1; @(posedge clk); #1; end
            send = 0;
            ack = 1; @(posedge clk); #1;
            ack = 0;

            #1;


            check_outputs(4'd3, 4'd5);
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
        $dumpvars(0,ack, clk, rst, send, acknowledged_frames, sent_frames);
    end

endmodule
