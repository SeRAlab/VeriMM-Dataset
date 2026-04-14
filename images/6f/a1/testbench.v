`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [47:0] rom_data;
    reg start;
    reg wb_ack_i;
    reg wb_clk_i;
    reg wb_rst_i;
    wire done;
    wire [15:0] rom_addr;
    wire [15:0] wb_adr_o;
    wire wb_cyc_o;
    wire [31:0] wb_dat_o;
    wire [3:0] wb_sel_o;
    wire wb_stb_o;
    wire wb_we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rom_data(rom_data),
        .start(start),
        .wb_ack_i(wb_ack_i),
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .done(done),
        .rom_addr(rom_addr),
        .wb_adr_o(wb_adr_o),
        .wb_cyc_o(wb_cyc_o),
        .wb_dat_o(wb_dat_o),
        .wb_sel_o(wb_sel_o),
        .wb_stb_o(wb_stb_o),
        .wb_we_o(wb_we_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            start = 0;
            wb_ack_i = 0;
            rom_data = 0;
            repeat(2) @(posedge wb_clk_i);
            wb_rst_i = 0;
            @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        integer timeout;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Transfer Sequence", test_num);

            rom_data = 48'hAABBCC_DDEEFF;
            start = 1;
            @(posedge wb_clk_i);
            start = 0;

            timeout = 0;

            while (!done && timeout < 100) begin
                if (wb_stb_o && wb_cyc_o) begin
                    wb_ack_i = 1;
                end else begin
                    wb_ack_i = 0;
                end
                @(posedge wb_clk_i);
                timeout = timeout + 1;
            end
            wb_ack_i = 0;




            #1;





            check_outputs(1, rom_addr, wb_adr_o, 0, wb_dat_o, wb_sel_o, 0, wb_we_o);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Reset During Operation", test_num);

            start = 1;
            @(posedge wb_clk_i);
            start = 0;


            wait(wb_stb_o);
            repeat(2) @(posedge wb_clk_i);


            wb_rst_i = 1;
            repeat(2) @(posedge wb_clk_i);
            wb_rst_i = 0;
            @(posedge wb_clk_i);


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Delayed Bus Acknowledgment", test_num);

            start = 1;
            @(posedge wb_clk_i);
            start = 0;


            repeat(5) @(posedge wb_clk_i);

            if (wb_stb_o && !done) begin
                wb_ack_i = 1;
                @(posedge wb_clk_i);
                wb_ack_i = 0;
            end


            while (!done) begin
                if (wb_stb_o) wb_ack_i = 1;
                @(posedge wb_clk_i);
                wb_ack_i = 0;
            end

            #1;


            check_outputs(1, rom_addr, wb_adr_o, 0, wb_dat_o, wb_sel_o, 0, wb_we_o);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Persistent Start Signal", test_num);

            start = 1;


            repeat(20) begin
                if (wb_stb_o) wb_ack_i = 1;
                else wb_ack_i = 0;
                @(posedge wb_clk_i);
                if (done) break;
            end
            wb_ack_i = 0;


            #1;



            check_outputs(1, rom_addr, wb_adr_o, 0, wb_dat_o, wb_sel_o, 0, wb_we_o);
            start = 0;
            @(posedge wb_clk_i);
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
        input expected_done;
        input [15:0] expected_rom_addr;
        input [15:0] expected_wb_adr_o;
        input expected_wb_cyc_o;
        input [31:0] expected_wb_dat_o;
        input [3:0] expected_wb_sel_o;
        input expected_wb_stb_o;
        input expected_wb_we_o;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_rom_addr === (expected_rom_addr ^ rom_addr ^ expected_rom_addr) &&
                expected_wb_adr_o === (expected_wb_adr_o ^ wb_adr_o ^ expected_wb_adr_o) &&
                expected_wb_cyc_o === (expected_wb_cyc_o ^ wb_cyc_o ^ expected_wb_cyc_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o) &&
                expected_wb_sel_o === (expected_wb_sel_o ^ wb_sel_o ^ expected_wb_sel_o) &&
                expected_wb_stb_o === (expected_wb_stb_o ^ wb_stb_o ^ expected_wb_stb_o) &&
                expected_wb_we_o === (expected_wb_we_o ^ wb_we_o ^ expected_wb_we_o)) begin
                $display("PASS");
                $display("  Outputs: done=%b, rom_addr=%h, wb_adr_o=%h, wb_cyc_o=%b, wb_dat_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         done, rom_addr, wb_adr_o, wb_cyc_o, wb_dat_o, wb_sel_o, wb_stb_o, wb_we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, rom_addr=%h, wb_adr_o=%h, wb_cyc_o=%b, wb_dat_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         expected_done, expected_rom_addr, expected_wb_adr_o, expected_wb_cyc_o, expected_wb_dat_o, expected_wb_sel_o, expected_wb_stb_o, expected_wb_we_o);
                $display("  Got:      done=%b, rom_addr=%h, wb_adr_o=%h, wb_cyc_o=%b, wb_dat_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         done, rom_addr, wb_adr_o, wb_cyc_o, wb_dat_o, wb_sel_o, wb_stb_o, wb_we_o);
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
        $dumpvars(0,rom_data, start, wb_ack_i, wb_clk_i, wb_rst_i, done, rom_addr, wb_adr_o, wb_cyc_o, wb_dat_o, wb_sel_o, wb_stb_o, wb_we_o);
    end

endmodule
