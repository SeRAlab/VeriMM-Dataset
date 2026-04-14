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
        valid_in = 0;
        data_in = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic operation (40, 20)", test_num);
        reset_dut();

        data_in = 8'd40; valid_in = 1;
        @(posedge clk);
        data_in = 8'd20; valid_in = 1;
        @(posedge clk);
        valid_in = 0;
        data_in = 0;


        while(!valid_out) @(posedge clk);
        #1;

        check_outputs(8'd30, 8'd20, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Identical values (100, 100)", test_num);
        reset_dut();

        data_in = 8'd100; valid_in = 1;
        @(posedge clk);
        data_in = 8'd100; valid_in = 1;
        @(posedge clk);
        valid_in = 0;

        while(!valid_out) @(posedge clk);
        #1;

        check_outputs(8'd100, 8'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Truncation check (11, 4)", test_num);
        reset_dut();

        data_in = 8'd11; valid_in = 1;
        @(posedge clk);
        data_in = 8'd4; valid_in = 1;
        @(posedge clk);
        valid_in = 0;

        while(!valid_out) @(posedge clk);
        #1;

        check_outputs(8'd7, 8'd7, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum values (255, 255)", test_num);
        reset_dut();

        data_in = 8'd255; valid_in = 1;
        @(posedge clk);
        data_in = 8'd255; valid_in = 1;
        @(posedge clk);
        valid_in = 0;

        while(!valid_out) @(posedge clk);
        #1;

        check_outputs(8'd255, 8'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Negative difference (10, 30)", test_num);
        reset_dut();

        data_in = 8'd10; valid_in = 1;
        @(posedge clk);
        data_in = 8'd30; valid_in = 1;
        @(posedge clk);
        valid_in = 0;

        while(!valid_out) @(posedge clk);
        #1;

        check_outputs(8'd20, 8'hEC, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Gapped input (50, gap, 10)", test_num);
        reset_dut();

        data_in = 8'd50; valid_in = 1;
        @(posedge clk);
        valid_in = 0;
        repeat(3) @(posedge clk);
        data_in = 8'd10; valid_in = 1;
        @(posedge clk);
        valid_in = 0;

        while(!valid_out) @(posedge clk);
        #1;

        check_outputs(8'd30, 8'd40, 1'b1);
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
