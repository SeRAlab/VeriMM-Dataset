`timescale 1ns/1ps

module LIFO_stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] data_out;
    wire [1:0] depth;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LIFO_stack dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .rst(rst),
        .data_out(data_out),
        .depth(depth),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            push = 0;
            pop = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 2'b00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Push", test_num);
            reset_dut();
            data_in = 8'hA5;
            push = 1;
            @(posedge clk);
            #1 push = 0;

            #1;


            check_outputs(8'hA5, 2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill Stack to Full", test_num);
            reset_dut();


            data_in = 8'h11; push = 1; @(posedge clk); #1;

            data_in = 8'h22; push = 1; @(posedge clk); #1;

            data_in = 8'h33; push = 1; @(posedge clk); #1;

            data_in = 8'h44; push = 1; @(posedge clk); #1;
            push = 0;


            #1;



            check_outputs(8'h44, 2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LIFO Behavior Check", test_num);
            reset_dut();


            data_in = 8'h10; push = 1; @(posedge clk); #1;
            data_in = 8'h20; push = 1; @(posedge clk); #1;
            push = 0;


            pop = 1; @(posedge clk); #1;
            pop = 0;


            #1;



            check_outputs(8'h10, 2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pop All Elements", test_num);
            reset_dut();


            data_in = 8'h01; push = 1; @(posedge clk); #1;
            data_in = 8'h02; push = 1; @(posedge clk); #1;
            data_in = 8'h03; push = 1; @(posedge clk); #1;
            data_in = 8'h04; push = 1; @(posedge clk); #1;
            push = 0;


            pop = 1; @(posedge clk); #1;
            pop = 1; @(posedge clk); #1;
            pop = 1; @(posedge clk); #1;
            pop = 1; @(posedge clk); #1;
            pop = 0;


            #1;



            check_outputs(data_out, 2'b00, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow Test", test_num);
            reset_dut();


            data_in = 8'h11; push = 1; @(posedge clk); #1;
            data_in = 8'h22; push = 1; @(posedge clk); #1;
            data_in = 8'h33; push = 1; @(posedge clk); #1;
            data_in = 8'h44; push = 1; @(posedge clk); #1;
            data_in = 8'h55; push = 1; @(posedge clk); #1;
            push = 0;


            #1;



            check_outputs(8'h44, 2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Underflow Test", test_num);
            reset_dut();


            pop = 1; @(posedge clk); #1;
            pop = 0;


            #1;



            check_outputs(data_out, 2'b00, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LIFO_stack Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_depth;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_depth === (expected_depth ^ depth ^ expected_depth) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, depth=%h, empty=%b, full=%b",
                         data_out, depth, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, depth=%h, empty=%b, full=%b",
                         expected_data_out, expected_depth, expected_empty, expected_full);
                $display("  Got:      data_out=%h, depth=%h, empty=%b, full=%b",
                         data_out, depth, empty, full);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, depth, empty, full);
    end

endmodule
