`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg recv_ack;
    reg rst;
    wire [4:0] data_out;
    wire resend;
    wire [1:0] resend_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .clk(clk),
        .data_in(data_in),
        .recv_ack(recv_ack),
        .rst(rst),
        .data_out(data_out),
        .resend(resend),
        .resend_count(resend_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 5'b0;
            recv_ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial transmission successful (ACK immediately)", test_num);
            reset_dut();

            data_in = 5'b10101;
            recv_ack = 1;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(5'b10101, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Success after 1 retransmission (NACK then ACK)", test_num);
            reset_dut();

            data_in = 5'b01100;
            recv_ack = 0;

            @(posedge clk);
            #1;
            recv_ack = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(5'b01100, 1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Success after 2 retransmissions (Max allowed retries reached)", test_num);
            reset_dut();

            data_in = 5'b11111;
            recv_ack = 0;

            @(posedge clk);
            #1;
            recv_ack = 0;

            @(posedge clk);
            #1;
            recv_ack = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(5'b11111, 1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Persistent failure (Exceeds maximum 3 transmissions)", test_num);
            reset_dut();

            data_in = 5'b00001;
            recv_ack = 0;

            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;





            #1;






            check_outputs(5'b00001, 1'b1, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Different data pattern (0x00)", test_num);
            reset_dut();

            data_in = 5'b00000;
            recv_ack = 1;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00000, 1'b0, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ Testbench");
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
        input [4:0] expected_data_out;
        input expected_resend;
        input [1:0] expected_resend_count;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_resend === (expected_resend ^ resend ^ expected_resend) &&
                expected_resend_count === (expected_resend_count ^ resend_count ^ expected_resend_count)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, resend=%b, resend_count=%h",
                         data_out, resend, resend_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, resend=%b, resend_count=%h",
                         expected_data_out, expected_resend, expected_resend_count);
                $display("  Got:      data_out=%h, resend=%b, resend_count=%h",
                         data_out, resend, resend_count);
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
        $dumpvars(0,clk, data_in, recv_ack, rst, data_out, resend, resend_count);
    end

endmodule
