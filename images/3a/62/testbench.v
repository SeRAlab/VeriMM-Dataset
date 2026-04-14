`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg error_detected;
    reg reset;
    wire data_out;
    wire request_resend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
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
            data_in = 0;
            error_detected = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: Success '1'...");
            reset_dut();
            data_in = 1;
            error_detected = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Success '0'...");
            reset_dut();
            data_in = 0;
            error_detected = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Error on '1'...");
            reset_dut();
            data_in = 1;
            error_detected = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Error on '0'...");
            reset_dut();
            data_in = 0;
            error_detected = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Test Case 005: Error followed by resend...");
            reset_dut();


            data_in = 1;
            error_detected = 1;
            @(posedge clk);


            #1 data_in = 1;
            error_detected = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_system Testbench");
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
        input expected_request_resend;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_request_resend === (expected_request_resend ^ request_resend ^ expected_request_resend)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, request_resend=%b",
                         data_out, request_resend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, request_resend=%b",
                         expected_data_out, expected_request_resend);
                $display("  Got:      data_out=%b, request_resend=%b",
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
