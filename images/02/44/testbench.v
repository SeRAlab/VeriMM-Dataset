`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data_out;
    wire data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rx = 1;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin

            @(posedge clk);
            rx = 0;
            repeat(CLKS_PER_BIT) @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                repeat(CLKS_PER_BIT) @(posedge clk);
            end


            rx = 1;
            repeat(CLKS_PER_BIT) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Sending 8'hA5 (10100101)");
            reset_dut();
            send_byte(8'hA5);

            repeat(2) @(posedge clk);
            if (!data_valid) @(posedge data_valid);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Sending 8'h5A (01011010)");
            reset_dut();
            send_byte(8'h5A);
            if (!data_valid) @(posedge data_valid);
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Sending 8'hFF (All ones)");
            reset_dut();
            send_byte(8'hFF);
            if (!data_valid) @(posedge data_valid);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Sending 8'h00 (All zeros)");
            reset_dut();
            send_byte(8'h00);
            if (!data_valid) @(posedge data_valid);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Sending 8'hC3 (Boundary bits)");
            reset_dut();
            send_byte(8'hC3);
            if (!data_valid) @(posedge data_valid);
            #1;

            check_outputs(8'hC3, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_data_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_valid=%b",
                         data_out, data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_valid=%b",
                         expected_data_out, expected_data_valid);
                $display("  Got:      data_out=%h, data_valid=%b",
                         data_out, data_valid);
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
        $dumpvars(0,clk, reset, rx, data_out, data_valid);
    end

endmodule
