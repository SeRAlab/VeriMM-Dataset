`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    reg valid;
    wire data_ready;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .valid(valid),
        .data_ready(data_ready),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            serial_in = 0;
            valid = 0;
            repeat(2) @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 1;
            $display("Test %0d: Basic 8-bit sequence (0xA5)", test_num);
            reset_dut();
            test_val = 8'hA5;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = test_val[i];
                valid = 1;
                @(negedge clk);
            end
            valid = 0;
            #1;
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 2;
            $display("Test %0d: All ones (0xFF)", test_num);
            reset_dut();
            test_val = 8'hFF;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = test_val[i];
                valid = 1;
                @(negedge clk);
            end
            valid = 0;
            #1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 3;
            $display("Test %0d: Intermittent Valid Gating (0x3C)", test_num);
            reset_dut();
            test_val = 8'h3C;


            for (i = 7; i >= 4; i = i - 1) begin
                serial_in = test_val[i];
                valid = 1;
                @(negedge clk);
            end


            valid = 0;
            serial_in = 1;
            repeat(3) @(negedge clk);


            for (i = 3; i >= 0; i = i - 1) begin
                serial_in = test_val[i];
                valid = 1;
                @(negedge clk);
            end
            valid = 0;
            #1;
            #1;

            check_outputs(1'b1, 8'h3C);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 4;
            $display("Test %0d: Continuous zero sequence (0x00)", test_num);
            reset_dut();
            test_val = 8'h00;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = test_val[i];
                valid = 1;
                @(negedge clk);
            end
            valid = 0;
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] val1, val2;
        begin
            test_num = 5;
            $display("Test %0d: Back-to-back byte transfers", test_num);
            reset_dut();
            val1 = 8'h55;
            val2 = 8'hAA;


            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = val1[i];
                valid = 1;
                @(negedge clk);
            end

            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = val2[i];
                valid = 1;
                @(negedge clk);
            end
            valid = 0;
            #1;

            #1;


            check_outputs(1'b1, 8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input expected_data_ready;
        input [7:0] expected_parallel_out;
        begin
            if (expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: data_ready=%b, parallel_out=%h",
                         data_ready, parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ready=%b, parallel_out=%h",
                         expected_data_ready, expected_parallel_out);
                $display("  Got:      data_ready=%b, parallel_out=%h",
                         data_ready, parallel_out);
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
        $dumpvars(0,clk, rst, serial_in, valid, data_ready, parallel_out);
    end

endmodule
