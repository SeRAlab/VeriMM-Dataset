`timescale 1ns/1ps

module cholesky_decomp_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [15:0] matrix_in;
    reg rst;
    wire [15:0] lower_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cholesky_decomp dut (
        .clk(clk),
        .en(en),
        .matrix_in(matrix_in),
        .rst(rst),
        .lower_out(lower_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            matrix_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Identity Matrix", test_num);
            matrix_in = {4'd1, 4'd0, 4'd0, 4'd1};
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            #1;

            check_outputs(16'h1001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Diagonal Matrix (4, 9)", test_num);
            matrix_in = {4'd4, 4'd0, 4'd0, 4'd9};
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            #1;

            check_outputs(16'h2003);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Full Matrix (4,2,2,5)", test_num);
            matrix_in = {4'd4, 4'd2, 4'd2, 4'd5};
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            #1;

            check_outputs(16'h2012);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Full Matrix (9,3,3,10)", test_num);
            matrix_in = {4'd9, 4'd3, 4'd3, 4'd10};
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            #1;

            check_outputs(16'h3013);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Minimal PD Matrix (1,1,1,2)", test_num);
            matrix_in = {4'd1, 4'd1, 4'd1, 4'd2};
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            #1;

            check_outputs(16'h1011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cholesky_decomp Testbench");
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
        input [15:0] expected_lower_out;
        begin
            if (expected_lower_out === (expected_lower_out ^ lower_out ^ expected_lower_out)) begin
                $display("PASS");
                $display("  Outputs: lower_out=%h",
                         lower_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lower_out=%h",
                         expected_lower_out);
                $display("  Got:      lower_out=%h",
                         lower_out);
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
        $dumpvars(0,clk, en, matrix_in, rst, lower_out);
    end

endmodule
