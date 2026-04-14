`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg reset_n;
    reg write_n;
    reg [31:0] writedata;
    wire [31:0] out_port;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .chipselect(chipselect),
        .clk(clk),
        .reset_n(reset_n),
        .write_n(write_n),
        .writedata(writedata),
        .out_port(out_port),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            address = 0;
            chipselect = 0;
            write_n = 1;
            writedata = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Addition Operation (0 + 100)", test_num);
            reset_dut();
            @(negedge clk);
            address = 2'b00;
            writedata = 32'd100;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);
            #2;
            write_n = 1;
            #1;

            check_outputs(32'd100, 32'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Subtraction Operation (0 - 50)", test_num);
            reset_dut();
            @(negedge clk);
            address = 2'b01;
            writedata = 32'd50;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);
            #2;
            write_n = 1;
            #1;

            check_outputs(32'hFFFFFFCE, 32'hFFFFFFCE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Bitwise AND Operation", test_num);
            reset_dut();

            @(negedge clk);
            address = 2'b00; writedata = 32'hFFFFFFFF; chipselect = 1; write_n = 0;
            @(posedge clk);

            @(negedge clk);
            address = 2'b10; writedata = 32'h12345678;
            @(posedge clk);
            #2;
            write_n = 1;
            #1;

            check_outputs(32'h12345678, 32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Bitwise OR Operation", test_num);
            reset_dut();

            @(negedge clk);
            address = 2'b00; writedata = 32'hF0F0F0F0; chipselect = 1; write_n = 0;
            @(posedge clk);

            @(negedge clk);
            address = 2'b11; writedata = 32'h0F0F0F0F;
            @(posedge clk);
            #2;
            write_n = 1;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Write Enable (write_n) Verification", test_num);
            reset_dut();
            @(negedge clk);
            address = 2'b00;
            writedata = 32'hABCDEF;
            chipselect = 1;
            write_n = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Chip Select (chipselect) Verification", test_num);
            reset_dut();
            @(negedge clk);
            address = 2'b00;
            writedata = 32'h1234;
            chipselect = 0;
            write_n = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Multiple Operations Sequence", test_num);
            reset_dut();
            @(negedge clk);
            chipselect = 1; write_n = 0;
            address = 2'b00; writedata = 32'd50;
            @(posedge clk);
            @(negedge clk);
            address = 2'b01; writedata = 32'd20;
            @(posedge clk);
            @(negedge clk);
            address = 2'b11; writedata = 32'h1;
            @(posedge clk);
            #2;
            write_n = 1;

            #1;


            check_outputs(32'h1F, 32'h1F);
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
        testcase008();
        
        
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
        input [31:0] expected_out_port;
        input [31:0] expected_readdata;
        begin
            if (expected_out_port === (expected_out_port ^ out_port ^ expected_out_port) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: out_port=%h, readdata=%h",
                         out_port, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_port=%h, readdata=%h",
                         expected_out_port, expected_readdata);
                $display("  Got:      out_port=%h, readdata=%h",
                         out_port, readdata);
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
        $dumpvars(0,address, chipselect, clk, reset_n, write_n, writedata, out_port, readdata);
    end

endmodule
