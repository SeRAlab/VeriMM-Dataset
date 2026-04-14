`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_data;
    reg [7:0] i_rd_ptr;
    reg i_wr_en;
    reg [7:0] i_wr_ptr;
    wire o_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_data(i_data),
        .i_rd_ptr(i_rd_ptr),
        .i_wr_en(i_wr_en),
        .i_wr_ptr(i_wr_ptr),
        .o_data(o_data)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_wr_en = 0;
            i_data = 0;
            i_wr_ptr = 0;
            i_rd_ptr = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge i_clk);
            i_wr_en = 1;
            i_wr_ptr = 8'h0A;
            i_data = 1'b1;
            @(posedge i_clk);
            i_wr_en = 0;
            i_rd_ptr = 8'h0A;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge i_clk);
            i_wr_en = 1;
            i_wr_ptr = 8'hFF;
            i_data = 1'b0;
            @(posedge i_clk);
            i_wr_en = 0;
            i_rd_ptr = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge i_clk);
            i_wr_en = 1;
            i_wr_ptr = 8'h55;
            i_data = 1'b1;
            @(posedge i_clk);

            i_wr_en = 0;
            i_data = 1'b0;
            @(posedge i_clk);
            i_rd_ptr = 8'h55;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge i_clk);
            i_wr_en = 1;
            i_wr_ptr = 8'h20;
            i_data = 1'b1;
            @(posedge i_clk);

            i_data = 1'b0;
            @(posedge i_clk);
            i_wr_en = 0;
            i_rd_ptr = 8'h20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge i_clk);
            i_wr_en = 1;
            i_wr_ptr = 8'h11;
            i_data = 1'b1;
            @(posedge i_clk);

            i_wr_ptr = 8'h22;
            i_data = 1'b0;
            i_rd_ptr = 8'h11;
            @(posedge i_clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge i_clk);
            i_wr_en = 1;
            i_wr_ptr = 8'h00;
            i_data = 1'b1;
            @(posedge i_clk);
            i_wr_en = 0;
            i_rd_ptr = 8'h00;
            #1;

            check_outputs(1'b1);
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
        input expected_o_data;
        begin
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data)) begin
                $display("PASS");
                $display("  Outputs: o_data=%b",
                         o_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%b",
                         expected_o_data);
                $display("  Got:      o_data=%b",
                         o_data);
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
        $dumpvars(0,i_clk, i_data, i_rd_ptr, i_wr_en, i_wr_ptr, o_data);
    end

endmodule
