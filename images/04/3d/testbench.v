`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg reset;
    reg send;
    wire ack;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send(send),
        .ack(ack),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send = 0;
            data_in = 5'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Even Parity Data (00110) - Expecting immediate ACK", test_num);
            data_in = 5'b00110;
            send = 1;
            @(posedge clk);
            send = 0;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'b00110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Odd Parity Data (00111) - Expecting NACK after retries", test_num);
            data_in = 5'b00111;
            send = 1;
            @(posedge clk);
            send = 0;

            repeat(15) @(posedge clk);
            #1;

            check_outputs(1'b0, 5'b00111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Zero Data (00000) - Expecting ACK", test_num);
            data_in = 5'b00000;
            send = 1;
            @(posedge clk);
            send = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: High Density Even Parity (11110) - Expecting ACK", test_num);
            data_in = 5'b11110;
            send = 1;
            @(posedge clk);
            send = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'b11110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: All Ones (11111) - Expecting NACK after retries", test_num);
            data_in = 5'b11111;
            send = 1;
            @(posedge clk);
            send = 0;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(1'b0, 5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Mixed Even Parity (10100) - Expecting ACK", test_num);
            data_in = 5'b10100;
            send = 1;
            @(posedge clk);
            send = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'b10100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_System Testbench");
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
        input expected_ack;
        input [4:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, reset, send, ack, data_out);
    end

endmodule
