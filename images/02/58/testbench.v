`timescale 1ns/1ps

module sliding_window_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] packet_data;
    reg packet_valid;
    reg rst;
    wire [7:0] ack_packet;
    wire ack_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_receiver dut (
        .clk(clk),
        .packet_data(packet_data),
        .packet_valid(packet_valid),
        .rst(rst),
        .ack_packet(ack_packet),
        .ack_valid(ack_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            packet_data = 0;
            packet_valid = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: In-order reception (0, 1, 2)");
            reset_dut();


            packet_data = 8'd0; packet_valid = 1; @(posedge clk);

            packet_data = 8'd1; packet_valid = 1; @(posedge clk);

            packet_data = 8'd2; packet_valid = 1; @(posedge clk);

            packet_valid = 0;
            #1;
            #1;

            check_outputs(8'd2, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Duplicate packet handling");
            reset_dut();

            packet_data = 8'd0; packet_valid = 1; @(posedge clk);
            packet_data = 8'd1; packet_valid = 1; @(posedge clk);
            packet_data = 8'd1; packet_valid = 1; @(posedge clk);

            packet_valid = 0;
            #1;
            #1;

            check_outputs(8'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Gap in sequence (0, 2)");
            reset_dut();

            packet_data = 8'd0; packet_valid = 1; @(posedge clk);
            packet_data = 8'd2; packet_valid = 1; @(posedge clk);

            packet_valid = 0;
            #1;


            #1;



            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Filling the gap (0, 2, 1)");
            reset_dut();

            packet_data = 8'd0; packet_valid = 1; @(posedge clk);
            packet_data = 8'd2; packet_valid = 1; @(posedge clk);
            packet_data = 8'd1; packet_valid = 1; @(posedge clk);

            packet_valid = 0;
            #1;
            #1;

            check_outputs(8'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Packet outside window");
            reset_dut();

            packet_data = 8'd10; packet_valid = 1; @(posedge clk);

            packet_valid = 0;
            #1;

            #1;


            check_outputs(ack_packet, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_receiver Testbench");
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
        input [7:0] expected_ack_packet;
        input expected_ack_valid;
        begin
            if (expected_ack_packet === (expected_ack_packet ^ ack_packet ^ expected_ack_packet) &&
                expected_ack_valid === (expected_ack_valid ^ ack_valid ^ expected_ack_valid)) begin
                $display("PASS");
                $display("  Outputs: ack_packet=%h, ack_valid=%b",
                         ack_packet, ack_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_packet=%h, ack_valid=%b",
                         expected_ack_packet, expected_ack_valid);
                $display("  Got:      ack_packet=%h, ack_valid=%b",
                         ack_packet, ack_valid);
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
        $dumpvars(0,clk, packet_data, packet_valid, rst, ack_packet, ack_valid);
    end

endmodule
