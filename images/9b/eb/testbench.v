`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IRWr;
    reg clk;
    reg [31:0] im_dout;
    reg rst;
    wire [31:0] instr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IRWr(IRWr),
        .clk(clk),
        .im_dout(im_dout),
        .rst(rst),
        .instr(instr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            IRWr = 0;
            im_dout = 32'h0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Load instruction with IRWr high", test_num);
            reset_dut();
            IRWr = 1;
            im_dout = 32'hA1B2C3D4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA1B2C3D4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Disable write with IRWr low", test_num);
            reset_dut();

            IRWr = 0;
            im_dout = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Data retention test", test_num);
            reset_dut();

            IRWr = 1;
            im_dout = 32'h1234_5678;
            @(posedge clk);
            #1;

            IRWr = 0;
            im_dout = 32'h8765_4321;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Reset priority over IRWr", test_num);
            reset_dut();

            IRWr = 1;
            im_dout = 32'hDEAD_BEEF;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_instr;
        begin
            if (expected_instr === (expected_instr ^ instr ^ expected_instr)) begin
                $display("PASS");
                $display("  Outputs: instr=%h",
                         instr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr=%h",
                         expected_instr);
                $display("  Got:      instr=%h",
                         instr);
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
        $dumpvars(0,IRWr, clk, im_dout, rst, instr);
    end

endmodule
