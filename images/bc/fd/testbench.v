`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [31:0] data_len;
    reg reset;
    wire [15:0] checksum;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_len(data_len),
        .reset(reset),
        .checksum(checksum),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            data_len = 32'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Data [0x11, 0x22, 0x33]", test_num);

            data_len = 3;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h00;

            #1;


            check_outputs(16'h0067, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Five Zeros", test_num);

            data_len = 5;
            repeat(5) begin
                data_in = 8'h00;
                @(posedge clk);
            end
            data_in = 8'h00;

            #1;


            check_outputs(16'h0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values [0xFF, 0xFF]", test_num);

            data_len = 2;
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'h00;

            #1;


            check_outputs(16'h01FF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Single Byte 'a'", test_num);

            data_len = 1;
            data_in = 8'h61; @(posedge clk);
            data_in = 8'h00;

            #1;


            check_outputs(16'h0062, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_checksum;
        input expected_valid;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, valid=%b",
                         checksum, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, valid=%b",
                         expected_checksum, expected_valid);
                $display("  Got:      checksum=%h, valid=%b",
                         checksum, valid);
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
        $dumpvars(0,clk, data_in, data_len, reset, checksum, valid);
    end

endmodule
