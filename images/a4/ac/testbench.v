`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] io_err;
    reg [7:0] io_in_data;
    reg io_in_vld;
    reg io_out_rdy;
    reg rstn;
    wire io_in_rdy;
    wire [7:0] io_out_data;
    wire io_out_vld;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_err(io_err),
        .io_in_data(io_in_data),
        .io_in_vld(io_in_vld),
        .io_out_rdy(io_out_rdy),
        .rstn(rstn),
        .io_in_rdy(io_in_rdy),
        .io_out_data(io_out_data),
        .io_out_vld(io_out_vld)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            io_in_data = 8'h0;
            io_in_vld = 0;
            io_out_rdy = 0;
            io_err = 5'h0;
            repeat(2) @(posedge clk);
            #1 rstn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Single Byte Transfer", test_num);
            reset_dut();


            io_out_rdy = 1;
            io_in_data = 8'hA5;
            io_in_vld = 1;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Output Backpressure", test_num);
            reset_dut();


            io_in_data = 8'h3C;
            io_in_vld = 1;
            io_out_rdy = 0;

            repeat(2) @(posedge clk);


            io_out_rdy = 1;
            repeat(1) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h3C, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Transfers", test_num);
            reset_dut();

            io_out_rdy = 1;


            io_in_data = 8'h11;
            io_in_vld = 1;
            repeat(2) @(posedge clk);


            io_in_data = 8'h22;
            io_in_vld = 1;
            repeat(2) @(posedge clk);


            io_in_data = 8'h33;
            io_in_vld = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h33, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input Valid Toggling", test_num);
            reset_dut();

            io_out_rdy = 1;
            io_in_vld = 0;
            io_in_data = 8'hFF;
            repeat(2) @(posedge clk);


            io_in_vld = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset During Operation", test_num);
            reset_dut();

            io_out_rdy = 1;
            io_in_data = 8'hD4;
            io_in_vld = 1;
            @(posedge clk);


            rstn = 0;
            repeat(2) @(posedge clk);
            rstn = 1;
            @(posedge clk);




            #1;





            check_outputs(1'b1, 8'h00, 1'b0);
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
        input expected_io_in_rdy;
        input [7:0] expected_io_out_data;
        input expected_io_out_vld;
        begin
            if (expected_io_in_rdy === (expected_io_in_rdy ^ io_in_rdy ^ expected_io_in_rdy) &&
                expected_io_out_data === (expected_io_out_data ^ io_out_data ^ expected_io_out_data) &&
                expected_io_out_vld === (expected_io_out_vld ^ io_out_vld ^ expected_io_out_vld)) begin
                $display("PASS");
                $display("  Outputs: io_in_rdy=%b, io_out_data=%h, io_out_vld=%b",
                         io_in_rdy, io_out_data, io_out_vld);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_in_rdy=%b, io_out_data=%h, io_out_vld=%b",
                         expected_io_in_rdy, expected_io_out_data, expected_io_out_vld);
                $display("  Got:      io_in_rdy=%b, io_out_data=%h, io_out_vld=%b",
                         io_in_rdy, io_out_data, io_out_vld);
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
        $dumpvars(0,clk, io_err, io_in_data, io_in_vld, io_out_rdy, rstn, io_in_rdy, io_out_data, io_out_vld);
    end

endmodule
