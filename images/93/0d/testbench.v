`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [7:0] i_rdata;
    wire [7:0] o_addr;
    wire [7:0] o_wdata;
    wire o_wen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_rdata(i_rdata),
        .o_addr(o_addr),
        .o_wdata(o_wdata),
        .o_wen(o_wen)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_rdata = 8'h00;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial increment check", test_num);
            reset_dut();

            i_rdata = 8'hA5;
            @(posedge i_clk);
            #1;


            #1;



            check_outputs(8'h01, 8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle counter check", test_num);
            reset_dut();

            i_rdata = 8'h10;

            repeat(5) @(posedge i_clk);
            #1;


            #1;



            check_outputs(8'h05, 8'h10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data change check", test_num);
            reset_dut();

            i_rdata = 8'hFF;
            @(posedge i_clk);
            #1;
            i_rdata = 8'h22;
            @(posedge i_clk);
            #1;


            #1;



            check_outputs(8'h02, 8'h22, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter wrap-around check", test_num);
            reset_dut();

            i_rdata = 8'h00;

            repeat(255) @(posedge i_clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'h00, 1'b1);
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
        input [7:0] expected_o_addr;
        input [7:0] expected_o_wdata;
        input expected_o_wen;
        begin
            if (expected_o_addr === (expected_o_addr ^ o_addr ^ expected_o_addr) &&
                expected_o_wdata === (expected_o_wdata ^ o_wdata ^ expected_o_wdata) &&
                expected_o_wen === (expected_o_wen ^ o_wen ^ expected_o_wen)) begin
                $display("PASS");
                $display("  Outputs: o_addr=%h, o_wdata=%h, o_wen=%b",
                         o_addr, o_wdata, o_wen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_addr=%h, o_wdata=%h, o_wen=%b",
                         expected_o_addr, expected_o_wdata, expected_o_wen);
                $display("  Got:      o_addr=%h, o_wdata=%h, o_wen=%b",
                         o_addr, o_wdata, o_wen);
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
        $dumpvars(0,i_clk, i_rdata, o_addr, o_wdata, o_wen);
    end

endmodule
