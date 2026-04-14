`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg pop;
    reg push;
    reg reset;
    wire [2:0] depth;
    wire overflow;
    wire [3:0] stack_out;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LIFO_Stack dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .reset(reset),
        .depth(depth),
        .overflow(overflow),
        .stack_out(stack_out),
        .underflow(underflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        push = 0;
        pop = 0;
        data_in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset and Initial State", test_num);
        reset_dut();

        #1;


        check_outputs(3'd0, 1'b0, 4'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Push and Pop", test_num);
        reset_dut();


        push = 1; data_in = 4'hA; @(posedge clk);
        push = 0; @(posedge clk);


        pop = 1; @(posedge clk);
        pop = 0;
        #1;


        #1;



        check_outputs(3'd0, 1'b0, 4'hA, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: LIFO Behavior Check", test_num);
        reset_dut();


        push = 1; data_in = 4'h1; @(posedge clk);
        push = 1; data_in = 4'h2; @(posedge clk);
        push = 1; data_in = 4'h3; @(posedge clk);
        push = 0; @(posedge clk);


        pop = 1; @(posedge clk);
        pop = 0;
        #1;


        #1;



        check_outputs(3'd2, 1'b0, 4'h3, 1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Fill to Maximum Capacity (8 items)", test_num);
        reset_dut();


        for (i = 1; i <= 8; i = i + 1) begin
            push = 1; data_in = i[3:0]; @(posedge clk);
        end
        push = 0;
        #1;



        #1;




        check_outputs(3'd0, 1'b0, 4'h8, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Overflow Condition", test_num);
        reset_dut();


        push = 1;
        for (i = 1; i <= 8; i = i + 1) begin
            data_in = i[3:0]; @(posedge clk);
        end

        data_in = 4'hF; @(posedge clk);
        push = 0;
        #1;


        #1;



        check_outputs(3'd0, 1'b1, 4'h8, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Underflow Condition", test_num);
        reset_dut();


        pop = 1; @(posedge clk);
        pop = 0;
        #1;


        #1;



        check_outputs(3'd0, 1'b0, 4'h0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Interleaved Push and Pop", test_num);
        reset_dut();


        push = 1; data_in = 4'h4; @(posedge clk);
        push = 1; data_in = 4'h5; @(posedge clk);
        push = 0; pop = 1; @(posedge clk);
        pop = 0; push = 1; data_in = 4'h6; @(posedge clk);
        push = 0;
        #1;



        #1;




        check_outputs(3'd2, 1'b0, 4'h6, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LIFO_Stack Testbench");
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
        input [2:0] expected_depth;
        input expected_overflow;
        input [3:0] expected_stack_out;
        input expected_underflow;
        begin
            if (expected_depth === (expected_depth ^ depth ^ expected_depth) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_stack_out === (expected_stack_out ^ stack_out ^ expected_stack_out) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: depth=%h, overflow=%b, stack_out=%h, underflow=%b",
                         depth, overflow, stack_out, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: depth=%h, overflow=%b, stack_out=%h, underflow=%b",
                         expected_depth, expected_overflow, expected_stack_out, expected_underflow);
                $display("  Got:      depth=%h, overflow=%b, stack_out=%h, underflow=%b",
                         depth, overflow, stack_out, underflow);
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
        $dumpvars(0,clk, data_in, pop, push, reset, depth, overflow, stack_out, underflow);
    end

endmodule
