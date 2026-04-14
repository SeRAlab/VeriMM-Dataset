`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] address;
    reg [1:0] byteenable;
    reg clk;
    reg read;
    reg reset;
    reg write;
    reg [15:0] writedata;
    wire [17:0] SRAM_ADDR;
    wire SRAM_CE_N;
    wire SRAM_LB_N;
    wire SRAM_OE_N;
    wire SRAM_UB_N;
    wire SRAM_WE_N;
    wire [15:0] readdata;
    wire readdatavalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .byteenable(byteenable),
        .clk(clk),
        .read(read),
        .reset(reset),
        .write(write),
        .writedata(writedata),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_OE_N(SRAM_OE_N),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_WE_N(SRAM_WE_N),
        .readdata(readdata),
        .readdatavalid(readdatavalid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            byteenable = 0;
            read = 0;
            write = 0;
            writedata = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard Write Operation", test_num);
            reset_dut();

            address = 18'h01234;
            writedata = 16'hABCD;
            byteenable = 2'b11;
            write = 1;
            read = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(18'h01234, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 16'hxxxx, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard Read Operation", test_num);
            reset_dut();

            address = 18'h05678;
            byteenable = 2'b11;
            write = 0;
            read = 1;

            @(posedge clk);
            #1;




            #1;





            check_outputs(18'h05678, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, readdata, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Lower Byte Only", test_num);
            reset_dut();

            address = 18'h3FFFF;
            writedata = 16'h55AA;
            byteenable = 2'b01;
            write = 1;
            read = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(18'h3FFFF, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 16'hxxxx, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Upper Byte Only", test_num);
            reset_dut();

            address = 18'h0000A;
            writedata = 16'hF0F0;
            byteenable = 2'b10;
            write = 1;
            read = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(18'h0000A, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 16'hxxxx, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State (No Read/Write)", test_num);
            reset_dut();

            address = 18'h11111;
            byteenable = 2'b11;
            write = 0;
            read = 0;

            @(posedge clk);
            #1;



            #1;




            check_outputs(address, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 16'hxxxx, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Signal Asserted", test_num);

            address = 18'h12345;
            write = 1;
            reset = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(SRAM_ADDR, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 16'hxxxx, 1'b0);

            reset = 0;
            @(posedge clk);
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
        input [17:0] expected_SRAM_ADDR;
        input expected_SRAM_CE_N;
        input expected_SRAM_LB_N;
        input expected_SRAM_OE_N;
        input expected_SRAM_UB_N;
        input expected_SRAM_WE_N;
        input [15:0] expected_readdata;
        input expected_readdatavalid;
        begin
            if (expected_SRAM_ADDR === (expected_SRAM_ADDR ^ SRAM_ADDR ^ expected_SRAM_ADDR) &&
                expected_SRAM_CE_N === (expected_SRAM_CE_N ^ SRAM_CE_N ^ expected_SRAM_CE_N) &&
                expected_SRAM_LB_N === (expected_SRAM_LB_N ^ SRAM_LB_N ^ expected_SRAM_LB_N) &&
                expected_SRAM_OE_N === (expected_SRAM_OE_N ^ SRAM_OE_N ^ expected_SRAM_OE_N) &&
                expected_SRAM_UB_N === (expected_SRAM_UB_N ^ SRAM_UB_N ^ expected_SRAM_UB_N) &&
                expected_SRAM_WE_N === (expected_SRAM_WE_N ^ SRAM_WE_N ^ expected_SRAM_WE_N) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata) &&
                expected_readdatavalid === (expected_readdatavalid ^ readdatavalid ^ expected_readdatavalid)) begin
                $display("PASS");
                $display("  Outputs: SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, readdata=%h, readdatavalid=%b",
                         SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, readdata, readdatavalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, readdata=%h, readdatavalid=%b",
                         expected_SRAM_ADDR, expected_SRAM_CE_N, expected_SRAM_LB_N, expected_SRAM_OE_N, expected_SRAM_UB_N, expected_SRAM_WE_N, expected_readdata, expected_readdatavalid);
                $display("  Got:      SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, readdata=%h, readdatavalid=%b",
                         SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, readdata, readdatavalid);
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
        $dumpvars(0,address, byteenable, clk, read, reset, write, writedata, SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, readdata, readdatavalid);
    end

endmodule
