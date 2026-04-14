`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg wr_clk;
    reg wr_rst_reg_reg;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .wr_clk(wr_clk),
        .wr_rst_reg_reg(wr_rst_reg_reg),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

        task reset_dut;

        begin
            wr_rst_reg_reg = 1;
            D = 8'h0;
            repeat(2) @(posedge wr_clk);
            #1 wr_rst_reg_reg = 0;
            repeat(2) @(posedge wr_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write", test_num);

            D = 8'hA5;
            @(posedge wr_clk);
            #1 D = 8'h00;


            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Property - Head Preservation", test_num);

            D = 8'h11; @(posedge wr_clk);
            #1 D = 8'h22; @(posedge wr_clk);
            #1 D = 8'h33; @(posedge wr_clk);
            #1 D = 8'h00;

            repeat(3) @(posedge wr_clk);
            #1;



            #1;




            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Clear Check", test_num);


            D = 8'hFF; @(posedge wr_clk);
            #1 D = 8'h00;
            repeat(2) @(posedge wr_clk);


            wr_rst_reg_reg = 1;
            @(posedge wr_clk);
            #1 wr_rst_reg_reg = 0;
            repeat(2) @(posedge wr_clk);
            #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Data Integrity (0x5A)", test_num);

            D = 8'h5A; @(posedge wr_clk);
            #1 D = 8'h00;

            repeat(2) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Data Stability", test_num);

            D = 8'h77; @(posedge wr_clk);
            #1 D = 8'h00;


            repeat(10) @(posedge wr_clk);
            #1;

            #1;


            check_outputs(8'h77);
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, wr_clk, wr_rst_reg_reg, Q);
    end

endmodule
