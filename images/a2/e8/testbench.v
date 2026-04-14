`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [31:0] i_IData;
    reg i_IErr;
    reg i_IRdy;
    reg nrst;
    reg rd_cmd;
    wire busy;
    wire err_align;
    wire err_bus;
    wire [31:0] instr_dat;
    wire [31:0] o_IAddr;
    wire o_IRdC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .i_IData(i_IData),
        .i_IErr(i_IErr),
        .i_IRdy(i_IRdy),
        .nrst(nrst),
        .rd_cmd(rd_cmd),
        .busy(busy),
        .err_align(err_align),
        .err_bus(err_bus),
        .instr_dat(instr_dat),
        .o_IAddr(o_IAddr),
        .o_IRdC(o_IRdC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nrst = 0;
            addr = 0;
            rd_cmd = 0;
            i_IData = 0;
            i_IRdy = 0;
            i_IErr = 0;
            @(posedge clk);
            #1;
            nrst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 32'h0, 32'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Successful Aligned Fetch", test_num);
            reset_dut();

            @(posedge clk);
            addr = 32'h0000_1000;
            rd_cmd = 1;


            @(posedge clk);
            #1;
            i_IRdy = 1;
            i_IData = 32'hAABBCCDD;


            @(posedge clk);
            #1;
            rd_cmd = 0;
            i_IRdy = 0;


            #1;



            check_outputs(0, 0, 0, 32'hAABBCCDD, 32'h0000_1000, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Alignment Error", test_num);
            reset_dut();

            @(posedge clk);
            addr = 32'h0000_1002;
            rd_cmd = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 1, 0, 32'h0, 32'h0000_1002, 1);


        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Bus Error", test_num);
            reset_dut();

            @(posedge clk);
            addr = 32'h0000_2000;
            rd_cmd = 1;

            @(posedge clk);
            #1;
            i_IErr = 1;
            i_IRdy = 1;

            @(posedge clk);
            #1;
            rd_cmd = 0;
            i_IErr = 0;
            i_IRdy = 0;


            #1;



            check_outputs(0, 0, 1, 32'h0, 32'h0000_2000, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Memory Latency", test_num);
            reset_dut();

            @(posedge clk);
            addr = 32'h0000_3000;
            rd_cmd = 1;

            @(posedge clk);
            #1;

            i_IRdy = 0;

            repeat(3) @(posedge clk);
            #1;

            if (busy == 1) $display("  Wait states active...");

            i_IRdy = 1;
            i_IData = 32'h12345678;

            @(posedge clk);
            #1;
            rd_cmd = 0;
            i_IRdy = 0;

            #1;


            check_outputs(0, 0, 0, 32'h12345678, 32'h0000_3000, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Data Retention", test_num);
            reset_dut();


            @(posedge clk);
            addr = 32'h0000_4000;
            rd_cmd = 1;
            @(posedge clk);
            #1;
            i_IRdy = 1;
            i_IData = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            rd_cmd = 0;
            i_IRdy = 0;


            @(posedge clk);
            addr = 32'h0000_5000;
            rd_cmd = 0;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(0, 0, 0, 32'hDEADBEEF, 32'h0000_4000, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Back-to-back Fetches", test_num);
            reset_dut();


            @(posedge clk);
            addr = 32'h0000_6000;
            rd_cmd = 1;
            @(posedge clk);
            #1;
            i_IRdy = 1; i_IData = 32'h11111111;


            @(posedge clk);
            #1;
            addr = 32'h0000_6004;
            rd_cmd = 1;
            i_IRdy = 0;

            @(posedge clk);
            #1;
            i_IRdy = 1; i_IData = 32'h22222222;

            @(posedge clk);
            #1;
            rd_cmd = 0;
            i_IRdy = 0;

            #1;


            check_outputs(0, 0, 0, 32'h22222222, 32'h0000_6004, 0);
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
        input expected_busy;
        input expected_err_align;
        input expected_err_bus;
        input [31:0] expected_instr_dat;
        input [31:0] expected_o_IAddr;
        input expected_o_IRdC;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_err_align === (expected_err_align ^ err_align ^ expected_err_align) &&
                expected_err_bus === (expected_err_bus ^ err_bus ^ expected_err_bus) &&
                expected_instr_dat === (expected_instr_dat ^ instr_dat ^ expected_instr_dat) &&
                expected_o_IAddr === (expected_o_IAddr ^ o_IAddr ^ expected_o_IAddr) &&
                expected_o_IRdC === (expected_o_IRdC ^ o_IRdC ^ expected_o_IRdC)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, err_align=%b, err_bus=%b, instr_dat=%h, o_IAddr=%h, o_IRdC=%b",
                         busy, err_align, err_bus, instr_dat, o_IAddr, o_IRdC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, err_align=%b, err_bus=%b, instr_dat=%h, o_IAddr=%h, o_IRdC=%b",
                         expected_busy, expected_err_align, expected_err_bus, expected_instr_dat, expected_o_IAddr, expected_o_IRdC);
                $display("  Got:      busy=%b, err_align=%b, err_bus=%b, instr_dat=%h, o_IAddr=%h, o_IRdC=%b",
                         busy, err_align, err_bus, instr_dat, o_IAddr, o_IRdC);
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
        $dumpvars(0,addr, clk, i_IData, i_IErr, i_IRdy, nrst, rd_cmd, busy, err_align, err_bus, instr_dat, o_IAddr, o_IRdC);
    end

endmodule
