`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg ren;
    reg rst;
    reg [1:0] sel;
    reg wen;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .ren(ren),
        .rst(rst),
        .sel(sel),
        .wen(wen),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wen = 0;
            ren = 0;
            din = 0;
            sel = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            wen = 1; sel = 2'b00; din = 8'hA5;
            @(posedge clk);
            wen = 0; ren = 1; sel = 2'b00;
            #2;
            $display("Test %0d: Write 0xA5 to Reg 0, Read Reg 0", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            wen = 1; sel = 2'b11; din = 8'h5A;
            @(posedge clk);
            wen = 0; ren = 1; sel = 2'b11;
            #2;
            $display("Test %0d: Write 0x5A to Reg 3, Read Reg 3", test_num);
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            wen = 1; sel = 2'b01; din = 8'hFF;
            @(posedge clk);
            wen = 0; ren = 0; sel = 2'b01;
            #2;
            $display("Test %0d: Write 0xFF to Reg 1, Read with ren=0", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            wen = 1; sel = 2'b10; din = 8'h11;
            @(posedge clk);
            wen = 1; sel = 2'b10; din = 8'h22;
            @(posedge clk);
            wen = 0; ren = 1; sel = 2'b10;
            #2;
            $display("Test %0d: Overwrite Reg 2 (0x11 -> 0x22), Read Reg 2", test_num);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            wen = 1; sel = 2'b00; din = 8'hBC;
            @(posedge clk);
            wen = 0;
            #2;
            rst = 1;
            #10;
            rst = 0;
            ren = 1; sel = 2'b00;
            #2;
            $display("Test %0d: Write 0xBC to Reg 0 then Reset, Read Reg 0", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);
            wen = 1; sel = 2'b00; din = 8'h01; @(posedge clk);
            wen = 1; sel = 2'b01; din = 8'h02; @(posedge clk);
            wen = 1; sel = 2'b10; din = 8'h03; @(posedge clk);
            wen = 1; sel = 2'b11; din = 8'h04; @(posedge clk);
            wen = 0; ren = 1; sel = 2'b01;
            #2;
            $display("Test %0d: Fill all regs (1-4), Read Reg 1", test_num);
            #1;

            check_outputs(8'h02);
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, ren, rst, sel, wen, dout);
    end

endmodule
