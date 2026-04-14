`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [1:0] packet_in;
    reg reset;
    wire full_window;
    wire [1:0] packet_out;
    wire [1:0] sent_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .packet_in(packet_in),
        .reset(reset),
        .full_window(full_window),
        .packet_out(packet_out),
        .sent_count(sent_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            packet_in = 2'b00;
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
            $display("Test %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Send single packet (ID: 2'b10)", test_num);
            reset_dut();
            packet_in = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 2'b10, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Filling the window (4 packets)", test_num);
            reset_dut();


            packet_in = 2'b00; @(posedge clk); #2;

            packet_in = 2'b01; @(posedge clk); #2;

            packet_in = 2'b10; @(posedge clk); #2;

            packet_in = 2'b11; @(posedge clk); #2;


            #1;



            check_outputs(1'b1, 2'b11, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Acknowledge a packet to free window space", test_num);
            reset_dut();


            packet_in = 2'b00; @(posedge clk); #2;
            packet_in = 2'b01; @(posedge clk); #2;
            packet_in = 2'b10; @(posedge clk); #2;
            packet_in = 2'b11; @(posedge clk); #2;


            ack = 1;
            @(posedge clk);
            #2;
            ack = 0;


            #1;



            check_outputs(1'b0, 2'b11, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Attempt to send packet when window is full", test_num);
            reset_dut();


            packet_in = 2'b00; @(posedge clk); #2;
            packet_in = 2'b01; @(posedge clk); #2;
            packet_in = 2'b10; @(posedge clk); #2;
            packet_in = 2'b11; @(posedge clk); #2;


            packet_in = 2'b10; @(posedge clk); #2;



            #1;




            check_outputs(1'b1, 2'b11, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Sequential send and acknowledge", test_num);
            reset_dut();


            packet_in = 2'b01; @(posedge clk); #2;
            packet_in = 2'b10; @(posedge clk); #2;


            ack = 1; @(posedge clk); #2;
            ack = 0;


            packet_in = 2'b11; @(posedge clk); #2;


            #1;



            check_outputs(1'b0, 2'b11, 2'b10);
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
        input expected_full_window;
        input [1:0] expected_packet_out;
        input [1:0] expected_sent_count;
        begin
            if (expected_full_window === (expected_full_window ^ full_window ^ expected_full_window) &&
                expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_sent_count === (expected_sent_count ^ sent_count ^ expected_sent_count)) begin
                $display("PASS");
                $display("  Outputs: full_window=%b, packet_out=%h, sent_count=%h",
                         full_window, packet_out, sent_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: full_window=%b, packet_out=%h, sent_count=%h",
                         expected_full_window, expected_packet_out, expected_sent_count);
                $display("  Got:      full_window=%b, packet_out=%h, sent_count=%h",
                         full_window, packet_out, sent_count);
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
        $dumpvars(0,ack, clk, packet_in, reset, full_window, packet_out, sent_count);
    end

endmodule
