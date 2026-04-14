`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire [3:0] out_count;
    wire out_valid;
    wire [7:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .out_count(out_count),
        .out_valid(out_valid),
        .out_value(out_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Run of 5 identical values", test_num);
            reset_dut();


            @(posedge clk);
            data_valid = 1;
            data_in = 8'hAA;
            repeat(5) @(posedge clk);


            data_in = 8'hBB;
            @(posedge clk);
            data_valid = 0;


            #2;
            #1;

            check_outputs(4'd5, 1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiple short runs", test_num);
            reset_dut();

            @(posedge clk);
            data_valid = 1;

            data_in = 8'h11; repeat(2) @(posedge clk);

            data_in = 8'h22; repeat(3) @(posedge clk);

            data_in = 8'h33; @(posedge clk);

            data_valid = 0;
            #2;

            #1;


            check_outputs(4'd3, 1'b1, 8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum run length (15)", test_num);
            reset_dut();

            @(posedge clk);
            data_valid = 1;
            data_in = 8'hFF;
            repeat(15) @(posedge clk);


            data_in = 8'h00;
            @(posedge clk);
            data_valid = 0;

            #2;
            #1;

            check_outputs(4'd15, 1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating values (count of 1)", test_num);
            reset_dut();

            @(posedge clk);
            data_valid = 1;
            data_in = 8'hA1; @(posedge clk);
            data_in = 8'hB2; @(posedge clk);
            data_in = 8'hC3; @(posedge clk);

            data_valid = 0;
            #2;

            #1;


            check_outputs(4'd1, 1'b1, 8'hB2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 8 distinct runs in one stream", test_num);
            reset_dut();

            @(posedge clk);
            data_valid = 1;
            for (i = 1; i <= 9; i = i + 1) begin
                data_in = i[7:0];
                repeat(2) @(posedge clk);
            end

            data_valid = 0;
            #2;

            #1;


            check_outputs(4'd2, 1'b1, 8'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input [3:0] expected_out_count;
        input expected_out_valid;
        input [7:0] expected_out_value;
        begin
            if (expected_out_count === (expected_out_count ^ out_count ^ expected_out_count) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid) &&
                expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: out_count=%h, out_valid=%b, out_value=%h",
                         out_count, out_valid, out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_count=%h, out_valid=%b, out_value=%h",
                         expected_out_count, expected_out_valid, expected_out_value);
                $display("  Got:      out_count=%h, out_valid=%b, out_value=%h",
                         out_count, out_valid, out_value);
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
        $dumpvars(0,clk, data_in, data_valid, rst, out_count, out_valid, out_value);
    end

endmodule
