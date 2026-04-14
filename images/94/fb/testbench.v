`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] ram_addr;
    reg ram_cen;
    reg [15:0] ram_din;
    reg [1:0] ram_wen;
    wire [17:0] SRAM_ADDR;
    wire SRAM_CE_N;
    wire SRAM_LB_N;
    wire SRAM_OE_N;
    wire SRAM_UB_N;
    wire SRAM_WE_N;
    wire [15:0] ram_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ram_addr(ram_addr),
        .ram_cen(ram_cen),
        .ram_din(ram_din),
        .ram_wen(ram_wen),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_OE_N(SRAM_OE_N),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_WE_N(SRAM_WE_N),
        .ram_dout(ram_dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ram_addr = 0;
            ram_cen = 0;
            ram_wen = 0;
            ram_din = 0;
            test_num = test_num + 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            ram_cen = 0;
            ram_wen = 2'b00;
            ram_addr = 9'h0AA;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Idle State (ram_cen=0)", test_num);


            #1;



            check_outputs(18'h000AA, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            ram_cen = 1;
            ram_wen = 2'b00;
            ram_addr = 9'h055;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Read Operation", test_num);

            #1;


            check_outputs(18'h00055, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            ram_cen = 1;
            ram_wen = 2'b11;
            ram_din = 16'hABCD;
            ram_addr = 9'h1FF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Write Both Bytes", test_num);

            #1;


            check_outputs(18'h001FF, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            ram_cen = 1;
            ram_wen = 2'b01;
            ram_din = 16'h1234;
            ram_addr = 9'h010;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Write Lower Byte", test_num);

            #1;


            check_outputs(18'h00010, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            ram_cen = 1;
            ram_wen = 2'b10;
            ram_din = 16'h5678;
            ram_addr = 9'h020;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Write Upper Byte", test_num);

            #1;


            check_outputs(18'h00020, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            ram_cen = 1;
            ram_wen = 2'b00;
            ram_addr = 9'h1AA;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Boundary Address Read", test_num);

            #1;


            check_outputs(18'h001AA, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;

            ram_cen = 1; ram_wen = 2'b00; ram_addr = 9'h001;
            @(posedge clk);
            #1;

            ram_wen = 2'b11; ram_addr = 9'h002;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Sequential Read then Write", test_num);
            #1;

            check_outputs(18'h00002, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 16'h0000);
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
        input [17:0] expected_SRAM_ADDR;
        input expected_SRAM_CE_N;
        input expected_SRAM_LB_N;
        input expected_SRAM_OE_N;
        input expected_SRAM_UB_N;
        input expected_SRAM_WE_N;
        input [15:0] expected_ram_dout;
        begin
            if (expected_SRAM_ADDR === (expected_SRAM_ADDR ^ SRAM_ADDR ^ expected_SRAM_ADDR) &&
                expected_SRAM_CE_N === (expected_SRAM_CE_N ^ SRAM_CE_N ^ expected_SRAM_CE_N) &&
                expected_SRAM_LB_N === (expected_SRAM_LB_N ^ SRAM_LB_N ^ expected_SRAM_LB_N) &&
                expected_SRAM_OE_N === (expected_SRAM_OE_N ^ SRAM_OE_N ^ expected_SRAM_OE_N) &&
                expected_SRAM_UB_N === (expected_SRAM_UB_N ^ SRAM_UB_N ^ expected_SRAM_UB_N) &&
                expected_SRAM_WE_N === (expected_SRAM_WE_N ^ SRAM_WE_N ^ expected_SRAM_WE_N) &&
                expected_ram_dout === (expected_ram_dout ^ ram_dout ^ expected_ram_dout)) begin
                $display("PASS");
                $display("  Outputs: SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, ram_dout=%h",
                         SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, ram_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, ram_dout=%h",
                         expected_SRAM_ADDR, expected_SRAM_CE_N, expected_SRAM_LB_N, expected_SRAM_OE_N, expected_SRAM_UB_N, expected_SRAM_WE_N, expected_ram_dout);
                $display("  Got:      SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, ram_dout=%h",
                         SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, ram_dout);
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
        $dumpvars(0,clk, ram_addr, ram_cen, ram_din, ram_wen, SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, ram_dout);
    end

endmodule
