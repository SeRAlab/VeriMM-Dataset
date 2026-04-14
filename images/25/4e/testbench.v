`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg data_valid;
    reg rst;
    wire parity_error;
    wire [4:0] received_data;
    wire resend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .parity_error(parity_error),
        .received_data(received_data),
        .resend(resend)
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
            data_valid = 1'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Checking Reset/Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 5'b00000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Sending 5'b10101", test_num);
            reset_dut();
            data_in = 5'b10101;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 5'b10101, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Sending 5'b00000", test_num);
            reset_dut();
            data_in = 5'b00000;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 5'b00000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sending 5'b11111", test_num);
            reset_dut();
            data_in = 5'b11111;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 5'b11111, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Verifying output persistence", test_num);
            reset_dut();
            data_in = 5'b01100;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(1'b0, 5'b01100, 1'b0);
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
        input expected_parity_error;
        input [4:0] expected_received_data;
        input expected_resend;
        begin
            if (expected_parity_error === (expected_parity_error ^ parity_error ^ expected_parity_error) &&
                expected_received_data === (expected_received_data ^ received_data ^ expected_received_data) &&
                expected_resend === (expected_resend ^ resend ^ expected_resend)) begin
                $display("PASS");
                $display("  Outputs: parity_error=%b, received_data=%h, resend=%b",
                         parity_error, received_data, resend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity_error=%b, received_data=%h, resend=%b",
                         expected_parity_error, expected_received_data, expected_resend);
                $display("  Got:      parity_error=%b, received_data=%h, resend=%b",
                         parity_error, received_data, resend);
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
        $dumpvars(0,clk, data_in, data_valid, rst, parity_error, received_data, resend);
    end

endmodule
