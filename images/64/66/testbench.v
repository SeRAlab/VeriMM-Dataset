`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg carry_in;
    reg clk;
    reg sub;
    wire borrow_out;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .carry_in(carry_in),
        .clk(clk),
        .sub(sub),
        .borrow_out(borrow_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            carry_in = 0;
            sub = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 8'h10; B = 8'h20; carry_in = 0; sub = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 8'h05; B = 8'h05; carry_in = 1; sub = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h0B);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 8'hFF; B = 8'h01; carry_in = 0; sub = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 8'h20; B = 8'h10; carry_in = 0; sub = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 8'h20; B = 8'h10; carry_in = 1; sub = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 8'h05; B = 8'h0A; carry_in = 0; sub = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'hFB);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 8'hFF; B = 8'hFF; carry_in = 0; sub = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 8'hFF; B = 8'hFF; carry_in = 1; sub = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'hFF);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_borrow_out;
        input [7:0] expected_sum;
        begin
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, sum=%h",
                         borrow_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, sum=%h",
                         expected_borrow_out, expected_sum);
                $display("  Got:      borrow_out=%b, sum=%h",
                         borrow_out, sum);
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
        $dumpvars(0,A, B, carry_in, clk, sub, borrow_out, sum);
    end

endmodule
