`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rst_n_pad_i;
    reg sys_clk_pad_i;
    wire async_rst_o;
    wire ddr2_if_clk_o;
    wire ddr2_if_rst_o;
    wire wb_clk_o;
    wire wb_rst_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rst_n_pad_i(rst_n_pad_i),
        .sys_clk_pad_i(sys_clk_pad_i),
        .async_rst_o(async_rst_o),
        .ddr2_if_clk_o(ddr2_if_clk_o),
        .ddr2_if_rst_o(ddr2_if_rst_o),
        .wb_clk_o(wb_clk_o),
        .wb_rst_o(wb_rst_o)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk_pad_i = 0;
        forever #5 sys_clk_pad_i = ~sys_clk_pad_i;
    end

        task reset_dut;

        begin
            $display("  Applying reset...");
            rst_n_pad_i = 0;
            #100;
            rst_n_pad_i = 1;
            #500;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Post-reset release - Check reset de-assertion", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1, ddr2_if_clk_o, 1'b0, wb_clk_o, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: During reset - Check reset assertion", test_num);

            rst_n_pad_i = 0;
            #150;

            #1;


            check_outputs(1'b0, ddr2_if_clk_o, 1'b1, wb_clk_o, 1'b1);

            rst_n_pad_i = 1;
            #200;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Long run stability check", test_num);
            reset_dut();
            #2000;

            #1;


            check_outputs(1'b1, ddr2_if_clk_o, 1'b0, wb_clk_o, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Short reset pulse test", test_num);
            rst_n_pad_i = 0;
            #20;
            rst_n_pad_i = 1;
            #800;

            #1;


            check_outputs(1'b1, ddr2_if_clk_o, 1'b0, wb_clk_o, 1'b0);
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
        input expected_async_rst_o;
        input expected_ddr2_if_clk_o;
        input expected_ddr2_if_rst_o;
        input expected_wb_clk_o;
        input expected_wb_rst_o;
        begin
            if (expected_async_rst_o === (expected_async_rst_o ^ async_rst_o ^ expected_async_rst_o) &&
                expected_ddr2_if_clk_o === (expected_ddr2_if_clk_o ^ ddr2_if_clk_o ^ expected_ddr2_if_clk_o) &&
                expected_ddr2_if_rst_o === (expected_ddr2_if_rst_o ^ ddr2_if_rst_o ^ expected_ddr2_if_rst_o) &&
                expected_wb_clk_o === (expected_wb_clk_o ^ wb_clk_o ^ expected_wb_clk_o) &&
                expected_wb_rst_o === (expected_wb_rst_o ^ wb_rst_o ^ expected_wb_rst_o)) begin
                $display("PASS");
                $display("  Outputs: async_rst_o=%b, ddr2_if_clk_o=%b, ddr2_if_rst_o=%b, wb_clk_o=%b, wb_rst_o=%b",
                         async_rst_o, ddr2_if_clk_o, ddr2_if_rst_o, wb_clk_o, wb_rst_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: async_rst_o=%b, ddr2_if_clk_o=%b, ddr2_if_rst_o=%b, wb_clk_o=%b, wb_rst_o=%b",
                         expected_async_rst_o, expected_ddr2_if_clk_o, expected_ddr2_if_rst_o, expected_wb_clk_o, expected_wb_rst_o);
                $display("  Got:      async_rst_o=%b, ddr2_if_clk_o=%b, ddr2_if_rst_o=%b, wb_clk_o=%b, wb_rst_o=%b",
                         async_rst_o, ddr2_if_clk_o, ddr2_if_rst_o, wb_clk_o, wb_rst_o);
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
        $dumpvars(0,rst_n_pad_i, sys_clk_pad_i, async_rst_o, ddr2_if_clk_o, ddr2_if_rst_o, wb_clk_o, wb_rst_o);
    end

endmodule
