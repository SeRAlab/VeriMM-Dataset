`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aux_clk_i;
    reg clk_fpga_i;
    reg clock_ready_i;
    reg ram_loader_done_i;
    wire dsp_clk_o;
    wire processor_rst_o;
    wire ram_loader_rst_o;
    wire wb_clk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aux_clk_i(aux_clk_i),
        .clk_fpga_i(clk_fpga_i),
        .clock_ready_i(clock_ready_i),
        .ram_loader_done_i(ram_loader_done_i),
        .dsp_clk_o(dsp_clk_o),
        .processor_rst_o(processor_rst_o),
        .ram_loader_rst_o(ram_loader_rst_o),
        .wb_clk_o(wb_clk_o)
    );

    // Clock generation (10ns period)
    initial begin
        aux_clk_i = 0;
        forever #5 aux_clk_i = ~aux_clk_i;
    end

        task reset_dut;

        begin
            ram_loader_done_i = 0;
            clock_ready_i = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Checking Initial Reset State", test_num);
            #10;


            #1;



            check_outputs(dsp_clk_o, 1'b1, 1'b0, wb_clk_o);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: RAM Loader Completion Status", test_num);
            ram_loader_done_i = 1;
            #20;
            #1;

            check_outputs(dsp_clk_o, 1'b1, 1'b1, wb_clk_o);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Processor Reset Release on Clock Ready", test_num);
            clock_ready_i = 1;
            #20;
            #1;

            check_outputs(dsp_clk_o, 1'b0, 1'b0, wb_clk_o);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Fully Operational System", test_num);
            clock_ready_i = 1;
            ram_loader_done_i = 1;
            #20;
            #1;

            check_outputs(dsp_clk_o, 1'b0, 1'b1, wb_clk_o);
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
        input expected_dsp_clk_o;
        input expected_processor_rst_o;
        input expected_ram_loader_rst_o;
        input expected_wb_clk_o;
        begin
            if (expected_dsp_clk_o === (expected_dsp_clk_o ^ dsp_clk_o ^ expected_dsp_clk_o) &&
                expected_processor_rst_o === (expected_processor_rst_o ^ processor_rst_o ^ expected_processor_rst_o) &&
                expected_ram_loader_rst_o === (expected_ram_loader_rst_o ^ ram_loader_rst_o ^ expected_ram_loader_rst_o) &&
                expected_wb_clk_o === (expected_wb_clk_o ^ wb_clk_o ^ expected_wb_clk_o)) begin
                $display("PASS");
                $display("  Outputs: dsp_clk_o=%b, processor_rst_o=%b, ram_loader_rst_o=%b, wb_clk_o=%b",
                         dsp_clk_o, processor_rst_o, ram_loader_rst_o, wb_clk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dsp_clk_o=%b, processor_rst_o=%b, ram_loader_rst_o=%b, wb_clk_o=%b",
                         expected_dsp_clk_o, expected_processor_rst_o, expected_ram_loader_rst_o, expected_wb_clk_o);
                $display("  Got:      dsp_clk_o=%b, processor_rst_o=%b, ram_loader_rst_o=%b, wb_clk_o=%b",
                         dsp_clk_o, processor_rst_o, ram_loader_rst_o, wb_clk_o);
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
        $dumpvars(0,aux_clk_i, clk_fpga_i, clock_ready_i, ram_loader_done_i, dsp_clk_o, processor_rst_o, ram_loader_rst_o, wb_clk_o);
    end

endmodule
