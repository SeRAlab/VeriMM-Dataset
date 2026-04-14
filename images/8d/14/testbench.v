`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [1:0] op;
    reg ready;
    reg reset;
    wire [7:0] C;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
        .ready(ready),
        .reset(reset),
        .C(C),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            op = 0;
            ready = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 8'h0A;
            B = 8'h14;
            op = 2'b00;
            ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h1E, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 8'h32;
            B = 8'h0A;
            op = 2'b01;
            ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h28, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 8'h0C;
            B = 8'h04;
            op = 2'b10;
            ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h30, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 8'h64;
            B = 8'h05;
            op = 2'b11;
            ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h14, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            op = 2'b00;
            ready = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 8'h05;
            B = 8'h0A;
            op = 2'b01;
            ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFB, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 8'h40;
            B = 8'h08;
            op = 2'b10;
            ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();

            A = 8'h01; B = 8'h01; op = 2'b00; ready = 1;
            @(posedge clk);
            #1;

            A = 8'h02; B = 8'h02; op = 2'b00; ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h04, 1'b1);
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
        input [7:0] expected_C;
        input expected_valid;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: C=%h, valid=%b",
                         C, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, valid=%b",
                         expected_C, expected_valid);
                $display("  Got:      C=%h, valid=%b",
                         C, valid);
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
        $dumpvars(0,A, B, clk, op, ready, reset, C, valid);
    end

endmodule
