`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg nrst_i;
    reg pcidOE_i;
    reg [31:0] rg_dat_i;
    reg [15:0] wb_dat_i;
    reg wbd16MX_i;
    reg wbdatLD_i;
    reg wbrgdMX_i;
    wire [31:0] pcidatout_o;
    wire [31:0] rg_dat_o;
    wire [15:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .nrst_i(nrst_i),
        .pcidOE_i(pcidOE_i),
        .rg_dat_i(rg_dat_i),
        .wb_dat_i(wb_dat_i),
        .wbd16MX_i(wbd16MX_i),
        .wbdatLD_i(wbdatLD_i),
        .wbrgdMX_i(wbrgdMX_i),
        .pcidatout_o(pcidatout_o),
        .rg_dat_o(rg_dat_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            nrst_i = 0;
            pcidOE_i = 0;
            rg_dat_i = 0;
            wb_dat_i = 0;
            wbd16MX_i = 0;
            wbdatLD_i = 0;
            wbrgdMX_i = 0;
            #20;
            nrst_i = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Reset State Verification", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Load Lower 16-bit Wishbone Data", test_num);
            wb_dat_i = 16'hAAAA;
            wbd16MX_i = 0;
            wbdatLD_i = 1;
            @(posedge clk_i);
            #2;
            wbdatLD_i = 0;

            #1;


            check_outputs(32'h0, 32'h0000AAAA, 16'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Load Upper 16-bit Wishbone Data", test_num);

            wb_dat_i = 16'hAAAA;
            wbd16MX_i = 0;
            wbdatLD_i = 1;
            @(posedge clk_i);
            #2;

            wb_dat_i = 16'h5555;
            wbd16MX_i = 1;
            wbdatLD_i = 1;
            @(posedge clk_i);
            #2;
            wbdatLD_i = 0;

            #1;


            check_outputs(32'h0, 32'h5555AAAA, 16'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: WB Read Lower 16-bit Mux", test_num);
            rg_dat_i = 32'h12345678;
            wbd16MX_i = 0;
            #5;

            #1;


            check_outputs(32'h0, 32'h0, 16'h5678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: WB Read Upper 16-bit Mux", test_num);
            rg_dat_i = 32'h12345678;
            wbd16MX_i = 1;
            #5;

            #1;


            check_outputs(32'h0, 32'h0, 16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: PCI Output Select Internal Reg (rg_dat_o)", test_num);

            wb_dat_i = 16'hBEEF;
            wbd16MX_i = 0;
            wbdatLD_i = 1;
            @(posedge clk_i);
            #2;
            wbdatLD_i = 0;

            pcidOE_i = 1;
            wbrgdMX_i = 0;
            #5;
            #1;

            check_outputs(32'h0000BEEF, 32'h0000BEEF, 16'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %03d: PCI Output Select External Data (rg_dat_i)", test_num);
            rg_dat_i = 32'hDEADCAFE;
            pcidOE_i = 1;
            wbrgdMX_i = 1;
            wbd16MX_i = 0;
            #5;


            #1;



            check_outputs(32'hDEADCAFE, 32'h0, 16'hCAFE);
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
        input [31:0] expected_pcidatout_o;
        input [31:0] expected_rg_dat_o;
        input [15:0] expected_wb_dat_o;
        begin
            if (expected_pcidatout_o === (expected_pcidatout_o ^ pcidatout_o ^ expected_pcidatout_o) &&
                expected_rg_dat_o === (expected_rg_dat_o ^ rg_dat_o ^ expected_rg_dat_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: pcidatout_o=%h, rg_dat_o=%h, wb_dat_o=%h",
                         pcidatout_o, rg_dat_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcidatout_o=%h, rg_dat_o=%h, wb_dat_o=%h",
                         expected_pcidatout_o, expected_rg_dat_o, expected_wb_dat_o);
                $display("  Got:      pcidatout_o=%h, rg_dat_o=%h, wb_dat_o=%h",
                         pcidatout_o, rg_dat_o, wb_dat_o);
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
        $dumpvars(0,clk_i, nrst_i, pcidOE_i, rg_dat_i, wb_dat_i, wbd16MX_i, wbdatLD_i, wbrgdMX_i, pcidatout_o, rg_dat_o, wb_dat_o);
    end

endmodule
