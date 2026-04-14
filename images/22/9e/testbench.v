`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_bit;
    wire [7:0] sent_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_bit(send_bit),
        .sent_bit(sent_bit)
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
            send_bit = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Power-on Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Send Bit 1 and Receive ACK");
            reset_dut();
            send_bit = 1;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;
            send_bit = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Send Bit 0 and Receive ACK");
            reset_dut();
            send_bit = 0;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Hold Bit 1 until ACK arrives");
            reset_dut();
            send_bit = 1;
            @(posedge clk);

            repeat(3) @(posedge clk);

            if (sent_bit === 8'h01) begin
                $display("  Info: Bit held correctly before ACK");
            end
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Sequential Multi-bit Transmission (1 then 0)");
            reset_dut();


            send_bit = 1;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;


            send_bit = 0;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait Testbench");
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
        input [7:0] expected_sent_bit;
        begin
            if (expected_sent_bit === (expected_sent_bit ^ sent_bit ^ expected_sent_bit)) begin
                $display("PASS");
                $display("  Outputs: sent_bit=%h",
                         sent_bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sent_bit=%h",
                         expected_sent_bit);
                $display("  Got:      sent_bit=%h",
                         sent_bit);
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
        $dumpvars(0,ack, clk, reset, send_bit, sent_bit);
    end

endmodule
