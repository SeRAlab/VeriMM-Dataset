`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg error_detected;
    reg reset;
    wire [4:0] data_out;
    wire request_resend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .error_detected(error_detected),
        .reset(reset),
        .data_out(data_out),
        .request_resend(request_resend)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 5'b0;
            error_detected = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Normal transmission (No Error)");
            test_num = 1;
            reset_dut();

            @(posedge clk);
            data_in = 5'h12;
            error_detected = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h12, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Error and successful retry");
            test_num = 2;
            reset_dut();


            @(posedge clk);
            data_in = 5'h0A;
            error_detected = 1;


            @(posedge clk);
            #1;
            if (request_resend == 1) begin
                data_in = 5'h0A;
                error_detected = 0;
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A, 0);
        end
        endtask

    task testcase003;

        integer i;
        reg [4:0] test_data [0:4];
        begin
            $display("\nTestcase 003: Successive transmission of 5 packets");
            test_num = 3;
            test_data[0] = 5'h01; test_data[1] = 5'h02; test_data[2] = 5'h04;
            test_data[3] = 5'h08; test_data[4] = 5'h10;

            reset_dut();

            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                data_in = test_data[i];
                error_detected = 0;
                #1;
            end

            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h10, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Persistent error handling");
            test_num = 4;
            reset_dut();

            @(posedge clk);
            data_in = 5'h1F;
            error_detected = 1;

            @(posedge clk);
            #1;
            data_in = 5'h1F;
            error_detected = 1;

            @(posedge clk);
            #1;
            data_in = 5'h1F;
            error_detected = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1F, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Mixed scenarios");
            test_num = 5;
            reset_dut();


            @(posedge clk);
            data_in = 5'h05; error_detected = 0;


            @(posedge clk);
            data_in = 5'h0E; error_detected = 1;


            @(posedge clk);
            data_in = 5'h0E; error_detected = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0E, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Reset mid-operation");
            test_num = 6;
            reset_dut();

            @(posedge clk);
            data_in = 5'h11;
            error_detected = 0;

            @(posedge clk);
            reset = 1;

            @(posedge clk);
            reset = 0;
            #1;

            #1;


            check_outputs(5'h00, 0);
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
        input [4:0] expected_data_out;
        input expected_request_resend;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_request_resend === (expected_request_resend ^ request_resend ^ expected_request_resend)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, request_resend=%b",
                         data_out, request_resend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, request_resend=%b",
                         expected_data_out, expected_request_resend);
                $display("  Got:      data_out=%h, request_resend=%b",
                         data_out, request_resend);
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
        $dumpvars(0,clk, data_in, error_detected, reset, data_out, request_resend);
    end

endmodule
