`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg valid_in;
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire valid_out;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .valid_out(valid_out),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            x0 = 0;
            x1 = 0;
            x2 = 0;
            x3 = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: All inputs zero", test_num);
            reset_dut();
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd0; x3 = 8'd0;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out == 1'b1);
            #1;

            check_outputs(1'b1, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All inputs one", test_num);
            reset_dut();
            x0 = 8'd1; x1 = 8'd1; x2 = 8'd1; x3 = 8'd1;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            wait(valid_out == 1'b1);
            #1;

            check_outputs(1'b1, 16'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Maximum input values (255)", test_num);
            reset_dut();
            x0 = 8'd255; x1 = 8'd255; x2 = 8'd255; x3 = 8'd255;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            wait(valid_out == 1'b1);
            #1;

            check_outputs(1'b1, 16'd2550);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Inputs matching coefficients (1,2,3,4)", test_num);
            reset_dut();
            x0 = 8'd1; x1 = 8'd2; x2 = 8'd3; x3 = 8'd4;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            wait(valid_out == 1'b1);
            #1;

            check_outputs(1'b1, 16'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Arbitrary values (10,5,2,1)", test_num);
            reset_dut();
            x0 = 8'd10; x1 = 8'd5; x2 = 8'd2; x3 = 8'd1;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            wait(valid_out == 1'b1);
            #1;

            check_outputs(1'b1, 16'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Single input at x2", test_num);
            reset_dut();
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd100; x3 = 8'd0;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            wait(valid_out == 1'b1);
            #1;

            check_outputs(1'b1, 16'd300);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input expected_valid_out;
        input [15:0] expected_y;
        begin
            if (expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: valid_out=%b, y=%h",
                         valid_out, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_out=%b, y=%h",
                         expected_valid_out, expected_y);
                $display("  Got:      valid_out=%b, y=%h",
                         valid_out, y);
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
        $dumpvars(0,clk, rst, valid_in, x0, x1, x2, x3, valid_out, y);
    end

endmodule
