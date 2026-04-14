`timescale 1ns/1ps

module serial_to_parallel_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg serial_in;
    reg shift;
    wire data_valid;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serial_to_parallel dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .serial_in(serial_in),
        .shift(shift),
        .data_valid(data_valid),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            en = 0;
            shift = 0;
            serial_in = 0;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] send_data;
        begin
            $display("\nTestcase 001: Basic 8-bit serial load (0xA5)");
            test_num = test_num + 1;
            reset_dut();

            send_data = 8'hA5;
            for (i = 7; i >= 0; i = i - 1) begin
                en = 1;
                shift = 1;
                serial_in = send_data[i];
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] send_data;
        begin
            $display("\nTestcase 002: Enable signal gating check");
            test_num = test_num + 1;
            reset_dut();

            send_data = 8'hFF;

            for (i = 0; i < 4; i = i + 1) begin
                en = 1;
                shift = 1;
                serial_in = send_data[i];
                @(posedge clk);
                #1;
            end


            en = 0;
            shift = 1;
            serial_in = 0;
            repeat(3) @(posedge clk);
            #1;


            en = 1;
            for (i = 4; i < 8; i = i + 1) begin
                serial_in = send_data[i];
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nTestcase 003: Shift signal gating check");
            test_num = test_num + 1;
            reset_dut();


            en = 1;
            shift = 0;
            serial_in = 1;
            repeat(5) @(posedge clk);
            #1;


            shift = 1;
            serial_in = 0;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        integer i, j;
        reg [7:0] test_vectors [0:1];
        begin
            $display("\nTestcase 004: Back-to-back 8-bit transfers");
            test_num = test_num + 1;
            reset_dut();

            test_vectors[0] = 8'h33;
            test_vectors[1] = 8'hCC;

            for (j = 0; j < 2; j = j + 1) begin
                for (i = 7; i >= 0; i = i - 1) begin
                    en = 1;
                    shift = 1;
                    serial_in = test_vectors[j][i];
                    @(posedge clk);
                    #1;
                end

            end

            #1;


            check_outputs(1'b1, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Reset mid-operation");
            test_num = test_num + 1;
            reset_dut();


            en = 1;
            shift = 1;
            serial_in = 1;
            repeat(4) @(posedge clk);
            #1;


            rst = 0;
            @(posedge clk);
            #1;
            rst = 1;


            serial_in = 0;
            for (int k=0; k<8; k++) begin
                serial_in = (k % 2 == 0) ? 0 : 1;
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(1'b1, 8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serial_to_parallel Testbench");
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
        input expected_data_valid;
        input [7:0] expected_parallel_out;
        begin
            if (expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: data_valid=%b, parallel_out=%h",
                         data_valid, parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_valid=%b, parallel_out=%h",
                         expected_data_valid, expected_parallel_out);
                $display("  Got:      data_valid=%b, parallel_out=%h",
                         data_valid, parallel_out);
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
        $dumpvars(0,clk, en, rst, serial_in, shift, data_valid, parallel_out);
    end

endmodule
