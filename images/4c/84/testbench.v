`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [2:0] io_address;
    reg io_read;
    reg io_write;
    reg [7:0] io_writedata;
    reg ps2data;
    reg rst_n;
    wire [7:0] io_readdata;
    wire ps2clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_address(io_address),
        .io_read(io_read),
        .io_write(io_write),
        .io_writedata(io_writedata),
        .ps2data(ps2data),
        .rst_n(rst_n),
        .io_readdata(io_readdata),
        .ps2clk(ps2clk)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Read at Address 0", test_num);
            reset_dut();

            io_address = 3'b000;
            io_read = 1;
            io_write = 0;
            io_writedata = 8'h00;
            ps2data = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h42, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Read at Address 7", test_num);
            reset_dut();

            io_address = 3'b111;
            io_read = 1;
            io_write = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h42, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write operation (verify ps2clk static LOW)", test_num);
            reset_dut();

            io_address = 3'b010;
            io_read = 0;
            io_write = 1;
            io_writedata = 8'hFF;
            ps2data = 1'b0;

            @(posedge clk);

            io_read = 1;
            io_write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h42, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Influence of ps2data on ps2clk", test_num);
            reset_dut();

            ps2data = 1'b0;
            #10;
            ps2data = 1'b1;
            #10;
            io_read = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h42, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Output check during active reset", test_num);

            rst_n = 0;
            io_read = 1;
            io_address = 3'b101;

            #15;

            #1;


            check_outputs(8'h42, 1'b0);

            rst_n = 1;
            #10;
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
        input [7:0] expected_io_readdata;
        input expected_ps2clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_readdata === (expected_io_readdata ^ io_readdata ^ expected_io_readdata) &&
                expected_ps2clk === (expected_ps2clk ^ ps2clk ^ expected_ps2clk)) begin
                $display("PASS");
                $display("  Outputs: io_readdata=%h, ps2clk=%b",
                         io_readdata, ps2clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_readdata=%h, ps2clk=%b",
                         expected_io_readdata, expected_ps2clk);
                $display("  Got:      io_readdata=%h, ps2clk=%b",
                         io_readdata, ps2clk);
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

endmodule
