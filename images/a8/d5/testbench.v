`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg ready_b;
    reg rst_n;
    reg valid_a;
    wire [9:0] data_out;
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
        .rst_n(rst_n),
        .valid_a(valid_a),
        .data_out(data_out),
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
            rst_n = 0;
            data_in = 0;
            valid_a = 0;
            ready_b = 1;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Accumulating 8 values (1 to 8)", test_num);

            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                valid_a = 1;
                @(posedge clk);
                while (!ready_a) @(posedge clk);
                #1;
            end
            valid_a = 0;



            #1;




            check_outputs(10'd36, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Reset mid-accumulation", test_num);


            for (i = 1; i <= 4; i = i + 1) begin
                data_in = 8'd10;
                valid_a = 1;
                @(posedge clk);
                #1;
            end


            rst_n = 0;
            #10 rst_n = 1;
            @(posedge clk);


            for (i = 1; i <= 8; i = i + 1) begin
                data_in = 8'd5;
                valid_a = 1;
                @(posedge clk);
                #1;
            end
            valid_a = 0;


            #1;



            check_outputs(10'd40, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Sparse valid_a signals", test_num);

            for (i = 0; i < 8; i = i + 1) begin
                data_in = 8'd2;
                valid_a = 1;
                @(posedge clk);
                #1;
                valid_a = 0;
                repeat(2) @(posedge clk);
            end


            #1;



            check_outputs(10'd16, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Downstream backpressure (ready_b=0)", test_num);

            ready_b = 0;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = 8'd10;
                valid_a = 1;
                @(posedge clk);
                #1;
            end
            valid_a = 0;


            repeat(3) @(posedge clk);


            if (valid_b === 1 && data_out === 10'd80 && ready_a === 0) begin
                ready_b = 1;
                @(posedge clk);
                #1;
                #1;

                check_outputs(10'd80, 1'b1, 1'b0);
            end else begin
                #1;

                check_outputs(10'd80, 1'b0, 1'b1);
            end
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Maximum data values", test_num);

            for (i = 0; i < 8; i = i + 1) begin
                data_in = 8'd100;
                valid_a = 1;
                @(posedge clk);
                #1;
            end
            valid_a = 0;


            #1;



            check_outputs(10'd800, 1'b0, 1'b1);
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
        input [9:0] expected_data_out;
        input expected_ready_a;
        input expected_valid_b;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready_a === (expected_ready_a ^ ready_a ^ expected_ready_a) &&
                expected_valid_b === (expected_valid_b ^ valid_b ^ expected_valid_b)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready_a=%b, valid_b=%b",
                         data_out, ready_a, valid_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready_a=%b, valid_b=%b",
                         expected_data_out, expected_ready_a, expected_valid_b);
                $display("  Got:      data_out=%h, ready_a=%b, valid_b=%b",
                         data_out, ready_a, valid_b);
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
        $dumpvars(0,clk, data_in, ready_b, rst_n, valid_a, data_out, ready_a, valid_b);
    end

endmodule
