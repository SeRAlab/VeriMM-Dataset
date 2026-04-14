`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [1:0] in_0;
    reg [1:0] in_1;
    reg load;
    wire [7:0] data_out;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .in_0(in_0),
        .in_1(in_1),
        .load(load),
        .data_out(data_out),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            data_in = 8'h00;
            in_0 = 2'b00;
            in_1 = 2'b00;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load and Greater (in_0 > in_1)", test_num);

            load = 1;
            data_in = 8'hA5;
            in_0 = 2'b11;
            in_1 = 2'b01;
            @(posedge clk);
            load = 0;


            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 2'b10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Right Shift and Less (in_0 < in_1)", test_num);


            load = 1;
            data_in = 8'hFF;
            @(posedge clk);


            load = 0;
            in_0 = 2'b01;
            in_1 = 2'b10;
            @(posedge clk);

            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(8'hFD, 2'b01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Shifts and Equal (in_0 == in_1)", test_num);

            load = 1;
            data_in = 8'h80;
            @(posedge clk);

            load = 0;
            in_0 = 2'b11;
            in_1 = 2'b11;
            repeat(2) @(posedge clk);

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h20, 2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Register Emptying", test_num);

            load = 1;
            data_in = 8'h01;
            @(posedge clk);

            load = 0;
            in_0 = 2'b10;
            in_1 = 2'b00;
            @(posedge clk);

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 2'b10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Concatenation with Zeroed Reg", test_num);

            load = 1;
            data_in = 8'h00;
            in_0 = 2'b11;
            in_1 = 2'b11;
            @(posedge clk);

            load = 0;
            in_0 = 2'b00;
            in_1 = 2'b11;

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 2'b01);
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
        input [7:0] expected_data_out;
        input [1:0] expected_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, out=%h",
                         data_out, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, out=%h",
                         expected_data_out, expected_out);
                $display("  Got:      data_out=%h, out=%h",
                         data_out, out);
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
        $dumpvars(0,clk, data_in, in_0, in_1, load, data_out, out);
    end

endmodule
