`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_received;
    reg error_detected;
    reg rst;
    reg send_data;
    wire data_out;
    wire resend_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .clk(clk),
        .data_received(data_received),
        .error_detected(error_detected),
        .rst(rst),
        .send_data(send_data),
        .data_out(data_out),
        .resend_signal(resend_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_data = 0;
            data_received = 0;
            error_detected = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Successful transmission (No Errors)", test_num);
            reset_dut();

            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;
            data_received = 1;
            error_detected = 0;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transmission with Error Detected", test_num);
            reset_dut();

            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;


            @(posedge clk);
            error_detected = 1;
            data_received = 1;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Successful recovery after resend", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;
            error_detected = 1;
            @(posedge clk);


            @(posedge clk);
            error_detected = 0;
            data_received = 1;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset during active error state", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            error_detected = 1;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;

            repeat (1) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_data_out;
        input expected_resend_signal;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_resend_signal === (expected_resend_signal ^ resend_signal ^ expected_resend_signal)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, resend_signal=%b",
                         data_out, resend_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, resend_signal=%b",
                         expected_data_out, expected_resend_signal);
                $display("  Got:      data_out=%b, resend_signal=%b",
                         data_out, resend_signal);
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
        $dumpvars(0,clk, data_received, error_detected, rst, send_data, data_out, resend_signal);
    end

endmodule
