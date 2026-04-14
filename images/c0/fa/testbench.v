`timescale 1ns/1ps

module gfx_wbm_read_tb;

    // Testbench signals (sequential circuit)
    reg ack_i;
    reg clk_i;
    reg [31:0] dat_i;
    reg err_i;
    reg read_request_i;
    reg rst_i;
    reg [29:0] texture_addr_i;
    reg [3:0] texture_sel_i;
    wire [31:0] adr_o;
    wire [1:0] bte_o;
    wire [2:0] cti_o;
    wire cyc_o;
    wire [3:0] sel_o;
    wire sint_o;
    wire stb_o;
    wire [31:0] texture_dat_o;
    wire texture_data_ack;
    wire we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gfx_wbm_read dut (
        .ack_i(ack_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .err_i(err_i),
        .read_request_i(read_request_i),
        .rst_i(rst_i),
        .texture_addr_i(texture_addr_i),
        .texture_sel_i(texture_sel_i),
        .adr_o(adr_o),
        .bte_o(bte_o),
        .cti_o(cti_o),
        .cyc_o(cyc_o),
        .sel_o(sel_o),
        .sint_o(sint_o),
        .stb_o(stb_o),
        .texture_dat_o(texture_dat_o),
        .texture_data_ack(texture_data_ack),
        .we_o(we_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gfx_wbm_read Testbench");
        $display("========================================");


        
        
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
        input [31:0] expected_adr_o;
        input [1:0] expected_bte_o;
        input [2:0] expected_cti_o;
        input expected_cyc_o;
        input [3:0] expected_sel_o;
        input expected_sint_o;
        input expected_stb_o;
        input [31:0] expected_texture_dat_o;
        input expected_texture_data_ack;
        input expected_we_o;
        begin
            if (expected_adr_o === (expected_adr_o ^ adr_o ^ expected_adr_o) &&
                expected_bte_o === (expected_bte_o ^ bte_o ^ expected_bte_o) &&
                expected_cti_o === (expected_cti_o ^ cti_o ^ expected_cti_o) &&
                expected_cyc_o === (expected_cyc_o ^ cyc_o ^ expected_cyc_o) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o) &&
                expected_sint_o === (expected_sint_o ^ sint_o ^ expected_sint_o) &&
                expected_stb_o === (expected_stb_o ^ stb_o ^ expected_stb_o) &&
                expected_texture_dat_o === (expected_texture_dat_o ^ texture_dat_o ^ expected_texture_dat_o) &&
                expected_texture_data_ack === (expected_texture_data_ack ^ texture_data_ack ^ expected_texture_data_ack) &&
                expected_we_o === (expected_we_o ^ we_o ^ expected_we_o)) begin
                $display("PASS");
                $display("  Outputs: adr_o=%h, bte_o=%h, cti_o=%h, cyc_o=%b, sel_o=%h, sint_o=%b, stb_o=%b, texture_dat_o=%h, texture_data_ack=%b, we_o=%b",
                         adr_o, bte_o, cti_o, cyc_o, sel_o, sint_o, stb_o, texture_dat_o, texture_data_ack, we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adr_o=%h, bte_o=%h, cti_o=%h, cyc_o=%b, sel_o=%h, sint_o=%b, stb_o=%b, texture_dat_o=%h, texture_data_ack=%b, we_o=%b",
                         expected_adr_o, expected_bte_o, expected_cti_o, expected_cyc_o, expected_sel_o, expected_sint_o, expected_stb_o, expected_texture_dat_o, expected_texture_data_ack, expected_we_o);
                $display("  Got:      adr_o=%h, bte_o=%h, cti_o=%h, cyc_o=%b, sel_o=%h, sint_o=%b, stb_o=%b, texture_dat_o=%h, texture_data_ack=%b, we_o=%b",
                         adr_o, bte_o, cti_o, cyc_o, sel_o, sint_o, stb_o, texture_dat_o, texture_data_ack, we_o);
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
        $dumpvars(0,ack_i, clk_i, dat_i, err_i, read_request_i, rst_i, texture_addr_i, texture_sel_i, adr_o, bte_o, cti_o, cyc_o, sel_o, sint_o, stb_o, texture_dat_o, texture_data_ack, we_o);
    end

endmodule
