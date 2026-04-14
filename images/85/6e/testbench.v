`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] hd_data_from_host;
    reg hd_read_from_host;
    reg rst;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .hd_data_from_host(hd_data_from_host),
        .hd_read_from_host(hd_read_from_host),
        .rst(rst),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            hd_read_from_host = 0;
            hd_data_from_host = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal operation (Correct sequence)", test_num);
            reset_dut();


            @(posedge clk);
            #1 enable = 1;
            @(posedge clk);


            for (integer i = 0; i < 4; i = i + 1) begin
                #1;
                hd_read_from_host = 1;
                hd_data_from_host = i;
                @(posedge clk);
            end

            #1 hd_read_from_host = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data mismatch detection", test_num);
            reset_dut();

            @(posedge clk);
            #1 enable = 1;
            @(posedge clk);


            #1 hd_read_from_host = 1; hd_data_from_host = 32'd0;
            @(posedge clk);


            #1 hd_read_from_host = 1; hd_data_from_host = 32'd99;
            @(posedge clk);

            #1 hd_read_from_host = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset error flag via enable rising edge", test_num);
            reset_dut();


            @(posedge clk);
            #1 enable = 1;
            @(posedge clk);
            #1 hd_read_from_host = 1; hd_data_from_host = 32'd5;
            @(posedge clk);
            #1 hd_read_from_host = 0;


            repeat(2) @(posedge clk);
            #1 enable = 0;
            repeat(2) @(posedge clk);
            #1 enable = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Discontinuous read valid sequence", test_num);
            reset_dut();

            @(posedge clk);
            #1 enable = 1;
            @(posedge clk);


            #1 hd_read_from_host = 1; hd_data_from_host = 32'd0;
            @(posedge clk);


            #1 hd_read_from_host = 0;
            repeat(3) @(posedge clk);


            #1 hd_read_from_host = 1; hd_data_from_host = 32'd1;
            @(posedge clk);
            #1 hd_read_from_host = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System reset (rst) effect", test_num);
            reset_dut();

            @(posedge clk);
            #1 enable = 1;
            @(posedge clk);
            #1 hd_read_from_host = 1; hd_data_from_host = 32'd0;
            @(posedge clk);


            #1 rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0);
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
        input expected_error;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: error=%b",
                         error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b",
                         expected_error);
                $display("  Got:      error=%b",
                         error);
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
        $dumpvars(0,clk, enable, hd_data_from_host, hd_read_from_host, rst, error);
    end

endmodule
