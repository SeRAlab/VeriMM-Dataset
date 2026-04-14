`timescale 1ns/1ps

module LIFO_stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] data_out;
    wire is_empty;
    wire is_full;

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
        .is_empty(is_empty),
        .is_full(is_full)
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
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Verifying initial state (Empty)");

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Push one item and check top");
            @(posedge clk);
            push = 1;
            data_in = 8'hAA;
            @(posedge clk);
            push = 0;
            #1;

            #1;


            check_outputs(8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Verifying LIFO order (Push A, Push B, Pop B)");
            @(posedge clk);
            push = 1; data_in = 8'h11;
            @(posedge clk);
            push = 1; data_in = 8'h22;
            @(posedge clk);
            push = 0; pop = 1;
            @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(8'h11, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            $display("Testcase 004: Fill stack to check Full flag (assuming depth 4)");
            for (i = 1; i <= 4; i = i + 1) begin
                @(posedge clk);
                push = 1;
                data_in = i;
            end
            @(posedge clk);
            push = 0;
            #1;

            #1;


            check_outputs(8'h04, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            $display("Testcase 005: Fill stack then pop all items to verify empty flag");

            for (i = 1; i <= 4; i = i + 1) begin
                @(posedge clk);
                push = 1; data_in = i;
            end
            @(posedge clk);

            push = 0;
            pop = 1;
            repeat (4) @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(8'h01, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Pop from empty stack (Underflow)");
            @(posedge clk);
            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Simultaneous Push and Pop on non-empty stack");

            @(posedge clk);
            push = 1; data_in = 8'hA1;
            @(posedge clk);

            push = 1; data_in = 8'hA2;
            pop = 1;
            @(posedge clk);
            push = 0; pop = 0;
            #1;

            #1;


            check_outputs(8'hA2, 1'b0, 1'b0);
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
        input expected_is_empty;
        input expected_is_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_is_empty === (expected_is_empty ^ is_empty ^ expected_is_empty) &&
                expected_is_full === (expected_is_full ^ is_full ^ expected_is_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, is_empty=%b, is_full=%b",
                         data_out, is_empty, is_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, is_empty=%b, is_full=%b",
                         expected_data_out, expected_is_empty, expected_is_full);
                $display("  Got:      data_out=%h, is_empty=%b, is_full=%b",
                         data_out, is_empty, is_full);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, is_empty, is_full);
    end

endmodule
