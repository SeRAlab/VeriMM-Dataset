`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg [15:0] max_packet_size;
    reg rst;
    wire [7:0] packet_out;
    wire packet_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .max_packet_size(max_packet_size),
        .rst(rst),
        .packet_out(packet_out),
        .packet_valid(packet_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            data_valid = 0;
            max_packet_size = 16'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Single byte transmission...");
            reset_dut();
            max_packet_size = 16'd10;
            data_in = 8'hA1;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;
            #1;

            check_outputs(8'hA1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Exact packet size...");
            reset_dut();
            max_packet_size = 16'd2;


            data_in = 8'hB1;
            data_valid = 1;
            @(posedge clk);
            #1;


            data_in = 8'hB2;
            @(posedge clk);
            #1;

            data_valid = 0;
            #1;

            check_outputs(8'hB2, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Packet rollover...");
            reset_dut();
            max_packet_size = 16'd2;


            data_in = 8'hC1;
            data_valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'hC2;
            @(posedge clk);
            #1;

            data_in = 8'hC3;
            @(posedge clk);
            #1;

            data_valid = 0;
            #1;

            check_outputs(8'hC3, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Intermittent data valid...");
            reset_dut();
            max_packet_size = 16'd5;

            data_in = 8'hD1;
            data_valid = 1;
            @(posedge clk);
            #1;

            data_valid = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            data_in = 8'hD2;
            data_valid = 1;
            @(posedge clk);
            #1;

            data_valid = 0;
            #1;

            check_outputs(8'hD2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Max size of 1...");
            reset_dut();
            max_packet_size = 16'd1;

            data_in = 8'hE1;
            data_valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'hE2;
            @(posedge clk);
            #1;

            data_valid = 0;
            #1;

            check_outputs(8'hE2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Check invalid state...");
            reset_dut();
            max_packet_size = 16'd10;
            data_valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(packet_out, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmenter Testbench");
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
        input [7:0] expected_packet_out;
        input expected_packet_valid;
        begin
            if (expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_packet_valid === (expected_packet_valid ^ packet_valid ^ expected_packet_valid)) begin
                $display("PASS");
                $display("  Outputs: packet_out=%h, packet_valid=%b",
                         packet_out, packet_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_out=%h, packet_valid=%b",
                         expected_packet_out, expected_packet_valid);
                $display("  Got:      packet_out=%h, packet_valid=%b",
                         packet_out, packet_valid);
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
        $dumpvars(0,clk, data_in, data_valid, max_packet_size, rst, packet_out, packet_valid);
    end

endmodule
