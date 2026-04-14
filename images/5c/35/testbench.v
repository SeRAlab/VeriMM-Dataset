`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg reset_n;
    reg [1:0] select0;
    reg [1:0] select1;
    reg [1:0] wr_select;
    reg write;
    wire [7:0] delay;
    wire [7:0] position;
    wire [7:0] register0;
    wire [7:0] selected0;
    wire [7:0] selected1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset_n(reset_n),
        .select0(select0),
        .select1(select1),
        .wr_select(wr_select),
        .write(write),
        .delay(delay),
        .position(position),
        .register0(register0),
        .selected0(selected0),
        .selected1(selected1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            write = 0;
            data = 8'h00;
            wr_select = 2'b00;
            select0 = 2'b00;
            select1 = 2'b00;
            #20;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Register 0", test_num);
            reset_dut();

            @(posedge clk);
            write = 1;
            wr_select = 2'b00;
            data = 8'hA5;

            @(posedge clk);
            write = 0;
            select0 = 2'b00;
            select1 = 2'b01;
            #5;


            #1;



            check_outputs(8'h00, 8'h00, 8'hA5, 8'hA5, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Register 1", test_num);
            reset_dut();

            @(posedge clk);
            write = 1;
            wr_select = 2'b01;
            data = 8'h5A;

            @(posedge clk);
            write = 0;
            select0 = 2'b01;
            select1 = 2'b00;
            #5;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h5A, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Register 2 (delay)", test_num);
            reset_dut();

            @(posedge clk);
            write = 1;
            wr_select = 2'b10;
            data = 8'hC3;

            @(posedge clk);
            write = 0;
            select0 = 2'b10;
            select1 = 2'b10;
            #5;


            #1;



            check_outputs(8'hC3, 8'h00, 8'h00, 8'hC3, 8'hC3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Register 3 (position)", test_num);
            reset_dut();

            @(posedge clk);
            write = 1;
            wr_select = 2'b11;
            data = 8'h3C;

            @(posedge clk);
            write = 0;
            select0 = 2'b11;
            select1 = 2'b00;
            #5;


            #1;



            check_outputs(8'h00, 8'h3C, 8'h00, 8'h3C, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Write Enable behavior", test_num);
            reset_dut();

            @(posedge clk);
            write = 0;
            wr_select = 2'b00;
            data = 8'hFF;

            @(posedge clk);
            select0 = 2'b00;
            #5;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Register File Test", test_num);
            reset_dut();


            @(posedge clk);
            write = 1; wr_select = 2'b00; data = 8'h10;
            @(posedge clk);
            write = 1; wr_select = 2'b01; data = 8'h20;
            @(posedge clk);
            write = 1; wr_select = 2'b10; data = 8'h30;
            @(posedge clk);
            write = 1; wr_select = 2'b11; data = 8'h40;

            @(posedge clk);
            write = 0;
            select0 = 2'b01;
            select1 = 2'b10;
            #5;


            #1;



            check_outputs(8'h30, 8'h40, 8'h10, 8'h20, 8'h30);
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
        input [7:0] expected_delay;
        input [7:0] expected_position;
        input [7:0] expected_register0;
        input [7:0] expected_selected0;
        input [7:0] expected_selected1;
        begin
            if (expected_delay === (expected_delay ^ delay ^ expected_delay) &&
                expected_position === (expected_position ^ position ^ expected_position) &&
                expected_register0 === (expected_register0 ^ register0 ^ expected_register0) &&
                expected_selected0 === (expected_selected0 ^ selected0 ^ expected_selected0) &&
                expected_selected1 === (expected_selected1 ^ selected1 ^ expected_selected1)) begin
                $display("PASS");
                $display("  Outputs: delay=%h, position=%h, register0=%h, selected0=%h, selected1=%h",
                         delay, position, register0, selected0, selected1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: delay=%h, position=%h, register0=%h, selected0=%h, selected1=%h",
                         expected_delay, expected_position, expected_register0, expected_selected0, expected_selected1);
                $display("  Got:      delay=%h, position=%h, register0=%h, selected0=%h, selected1=%h",
                         delay, position, register0, selected0, selected1);
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
        $dumpvars(0,clk, data, reset_n, select0, select1, wr_select, write, delay, position, register0, selected0, selected1);
    end

endmodule
