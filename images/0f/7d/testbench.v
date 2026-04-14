`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bias_in;
    reg clk;
    reg [7:0] gradient_in;
    reg [7:0] learning_rate;
    reg rst;
    reg [7:0] weight_in;
    wire [7:0] bias_out;
    wire [7:0] weight_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .bias_in(bias_in),
        .clk(clk),
        .gradient_in(gradient_in),
        .learning_rate(learning_rate),
        .rst(rst),
        .weight_in(weight_in),
        .bias_out(bias_out),
        .weight_out(weight_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            bias_in = 0;
            weight_in = 0;
            gradient_in = 0;
            learning_rate = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Zero Gradient");
            reset_dut();
            weight_in     = 8'd100;
            bias_in       = 8'd50;
            gradient_in   = 8'd0;
            learning_rate = 8'd5;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd50, 8'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Standard Update");
            reset_dut();
            weight_in     = 8'd100;
            bias_in       = 8'd80;
            gradient_in   = 8'd2;
            learning_rate = 8'd10;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd60, 8'd80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Zero Learning Rate");
            reset_dut();
            weight_in     = 8'd200;
            bias_in       = 8'd150;
            gradient_in   = 8'd25;
            learning_rate = 8'd0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd150, 8'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Underflow (Wrap around)");
            reset_dut();
            weight_in     = 8'd10;
            bias_in       = 8'd5;
            gradient_in   = 8'd2;
            learning_rate = 8'd10;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hF1, 8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Large Delta");
            reset_dut();
            weight_in     = 8'd255;
            bias_in       = 8'd255;
            gradient_in   = 8'd20;
            learning_rate = 8'd5;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h9B, 8'h9B);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Reset effect");
            reset_dut();
            weight_in     = 8'd100;
            bias_in       = 8'd100;
            gradient_in   = 8'd1;
            learning_rate = 8'd1;

            rst = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("backpropagation Testbench");
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
        input [7:0] expected_bias_out;
        input [7:0] expected_weight_out;
        begin
            if (expected_bias_out === (expected_bias_out ^ bias_out ^ expected_bias_out) &&
                expected_weight_out === (expected_weight_out ^ weight_out ^ expected_weight_out)) begin
                $display("PASS");
                $display("  Outputs: bias_out=%h, weight_out=%h",
                         bias_out, weight_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bias_out=%h, weight_out=%h",
                         expected_bias_out, expected_weight_out);
                $display("  Got:      bias_out=%h, weight_out=%h",
                         bias_out, weight_out);
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
        $dumpvars(0,bias_in, clk, gradient_in, learning_rate, rst, weight_in, bias_out, weight_out);
    end

endmodule
