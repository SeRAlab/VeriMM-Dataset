`timescale 1ns/1ps

module simple_nn_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] b;
    reg clk;
    reg [7:0] grad;
    reg rst;
    reg [7:0] w1;
    reg [7:0] w2;
    reg [7:0] x1;
    reg [7:0] x2;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_nn dut (
        .b(b),
        .clk(clk),
        .grad(grad),
        .rst(rst),
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            grad = 0;
            x1 = 0;
            x2 = 0;
            w1 = 0;
            w2 = 0;
            b = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            x1 = 8'd2;
            w1 = 8'd3;
            x2 = 8'd4;
            w2 = 8'd2;
            b  = 8'd5;
            grad = 8'd0;

            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 001: Basic Forward Pass");
            #1;

            check_outputs(8'h13);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x1 = 8'd0;
            w1 = 8'd10;
            x2 = 8'd0;
            w2 = 8'd10;
            b  = 8'h0A;
            grad = 8'd0;

            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 002: Zero Inputs (Bias result)");
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            x1 = 8'd1;
            x2 = 8'd1;
            w1 = 8'd10;
            w2 = 8'd10;
            b  = 8'd10;
            grad = 8'd0;
            @(posedge clk);


            #1 grad = 8'd5;
            @(posedge clk);
            #1 grad = 8'd0;

            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 003: Weight Update via Gradient");


            #1;



            check_outputs(8'h2D);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_nn Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [7:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,b, clk, grad, rst, w1, w2, x1, x2, y_out);
    end

endmodule
