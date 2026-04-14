`timescale 1ns/1ps

module dwt_haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [7:0] approx_out;
    wire [7:0] detail_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_haar dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .approx_out(approx_out),
        .detail_out(detail_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            valid_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard Positive Pair", test_num);
            reset_dut();
            data_in = 8'd40; valid_in = 1; @(posedge clk);
            data_in = 8'd20; valid_in = 1; @(posedge clk);
            valid_in = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h1E, 8'h0A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Detail Result", test_num);
            reset_dut();
            data_in = 8'd20; valid_in = 1; @(posedge clk);
            data_in = 8'd40; valid_in = 1; @(posedge clk);
            valid_in = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h1E, 8'hF6, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical Values", test_num);
            reset_dut();
            data_in = 8'd100; valid_in = 1; @(posedge clk);
            data_in = 8'd100; valid_in = 1; @(posedge clk);
            valid_in = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h64, 8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Scale Values", test_num);
            reset_dut();
            data_in = 8'd255; valid_in = 1; @(posedge clk);
            data_in = 8'd255; valid_in = 1; @(posedge clk);
            valid_in = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'hFF, 8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Gradient", test_num);
            reset_dut();
            data_in = 8'd254; valid_in = 1; @(posedge clk);
            data_in = 8'd0;   valid_in = 1; @(posedge clk);
            valid_in = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h7F, 8'h7F, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_haar Testbench");
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
        input [7:0] expected_approx_out;
        input [7:0] expected_detail_out;
        input expected_valid_out;
        begin
            if (expected_approx_out === (expected_approx_out ^ approx_out ^ expected_approx_out) &&
                expected_detail_out === (expected_detail_out ^ detail_out ^ expected_detail_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: approx_out=%h, detail_out=%h, valid_out=%b",
                         approx_out, detail_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out=%h, detail_out=%h, valid_out=%b",
                         expected_approx_out, expected_detail_out, expected_valid_out);
                $display("  Got:      approx_out=%h, detail_out=%h, valid_out=%b",
                         approx_out, detail_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, approx_out, detail_out, valid_out);
    end

endmodule
