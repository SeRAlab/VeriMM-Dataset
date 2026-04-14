`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg error_detected;
    reg reset;
    wire ack;
    wire [3:0] attempt_count;
    wire [7:0] data_out;
    wire nak;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .clk(clk),
        .data_in(data_in),
        .error_detected(error_detected),
        .reset(reset),
        .ack(ack),
        .attempt_count(attempt_count),
        .data_out(data_out),
        .nak(nak)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            error_detected = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Success (No Errors)", test_num);
            reset_dut();

            data_in = 8'hAA;
            error_detected = 0;


            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 4'd1, 8'hAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Success after One Retry", test_num);
            reset_dut();

            data_in = 8'h55;
            error_detected = 1;

            @(posedge clk);
            #2;

            error_detected = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 4'd2, 8'h55, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Success after Three Attempts", test_num);
            reset_dut();

            data_in = 8'hFF;
            error_detected = 1;

            @(posedge clk);
            #2;
            @(posedge clk);
            #2;

            error_detected = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 4'd3, 8'hFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Success (Data 0x00)", test_num);
            reset_dut();

            data_in = 8'h00;
            error_detected = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 4'd1, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Errors checking NAK and count", test_num);
            reset_dut();

            data_in = 8'h12;
            error_detected = 1;

            repeat(4) @(posedge clk);
            #2;



            error_detected = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 4'd5, 8'h12, 1'b0);
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
        input expected_ack;
        input [3:0] expected_attempt_count;
        input [7:0] expected_data_out;
        input expected_nak;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_attempt_count === (expected_attempt_count ^ attempt_count ^ expected_attempt_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_nak === (expected_nak ^ nak ^ expected_nak)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, attempt_count=%h, data_out=%h, nak=%b",
                         ack, attempt_count, data_out, nak);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, attempt_count=%h, data_out=%h, nak=%b",
                         expected_ack, expected_attempt_count, expected_data_out, expected_nak);
                $display("  Got:      ack=%b, attempt_count=%h, data_out=%h, nak=%b",
                         ack, attempt_count, data_out, nak);
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
        $dumpvars(0,clk, data_in, error_detected, reset, ack, attempt_count, data_out, nak);
    end

endmodule
