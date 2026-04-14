`timescale 1ns/1ps

module ARQ_Protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg data_in;
    reg rst;
    wire data_out;
    wire error;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Protocol dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .error(error),
        .retransmit(retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Success on first try (Bit 1)");
            reset_dut();
            data_in = 1;
            ack = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Success on first try (Bit 0)");
            reset_dut();
            data_in = 0;
            ack = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Success after 1 retransmission");
            reset_dut();
            data_in = 1;
            ack = 0;
            @(posedge clk);
            #1;

            ack = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Failure after max retransmissions (3 retries)");
            reset_dut();
            data_in = 1;
            ack = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Success on the 3rd retry");
            reset_dut();
            data_in = 1;
            ack = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            ack = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_Protocol Testbench");
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
        input expected_data_out;
        input expected_error;
        input expected_retransmit;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, error=%b, retransmit=%b",
                         data_out, error, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, error=%b, retransmit=%b",
                         expected_data_out, expected_error, expected_retransmit);
                $display("  Got:      data_out=%b, error=%b, retransmit=%b",
                         data_out, error, retransmit);
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
        $dumpvars(0,ack, clk, data_in, rst, data_out, error, retransmit);
    end

endmodule
