`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    wire [3:0] next_packet;
    wire [3:0] send_window;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .next_packet(next_packet),
        .send_window(send_window)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase001: Filling window until saturation (N=4)");
            reset_dut();

            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(4, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase002: Single ACK received");
            reset_dut();

            repeat(5) @(posedge clk);

            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase003: Continuous ACKs");
            reset_dut();
            repeat(2) @(posedge clk);
            ack = 1;
            repeat(3) @(posedge clk);
            ack = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(7, 3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase004: Wrap-around handling (15 -> 0)");
            reset_dut();
            ack = 1;
            repeat(14) @(posedge clk);
            ack = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(2, 14);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase005: Mid-operation Reset");
            reset_dut();
            ack = 1;
            repeat(8) @(posedge clk);
            reset_dut();
            #1;
            #1;

            check_outputs(0, 0);
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
        input [3:0] expected_next_packet;
        input [3:0] expected_send_window;
        begin
            if (expected_next_packet === (expected_next_packet ^ next_packet ^ expected_next_packet) &&
                expected_send_window === (expected_send_window ^ send_window ^ expected_send_window)) begin
                $display("PASS");
                $display("  Outputs: next_packet=%h, send_window=%h",
                         next_packet, send_window);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_packet=%h, send_window=%h",
                         expected_next_packet, expected_send_window);
                $display("  Got:      next_packet=%h, send_window=%h",
                         next_packet, send_window);
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
        $dumpvars(0,ack, clk, rst, next_packet, send_window);
    end

endmodule
