`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] packet_in;
    reg rst;
    reg send_req;
    wire packet_received;
    wire packet_sent;
    wire [3:0] window_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .clk(clk),
        .packet_in(packet_in),
        .rst(rst),
        .send_req(send_req),
        .packet_received(packet_received),
        .packet_sent(packet_sent),
        .window_pos(window_pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_req = 0;
            packet_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Packet Send");
            test_num = 2;
            reset_dut();

            send_req = 1;
            packet_in = 8'hA5;
            @(posedge clk);
            #1;
            send_req = 0;
            packet_in = 8'h00;
            @(posedge clk);
            #1;




            #1;





            check_outputs(1'b0, 1'b0, 4'h1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running Testcase 003: Multiple Packet Sends");
            test_num = 3;
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                send_req = 1;
                packet_in = 8'hB0 + i;
                @(posedge clk);
                #1;
            end
            send_req = 0;
            packet_in = 8'h00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 4'h4);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Packet Reception");
            test_num = 4;
            reset_dut();



            packet_in = 8'hC1;
            @(posedge clk);
            #1;
            packet_in = 8'h00;
            @(posedge clk);
            #1;




            #1;





            check_outputs(1'b1, 1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Concurrent Send and Receive");
            test_num = 5;
            reset_dut();

            send_req = 1;
            packet_in = 8'hD1;
            @(posedge clk);
            #1;
            send_req = 0;
            packet_in = 8'h00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 4'h1);
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
        input expected_packet_received;
        input expected_packet_sent;
        input [3:0] expected_window_pos;
        begin
            if (expected_packet_received === (expected_packet_received ^ packet_received ^ expected_packet_received) &&
                expected_packet_sent === (expected_packet_sent ^ packet_sent ^ expected_packet_sent) &&
                expected_window_pos === (expected_window_pos ^ window_pos ^ expected_window_pos)) begin
                $display("PASS");
                $display("  Outputs: packet_received=%b, packet_sent=%b, window_pos=%h",
                         packet_received, packet_sent, window_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_received=%b, packet_sent=%b, window_pos=%h",
                         expected_packet_received, expected_packet_sent, expected_window_pos);
                $display("  Got:      packet_received=%b, packet_sent=%b, window_pos=%h",
                         packet_received, packet_sent, window_pos);
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
        $dumpvars(0,clk, packet_in, rst, send_req, packet_received, packet_sent, window_pos);
    end

endmodule
