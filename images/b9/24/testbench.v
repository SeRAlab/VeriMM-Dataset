`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg ready_b;
    reg reset;
    reg [2:0] threshold;
    reg valid_a;
    wire [3:0] data_out_bcd;
    wire [11:0] data_out_binary;
    wire ready_a;
    wire valid_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .ready_b(ready_b),
        .reset(reset),
        .threshold(threshold),
        .valid_a(valid_a),
        .data_out_bcd(data_out_bcd),
        .data_out_binary(data_out_binary),
        .ready_a(ready_a),
        .valid_b(valid_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_a = 0;
            data_in = 0;
            ready_b = 0;
            threshold = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\ntestcase%03d: Threshold 1, Input 25", test_num);
            reset_dut();

            threshold = 3'd1;
            ready_b = 1;


            valid_a = 1;
            data_in = 8'd25;
            @(posedge clk);
            while(!ready_a) @(posedge clk);
            #1 valid_a = 0;


            while(!valid_b) @(posedge clk);
            #1;


            #1;



            check_outputs(4'd5, 12'd25, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] vals [0:2];
        begin
            test_num = test_num + 1;
            $display("\ntestcase%03d: Threshold 3, Inputs 10, 20, 31", test_num);
            reset_dut();

            vals[0] = 8'd10; vals[1] = 8'd20; vals[2] = 8'd31;
            threshold = 3'd3;
            ready_b = 1;

            for(i=0; i<3; i=i+1) begin
                valid_a = 1;
                data_in = vals[i];
                @(posedge clk);
                while(!ready_a) @(posedge clk);
                #1 valid_a = 0;
                repeat(1) @(posedge clk);
            end

            while(!valid_b) @(posedge clk);
            #1;


            #1;



            check_outputs(4'd1, 12'd61, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\ntestcase%03d: Threshold 2, Large Sum (200 + 155)", test_num);
            reset_dut();

            threshold = 3'd2;
            ready_b = 1;


            valid_a = 1; data_in = 8'd200;
            @(posedge clk); while(!ready_a) @(posedge clk);
            #1 valid_a = 0; @(posedge clk);


            valid_a = 1; data_in = 8'd155;
            @(posedge clk); while(!ready_a) @(posedge clk);
            #1 valid_a = 0;

            while(!valid_b) @(posedge clk);
            #1;


            #1;



            check_outputs(4'd5, 12'd355, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\ntestcase%03d: Backpressure test (ready_b delay)", test_num);
            reset_dut();

            threshold = 3'd1;
            ready_b = 0;

            valid_a = 1; data_in = 8'd77;
            @(posedge clk); while(!ready_a) @(posedge clk);
            #1 valid_a = 0;


            repeat(5) @(posedge clk);

            if (valid_b === 1'b1) begin
                $display("  Success: valid_b asserted while ready_b is low.");
            end


            ready_b = 1;
            #1;
            #1;

            check_outputs(4'd7, 12'd77, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\ntestcase%03d: Max Threshold (7) with small values", test_num);
            reset_dut();

            threshold = 3'd7;
            ready_b = 1;

            for(i=0; i<7; i=i+1) begin
                valid_a = 1; data_in = 8'd2;
                @(posedge clk); while(!ready_a) @(posedge clk);
                #1 valid_a = 0; @(posedge clk);
            end

            while(!valid_b) @(posedge clk);
            #1;


            #1;



            check_outputs(4'd4, 12'd14, 1'b0, 1'b1);
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
        input [3:0] expected_data_out_bcd;
        input [11:0] expected_data_out_binary;
        input expected_ready_a;
        input expected_valid_b;
        begin
            if (expected_data_out_bcd === (expected_data_out_bcd ^ data_out_bcd ^ expected_data_out_bcd) &&
                expected_data_out_binary === (expected_data_out_binary ^ data_out_binary ^ expected_data_out_binary) &&
                expected_ready_a === (expected_ready_a ^ ready_a ^ expected_ready_a) &&
                expected_valid_b === (expected_valid_b ^ valid_b ^ expected_valid_b)) begin
                $display("PASS");
                $display("  Outputs: data_out_bcd=%h, data_out_binary=%h, ready_a=%b, valid_b=%b",
                         data_out_bcd, data_out_binary, ready_a, valid_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_bcd=%h, data_out_binary=%h, ready_a=%b, valid_b=%b",
                         expected_data_out_bcd, expected_data_out_binary, expected_ready_a, expected_valid_b);
                $display("  Got:      data_out_bcd=%h, data_out_binary=%h, ready_a=%b, valid_b=%b",
                         data_out_bcd, data_out_binary, ready_a, valid_b);
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
        $dumpvars(0,clk, data_in, ready_b, reset, threshold, valid_a, data_out_bcd, data_out_binary, ready_a, valid_b);
    end

endmodule
