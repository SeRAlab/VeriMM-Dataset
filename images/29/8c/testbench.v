`timescale 1ns/1ps

module stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg reset;
    wire [7:0] data_out;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stack dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .reset(reset),
        .data_out(data_out),
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
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Push and Pop", test_num);
        reset_dut();


        data_in = 8'hA1;
        push = 1;
        @(posedge clk);
        #1 push = 0;


        pop = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'hA1, 0);
        pop = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: LIFO Property Check", test_num);
        reset_dut();


        data_in = 8'h11;
        push = 1;
        @(posedge clk);
        #1;


        data_in = 8'h22;
        @(posedge clk);
        #1 push = 0;


        pop = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'h22, 0);
        pop = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Underflow Detection", test_num);
        reset_dut();


        pop = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(data_out, 1);
        pop = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Multi-depth Pop Sequence", test_num);
        reset_dut();


        push = 1;
        data_in = 8'h10; @(posedge clk); #1;
        data_in = 8'h20; @(posedge clk); #1;
        data_in = 8'h30; @(posedge clk); #1;
        push = 0;


        pop = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;


        #1;



        check_outputs(8'h20, 0);
        pop = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Full Depth Top Element Check", test_num);
        reset_dut();


        push = 1;
        data_in = 8'h01; @(posedge clk); #1;
        data_in = 8'h02; @(posedge clk); #1;
        data_in = 8'h03; @(posedge clk); #1;
        data_in = 8'h04; @(posedge clk); #1;
        push = 0;


        #1;



        check_outputs(8'h04, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stack Testbench");
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
        input expected_underflow;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, underflow=%b",
                         data_out, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, underflow=%b",
                         expected_data_out, expected_underflow);
                $display("  Got:      data_out=%h, underflow=%b",
                         data_out, underflow);
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
        $dumpvars(0,clk, data_in, pop, push, reset, data_out, underflow);
    end

endmodule
