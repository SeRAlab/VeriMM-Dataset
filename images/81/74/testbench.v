`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] sdram_readdata;
    reg sdram_readdatavalid;
    reg sdram_waitrequest;
    reg [31:0] vjtag_address;
    reg [3:0] vjtag_byteenable;
    reg vjtag_read;
    reg vjtag_write;
    reg [31:0] vjtag_writedata;
    wire [7:0] leds;
    wire [31:0] sdram_address;
    wire [3:0] sdram_byteenable;
    wire sdram_read;
    wire sdram_write;
    wire [31:0] sdram_writedata;
    wire [31:0] vjtag_readdata;
    wire vjtag_readdatavalid;
    wire vjtag_waitrequest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .sdram_readdata(sdram_readdata),
        .sdram_readdatavalid(sdram_readdatavalid),
        .sdram_waitrequest(sdram_waitrequest),
        .vjtag_address(vjtag_address),
        .vjtag_byteenable(vjtag_byteenable),
        .vjtag_read(vjtag_read),
        .vjtag_write(vjtag_write),
        .vjtag_writedata(vjtag_writedata),
        .leds(leds),
        .sdram_address(sdram_address),
        .sdram_byteenable(sdram_byteenable),
        .sdram_read(sdram_read),
        .sdram_write(sdram_write),
        .sdram_writedata(sdram_writedata),
        .vjtag_readdata(vjtag_readdata),
        .vjtag_readdatavalid(vjtag_readdatavalid),
        .vjtag_waitrequest(vjtag_waitrequest)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk = 0;
            rst = 1;
            sdram_readdata = 0;
            sdram_readdatavalid = 0;
            sdram_waitrequest = 0;
            vjtag_address = 0;
            vjtag_byteenable = 0;
            vjtag_read = 0;
            vjtag_write = 0;
            vjtag_writedata = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Simple Write Transaction", test_num);

            vjtag_address = 32'h12345678;
            vjtag_writedata = 32'hDEADBEEF;
            vjtag_byteenable = 4'b1111;
            vjtag_write = 1;
            vjtag_read = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(
                8'hEF,
                32'h12345678,
                4'b1111,
                1'b0,
                1'b1,
                32'hDEADBEEF,
                32'h0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Simple Read Transaction", test_num);

            vjtag_address = 32'hAAAA5555;
            vjtag_read = 1;
            vjtag_write = 0;
            vjtag_byteenable = 4'b1111;


            sdram_readdata = 32'hCAFEBABE;
            sdram_readdatavalid = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(
                8'h00,
                32'hAAAA5555,
                4'b1111,
                1'b1,
                1'b0,
                32'h0,
                32'hCAFEBABE,
                1'b1,
                1'b0
            );
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Wait Request Propagation", test_num);

            sdram_waitrequest = 1;
            vjtag_write = 1;
            vjtag_address = 32'h88887777;

            @(posedge clk);
            #1;

            #1;


            check_outputs(
                8'h00,
                32'h88887777,
                4'b0000,
                1'b0,
                1'b1,
                32'h0,
                32'h0,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Byte Enable Routing", test_num);

            vjtag_byteenable = 4'b1001;
            vjtag_writedata = 32'h11223344;
            vjtag_write = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(
                8'h44,
                32'h0,
                4'b1001,
                1'b0,
                1'b1,
                32'h11223344,
                32'h0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Full Path Consistency", test_num);

            vjtag_address = 32'hFFFF0000;
            vjtag_writedata = 32'h55AA55AA;
            vjtag_write = 0;
            vjtag_read = 1;
            vjtag_byteenable = 4'b0110;
            sdram_readdata = 32'h99999999;
            sdram_readdatavalid = 1;
            sdram_waitrequest = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(
                8'hAA,
                32'hFFFF0000,
                4'b0110,
                1'b1,
                1'b0,
                32'h55AA55AA,
                32'h99999999,
                1'b1,
                1'b0
            );
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
        input [7:0] expected_leds;
        input [31:0] expected_sdram_address;
        input [3:0] expected_sdram_byteenable;
        input expected_sdram_read;
        input expected_sdram_write;
        input [31:0] expected_sdram_writedata;
        input [31:0] expected_vjtag_readdata;
        input expected_vjtag_readdatavalid;
        input expected_vjtag_waitrequest;
        begin
            if (expected_leds === (expected_leds ^ leds ^ expected_leds) &&
                expected_sdram_address === (expected_sdram_address ^ sdram_address ^ expected_sdram_address) &&
                expected_sdram_byteenable === (expected_sdram_byteenable ^ sdram_byteenable ^ expected_sdram_byteenable) &&
                expected_sdram_read === (expected_sdram_read ^ sdram_read ^ expected_sdram_read) &&
                expected_sdram_write === (expected_sdram_write ^ sdram_write ^ expected_sdram_write) &&
                expected_sdram_writedata === (expected_sdram_writedata ^ sdram_writedata ^ expected_sdram_writedata) &&
                expected_vjtag_readdata === (expected_vjtag_readdata ^ vjtag_readdata ^ expected_vjtag_readdata) &&
                expected_vjtag_readdatavalid === (expected_vjtag_readdatavalid ^ vjtag_readdatavalid ^ expected_vjtag_readdatavalid) &&
                expected_vjtag_waitrequest === (expected_vjtag_waitrequest ^ vjtag_waitrequest ^ expected_vjtag_waitrequest)) begin
                $display("PASS");
                $display("  Outputs: leds=%h, sdram_address=%h, sdram_byteenable=%h, sdram_read=%b, sdram_write=%b, sdram_writedata=%h, vjtag_readdata=%h, vjtag_readdatavalid=%b, vjtag_waitrequest=%b",
                         leds, sdram_address, sdram_byteenable, sdram_read, sdram_write, sdram_writedata, vjtag_readdata, vjtag_readdatavalid, vjtag_waitrequest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h, sdram_address=%h, sdram_byteenable=%h, sdram_read=%b, sdram_write=%b, sdram_writedata=%h, vjtag_readdata=%h, vjtag_readdatavalid=%b, vjtag_waitrequest=%b",
                         expected_leds, expected_sdram_address, expected_sdram_byteenable, expected_sdram_read, expected_sdram_write, expected_sdram_writedata, expected_vjtag_readdata, expected_vjtag_readdatavalid, expected_vjtag_waitrequest);
                $display("  Got:      leds=%h, sdram_address=%h, sdram_byteenable=%h, sdram_read=%b, sdram_write=%b, sdram_writedata=%h, vjtag_readdata=%h, vjtag_readdatavalid=%b, vjtag_waitrequest=%b",
                         leds, sdram_address, sdram_byteenable, sdram_read, sdram_write, sdram_writedata, vjtag_readdata, vjtag_readdatavalid, vjtag_waitrequest);
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
        $dumpvars(0,clk, rst, sdram_readdata, sdram_readdatavalid, sdram_waitrequest, vjtag_address, vjtag_byteenable, vjtag_read, vjtag_write, vjtag_writedata, leds, sdram_address, sdram_byteenable, sdram_read, sdram_write, sdram_writedata, vjtag_readdata, vjtag_readdatavalid, vjtag_waitrequest);
    end

endmodule
