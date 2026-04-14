`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] data_out;
    wire overflow;
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
        .rst(rst),
        .data_out(data_out),
        .overflow(overflow),
        .underflow(underflow)
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
            test_num = test_num + 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Basic Push and Pop");


            data_in = 8'hAA;
            push = 1;
            @(posedge clk);
            push = 0;


            pop = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 1'b0, 1'b0);
            pop = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Fill the stack to capacity");


            data_in = 8'h10; push = 1; @(posedge clk);
            data_in = 8'h20; push = 1; @(posedge clk);
            data_in = 8'h30; push = 1; @(posedge clk);
            data_in = 8'h40; push = 1; @(posedge clk);
            push = 0;
            #1;


            #1;



            check_outputs(8'h40, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Overflow Condition");


            data_in = 8'h01; push = 1; @(posedge clk);
            data_in = 8'h02; push = 1; @(posedge clk);
            data_in = 8'h03; push = 1; @(posedge clk);
            data_in = 8'h04; push = 1; @(posedge clk);


            data_in = 8'h05; push = 1; @(posedge clk);
            push = 0;
            #1;

            #1;


            check_outputs(8'h04, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Underflow Condition");


            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: LIFO functional order");


            data_in = 8'h11; push = 1; @(posedge clk);
            data_in = 8'h22; push = 1; @(posedge clk);
            push = 0;


            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;


            #1;



            check_outputs(8'h22, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Multiple Pushes then Multiple Pops");

            data_in = 8'hA1; push = 1; @(posedge clk);
            data_in = 8'hB2; push = 1; @(posedge clk);
            data_in = 8'hC3; push = 1; @(posedge clk);
            push = 0;


            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 0;
            #1;


            #1;



            check_outputs(8'hB2, 1'b0, 1'b0);
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
        input expected_overflow;
        input expected_underflow;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, overflow=%b, underflow=%b",
                         data_out, overflow, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, overflow=%b, underflow=%b",
                         expected_data_out, expected_overflow, expected_underflow);
                $display("  Got:      data_out=%h, overflow=%b, underflow=%b",
                         data_out, overflow, underflow);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, overflow, underflow);
    end

endmodule
