`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst_n;
    wire [7:0] data_out;
    wire empty;

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
        .rst_n(rst_n),
        .data_out(data_out),
        .empty(empty)
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
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            $display("Reset complete.");
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Push one, Pop one...");
            reset_dut();


            data_in = 8'hA5;
            push = 1;
            @(posedge clk);
            push = 0;


            pop = 1;
            @(posedge clk);
            pop = 0;

            #1;

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Push two, Pop one (Check LIFO order)...");
            reset_dut();


            data_in = 8'h11;
            push = 1;
            @(posedge clk);


            data_in = 8'h22;
            push = 1;
            @(posedge clk);
            push = 0;


            pop = 1;
            @(posedge clk);
            pop = 0;

            #1;

            #1;


            check_outputs(8'h22, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Push three, Pop three...");
            reset_dut();


            data_in = 8'h10; push = 1; @(posedge clk);
            data_in = 8'h20; push = 1; @(posedge clk);
            data_in = 8'h30; push = 1; @(posedge clk);
            push = 0;


            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 0;

            #1;

            #1;


            check_outputs(8'h10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Interleaved Push/Pop...");
            reset_dut();


            data_in = 8'hAA; push = 1; @(posedge clk);

            data_in = 8'hBB; push = 1; @(posedge clk);

            push = 0; pop = 1; @(posedge clk);

            pop = 0; data_in = 8'hCC; push = 1; @(posedge clk);

            push = 0; pop = 1; @(posedge clk);

            pop = 1; @(posedge clk);
            pop = 0;

            #1;

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Check empty flag after reset...");
            reset_dut();
            #1;


            if (empty === 1'b1) begin
                $display("PASS: Stack is empty after reset.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Stack not empty after reset.");
                fail_count = fail_count + 1;
            end
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b",
                         data_out, empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b",
                         expected_data_out, expected_empty);
                $display("  Got:      data_out=%h, empty=%b",
                         data_out, empty);
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
        $dumpvars(0,clk, data_in, pop, push, rst_n, data_out, empty);
    end

endmodule
