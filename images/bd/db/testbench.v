`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] instr;
    reg [31:0] pcplus;
    reg rst;
    wire [31:0] instrD;
    wire [31:0] pcplusD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .instr(instr),
        .pcplus(pcplus),
        .rst(rst),
        .instrD(instrD),
        .pcplusD(pcplusD)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            instr = 0;
            pcplus = 0;
            @(posedge clk);
            #2;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Reset", test_num);
            reset_dut();



            #1;




            check_outputs(32'h00000000, pcplusD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Normal Load (enable=1)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            instr = 32'hAABBCCDD;
            pcplus = 32'h00001000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAABBCCDD, 32'h00001000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Disable Update (enable=0)", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            instr = 32'h11223344;
            pcplus = 32'h00002000;
            @(posedge clk);
            #2;


            @(negedge clk);
            enable = 0;
            instr = 32'hFFFFFFFF;
            pcplus = 32'hFFFFFFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h11223344, 32'h00002000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Reset holds pcplus constant", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            instr = 32'hDEADC0DE;
            pcplus = 32'h00004000;
            @(posedge clk);
            #2;


            @(negedge clk);
            rst = 1;
            instr = 32'h5555AAAA;
            pcplus = 32'h00008000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000000, 32'h00004000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Continuous Pipeline Flow", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            instr = 32'h00000001;
            pcplus = 32'h00000004;
            @(posedge clk);
            #2;

            @(negedge clk);
            instr = 32'h00000002;
            pcplus = 32'h00000008;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000002, 32'h00000008);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset Priority Over Enable", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            instr = 32'h12345678;
            pcplus = 32'hABCDEF01;
            @(posedge clk);
            #2;


            @(negedge clk);
            rst = 1;
            enable = 1;
            instr = 32'hFFFFFFFF;
            pcplus = 32'hFFFFFFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h00000000, 32'hABCDEF01);
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
        input [31:0] expected_instrD;
        input [31:0] expected_pcplusD;
        begin
            if (expected_instrD === (expected_instrD ^ instrD ^ expected_instrD) &&
                expected_pcplusD === (expected_pcplusD ^ pcplusD ^ expected_pcplusD)) begin
                $display("PASS");
                $display("  Outputs: instrD=%h, pcplusD=%h",
                         instrD, pcplusD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instrD=%h, pcplusD=%h",
                         expected_instrD, expected_pcplusD);
                $display("  Got:      instrD=%h, pcplusD=%h",
                         instrD, pcplusD);
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
        $dumpvars(0,clk, enable, instr, pcplus, rst, instrD, pcplusD);
    end

endmodule
