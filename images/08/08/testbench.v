`timescale 1ns/1ps

module ARQ_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire ack_out;
    wire [7:0] data_out;
    wire request_retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .ack_out(ack_out),
        .data_out(data_out),
        .request_retransmit(request_retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Single Valid Packet");
            reset_dut();
            data_in = 8'h01;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h01, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: In-Order Multi-Packet Stream");
            reset_dut();


            data_in = 8'h01; valid_in = 1; @(posedge clk);

            data_in = 8'h02; @(posedge clk);

            data_in = 8'h03; @(posedge clk);

            valid_in = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h03, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Missing Sequence Detection (Gap)");
            reset_dut();


            data_in = 8'h01; valid_in = 1; @(posedge clk);

            data_in = 8'h03; valid_in = 1; @(posedge clk);

            valid_in = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Retransmission Recovery");
            reset_dut();


            data_in = 8'h01; valid_in = 1; @(posedge clk);
            data_in = 8'h03; valid_in = 1; @(posedge clk);


            data_in = 8'h02; valid_in = 1; @(posedge clk);

            valid_in = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h02, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Reset Mid-Stream Verification");
            reset_dut();

            data_in = 8'h01; valid_in = 1; @(posedge clk);
            data_in = 8'h02; valid_in = 1; @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            valid_in = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_Controller Testbench");
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
        input expected_ack_out;
        input [7:0] expected_data_out;
        input expected_request_retransmit;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_request_retransmit === (expected_request_retransmit ^ request_retransmit ^ expected_request_retransmit)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, data_out=%h, request_retransmit=%b",
                         ack_out, data_out, request_retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, data_out=%h, request_retransmit=%b",
                         expected_ack_out, expected_data_out, expected_request_retransmit);
                $display("  Got:      ack_out=%b, data_out=%h, request_retransmit=%b",
                         ack_out, data_out, request_retransmit);
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
        $dumpvars(0,clk, data_in, rst, valid_in, ack_out, data_out, request_retransmit);
    end

endmodule
