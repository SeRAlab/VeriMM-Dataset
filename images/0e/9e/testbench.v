`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] packet_data;
    reg reset;
    wire send_valid;
    wire [7:0] sent_packet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .packet_data(packet_data),
        .reset(reset),
        .send_valid(send_valid),
        .sent_packet(sent_packet)
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
            packet_data = 8'h00;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            packet_data = 8'hA1;
            #10;

            #1;


            check_outputs(1'b1, 8'hA1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            packet_data = 8'h01; #10;
            packet_data = 8'h02; #10;
            packet_data = 8'h03; #10;
            packet_data = 8'h04; #10;

            #1;


            check_outputs(1'b1, 8'h04);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            packet_data = 8'h01; #10;
            packet_data = 8'h02; #10;
            packet_data = 8'h03; #10;
            packet_data = 8'h04; #10;
            packet_data = 8'h05; #10;

            #1;


            check_outputs(1'b0, 8'h05);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            packet_data = 8'h10; #10;
            packet_data = 8'h20; #10;
            packet_data = 8'h30; #10;
            packet_data = 8'h40; #10;

            ack = 1; #10;
            ack = 0;
            packet_data = 8'h50; #10;

            #1;


            check_outputs(1'b1, 8'h50);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            packet_data = 8'hAA; #10;
            packet_data = 8'hBB; #10;
            packet_data = 8'hCC; #10;
            packet_data = 8'hDD; #10;

            ack = 1; #40;
            ack = 0;
            packet_data = 8'hEE; #10;

            #1;


            check_outputs(1'b1, 8'hEE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            packet_data = 8'h01; #10;
            packet_data = 8'h02; #10;
            reset_dut();
            packet_data = 8'hFF; #10;

            #1;


            check_outputs(1'b1, 8'hFF);
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
        input expected_send_valid;
        input [7:0] expected_sent_packet;
        begin
            if (expected_send_valid === (expected_send_valid ^ send_valid ^ expected_send_valid) &&
                expected_sent_packet === (expected_sent_packet ^ sent_packet ^ expected_sent_packet)) begin
                $display("PASS");
                $display("  Outputs: send_valid=%b, sent_packet=%h",
                         send_valid, sent_packet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: send_valid=%b, sent_packet=%h",
                         expected_send_valid, expected_sent_packet);
                $display("  Got:      send_valid=%b, sent_packet=%h",
                         send_valid, sent_packet);
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
        $dumpvars(0,ack, clk, packet_data, reset, send_valid, sent_packet);
    end

endmodule
