`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg rst_n;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .rst_n(rst_n),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        start = 0;
        src_addr = 0;
        dest_addr = 0;
        data_in = 0;
        #20;
        rst_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Basic Transfer", test_num);
        reset_dut();


        src_addr = 8'h0A;
        dest_addr = 8'h50;
        data_in = 8'hBC;


        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        wait(ready == 1);
        @(posedge clk);


        #1;



        check_outputs(8'hBC, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Different Address and Data", test_num);
        reset_dut();

        src_addr = 8'hFF;
        dest_addr = 8'h01;
        data_in = 8'h42;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait(ready == 1);
        @(posedge clk);

        #1;


        check_outputs(8'h42, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Zero Data Transfer", test_num);
        reset_dut();

        src_addr = 8'h11;
        dest_addr = 8'h22;
        data_in = 8'h00;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait(ready == 1);
        @(posedge clk);

        #1;


        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Max Data Transfer", test_num);
        reset_dut();

        src_addr = 8'hAA;
        dest_addr = 8'h55;
        data_in = 8'hFF;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait(ready == 1);
        @(posedge clk);

        #1;


        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Idle state after Reset", test_num);
        reset_dut();




        #20;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,clk, data_in, dest_addr, rst_n, src_addr, start, data_out, ready);
    end

endmodule
