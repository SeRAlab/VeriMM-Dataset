`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] rdport1_ctrl_add;
    reg [3:0] rdport2_ctrl_add;
    reg [3:0] rdport3_ctrl_add;
    reg [3:0] rdport4_ctrl_add;
    reg rst;
    reg [3:0] wrport1_ctrl_add;
    reg [31:0] wrport1_data_in;
    reg wrport1_wren;
    reg [3:0] wrport2_ctrl_add;
    reg [31:0] wrport2_data_in;
    reg wrport2_wren;
    wire [31:0] rdport1_data_out;
    wire [31:0] rdport2_data_out;
    wire [31:0] rdport3_data_out;
    wire [31:0] rdport4_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rdport1_ctrl_add(rdport1_ctrl_add),
        .rdport2_ctrl_add(rdport2_ctrl_add),
        .rdport3_ctrl_add(rdport3_ctrl_add),
        .rdport4_ctrl_add(rdport4_ctrl_add),
        .rst(rst),
        .wrport1_ctrl_add(wrport1_ctrl_add),
        .wrport1_data_in(wrport1_data_in),
        .wrport1_wren(wrport1_wren),
        .wrport2_ctrl_add(wrport2_ctrl_add),
        .wrport2_data_in(wrport2_data_in),
        .wrport2_wren(wrport2_wren),
        .rdport1_data_out(rdport1_data_out),
        .rdport2_data_out(rdport2_data_out),
        .rdport3_data_out(rdport3_data_out),
        .rdport4_data_out(rdport4_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wrport1_wren = 0;
            wrport2_wren = 0;
            wrport1_ctrl_add = 0;
            wrport2_ctrl_add = 0;
            wrport1_data_in = 0;
            wrport2_data_in = 0;
            rdport1_ctrl_add = 0;
            rdport2_ctrl_add = 0;
            rdport3_ctrl_add = 0;
            rdport4_ctrl_add = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify all registers are zero after reset", test_num);
            reset_dut();


            rdport1_ctrl_add = 4'd0;
            rdport2_ctrl_add = 4'd5;
            rdport3_ctrl_add = 4'd10;
            rdport4_ctrl_add = 4'd15;

            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic write and simultaneous read", test_num);
            reset_dut();


            wrport1_ctrl_add = 4'd1;
            wrport1_data_in = 32'hDEADBEEF;
            wrport1_wren = 1;
            @(posedge clk);
            #1;
            wrport1_wren = 0;


            rdport1_ctrl_add = 4'd1;
            rdport2_ctrl_add = 4'd1;
            rdport3_ctrl_add = 4'd1;
            rdport4_ctrl_add = 4'd1;

            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF, 32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous writes to separate registers", test_num);
            reset_dut();


            wrport1_ctrl_add = 4'd2;
            wrport1_data_in = 32'h1111_1111;
            wrport1_wren = 1;

            wrport2_ctrl_add = 4'd8;
            wrport2_data_in = 32'h2222_2222;
            wrport2_wren = 1;

            @(posedge clk);
            #1;
            wrport1_wren = 0;
            wrport2_wren = 0;


            rdport1_ctrl_add = 4'd2;
            rdport2_ctrl_add = 4'd8;
            rdport3_ctrl_add = 4'd0;
            rdport4_ctrl_add = 4'd15;

            #1;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify write enable is respected", test_num);
            reset_dut();


            wrport1_ctrl_add = 4'd5;
            wrport1_data_in = 32'hFFFF_FFFF;
            wrport1_wren = 0;

            @(posedge clk);
            #1;

            rdport1_ctrl_add = 4'd5;
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous writes to same address", test_num);
            reset_dut();


            wrport1_ctrl_add = 4'd7;
            wrport1_data_in = 32'hAAAA_AAAA;
            wrport1_wren = 1;

            wrport2_ctrl_add = 4'd7;
            wrport2_data_in = 32'hBBBB_BBBB;
            wrport2_wren = 1;

            @(posedge clk);
            #1;
            wrport1_wren = 0;
            wrport2_wren = 0;


            rdport1_ctrl_add = 4'd7;
            #1;


            #1;



            check_outputs(32'hBBBB_BBBB, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reading four different registers simultaneously", test_num);
            reset_dut();


            wrport1_ctrl_add = 4'd12; wrport1_data_in = 32'hC0DE_0001; wrport1_wren = 1;
            @(posedge clk); #1;
            wrport1_ctrl_add = 4'd13; wrport1_data_in = 32'hC0DE_0002; wrport1_wren = 1;
            @(posedge clk); #1;
            wrport1_ctrl_add = 4'd14; wrport1_data_in = 32'hC0DE_0003; wrport1_wren = 1;
            @(posedge clk); #1;
            wrport1_ctrl_add = 4'd15; wrport1_data_in = 32'hC0DE_0004; wrport1_wren = 1;
            @(posedge clk); #1;
            wrport1_wren = 0;

            rdport1_ctrl_add = 4'd12;
            rdport2_ctrl_add = 4'd13;
            rdport3_ctrl_add = 4'd14;
            rdport4_ctrl_add = 4'd15;

            #1;
            #1;

            check_outputs(32'hC0DE_0001, 32'hC0DE_0002, 32'hC0DE_0003, 32'hC0DE_0004);
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
        input [31:0] expected_rdport1_data_out;
        input [31:0] expected_rdport2_data_out;
        input [31:0] expected_rdport3_data_out;
        input [31:0] expected_rdport4_data_out;
        begin
            if (expected_rdport1_data_out === (expected_rdport1_data_out ^ rdport1_data_out ^ expected_rdport1_data_out) &&
                expected_rdport2_data_out === (expected_rdport2_data_out ^ rdport2_data_out ^ expected_rdport2_data_out) &&
                expected_rdport3_data_out === (expected_rdport3_data_out ^ rdport3_data_out ^ expected_rdport3_data_out) &&
                expected_rdport4_data_out === (expected_rdport4_data_out ^ rdport4_data_out ^ expected_rdport4_data_out)) begin
                $display("PASS");
                $display("  Outputs: rdport1_data_out=%h, rdport2_data_out=%h, rdport3_data_out=%h, rdport4_data_out=%h",
                         rdport1_data_out, rdport2_data_out, rdport3_data_out, rdport4_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdport1_data_out=%h, rdport2_data_out=%h, rdport3_data_out=%h, rdport4_data_out=%h",
                         expected_rdport1_data_out, expected_rdport2_data_out, expected_rdport3_data_out, expected_rdport4_data_out);
                $display("  Got:      rdport1_data_out=%h, rdport2_data_out=%h, rdport3_data_out=%h, rdport4_data_out=%h",
                         rdport1_data_out, rdport2_data_out, rdport3_data_out, rdport4_data_out);
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
        $dumpvars(0,clk, rdport1_ctrl_add, rdport2_ctrl_add, rdport3_ctrl_add, rdport4_ctrl_add, rst, wrport1_ctrl_add, wrport1_data_in, wrport1_wren, wrport2_ctrl_add, wrport2_data_in, wrport2_wren, rdport1_data_out, rdport2_data_out, rdport3_data_out, rdport4_data_out);
    end

endmodule
