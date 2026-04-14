`timescale 1ns/1ps

module LIFOStack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst_n;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LIFOStack dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .rst_n(rst_n),
        .data_out(data_out),
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
        rst_n = 0;
        push = 0;
        pop = 0;
        data_in = 8'h00;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Push and Pop", test_num);
        reset_dut();


        @(negedge clk);
        data_in = 8'hAA;
        push = 1;
        @(negedge clk);
        push = 0;


        @(negedge clk);
        pop = 1;
        @(negedge clk);
        pop = 0;


        #1;
        #1;

        check_outputs(8'hAA, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: LIFO Ordering", test_num);
        reset_dut();


        @(negedge clk);
        push = 1; data_in = 8'h11;
        @(negedge clk);
        push = 1; data_in = 8'h22;
        @(negedge clk);
        push = 1; data_in = 8'h33;
        @(negedge clk);
        push = 0;


        @(negedge clk);
        pop = 1;
        @(negedge clk);

        @(negedge clk);
        pop = 0;


        #1;
        #1;

        check_outputs(8'h22, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Stack Full Flag", test_num);
        reset_dut();

        @(negedge clk);
        push = 1;
        for(i = 0; i < 8; i = i + 1) begin
            data_in = i;
            @(negedge clk);
        end
        push = 0;


        #1;
        #1;

        check_outputs(8'h07, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Stack Empty Flag", test_num);
        reset_dut();


        #1;
        if (empty === 1'b1) begin

            @(negedge clk);
            push = 1; data_in = 8'hFF;
            @(negedge clk);
            push = 0; pop = 1;
            @(negedge clk);
            pop = 0;
            #1;
            #1;

            check_outputs(8'hFF, 1'b1, 1'b0);
        end else begin
            $display("FAIL: Stack not empty after reset");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Interleaved Push and Pop", test_num);
        reset_dut();


        @(negedge clk);
        push = 1; data_in = 8'hA1;
        @(negedge clk);
        push = 1; data_in = 8'hB2;
        @(negedge clk);
        push = 0; pop = 1;
        @(negedge clk);
        pop = 0; push = 1; data_in = 8'hC3;
        @(negedge clk);
        push = 0;


        #1;
        #1;

        check_outputs(8'hC3, 1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LIFOStack Testbench");
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
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, pop, push, rst_n, data_out, empty, full);
    end

endmodule
