`timescale 1ns/1ps

module stack_lifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [3:0] data_out;
    wire overflow;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stack_lifo dut (
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
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Push and Pop");
            reset_dut();


            data_in = 4'hA;
            push = 1;
            @(posedge clk);
            #1 push = 0;


            pop = 1;
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(4'hA, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: LIFO Verification");
            reset_dut();


            data_in = 4'h3;
            push = 1;
            @(posedge clk);
            #1;


            data_in = 4'h7;
            push = 1;
            @(posedge clk);
            #1 push = 0;


            pop = 1;
            @(posedge clk);
            #1 pop = 0;

            #1;


            check_outputs(4'h7, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Stack Overflow");
            reset_dut();

            push = 1;
            data_in = 4'h1; @(posedge clk); #1;
            data_in = 4'h2; @(posedge clk); #1;
            data_in = 4'h3; @(posedge clk); #1;
            data_in = 4'h4; @(posedge clk); #1;


            data_in = 4'h5;
            @(posedge clk);
            #1 push = 0;

            #1;


            check_outputs(data_out, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Stack Underflow");
            reset_dut();


            pop = 1;
            @(posedge clk);
            #1 pop = 0;

            #1;


            check_outputs(data_out, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Deep Pop Sequence");
            reset_dut();


            push = 1;
            data_in = 4'h1; @(posedge clk); #1;
            data_in = 4'h2; @(posedge clk); #1;
            data_in = 4'h3; @(posedge clk); #1;
            data_in = 4'h4; @(posedge clk); #1;
            push = 0;


            pop = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            pop = 0;


            #1;



            check_outputs(4'h2, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset mid-operation");
            reset_dut();

            push = 1;
            data_in = 4'hF; @(posedge clk); #1;
            data_in = 4'hE; @(posedge clk); #1;
            push = 0;

            reset_dut();

            pop = 1;
            @(posedge clk);
            #1 pop = 0;

            #1;


            check_outputs(data_out, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stack_lifo Testbench");
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
        input [3:0] expected_data_out;
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
