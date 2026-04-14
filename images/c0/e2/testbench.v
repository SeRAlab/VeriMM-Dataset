`timescale 1ns/1ps

module tessera_vga_wbif_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg res;
    reg [31:0] wb_adr_i;
    reg wb_cab_i;
    reg wb_cyc_i;
    reg [31:0] wb_dat_i;
    reg [3:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [12:0] base;
    wire enable;
    wire wb_ack_o;
    wire [31:0] wb_dat_o;
    wire wb_err_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tessera_vga_wbif dut (
        .clk(clk),
        .res(res),
        .wb_adr_i(wb_adr_i),
        .wb_cab_i(wb_cab_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .base(base),
        .enable(enable),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o),
        .wb_err_o(wb_err_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        res = 1;
        wb_adr_i = 0;
        wb_cab_i = 0;
        wb_cyc_i = 0;
        wb_dat_i = 0;
        wb_sel_i = 0;
        wb_stb_i = 0;
        wb_we_i = 0;
        repeat(2) @(posedge clk);
        res = 0;
        @(posedge clk);
    end
        endtask
    task wb_write;

        input [31:0] addr;
        input [31:0] data;
    begin
        @(posedge clk);
        wb_adr_i = addr;
        wb_dat_i = data;
        wb_we_i  = 1;
        wb_cyc_i = 1;
        wb_stb_i = 1;
        wb_sel_i = 4'hf;
        wait(wb_ack_o);
        @(posedge clk);
        wb_cyc_i = 0;
        wb_stb_i = 0;
        wb_we_i  = 0;
    end
        endtask

    task wb_read_setup;

        input [31:0] addr;
    begin
        @(posedge clk);
        wb_adr_i = addr;
        wb_we_i  = 0;
        wb_cyc_i = 1;
        wb_stb_i = 1;
        wb_sel_i = 4'hf;
        wait(wb_ack_o);
    end
        endtask

    task wb_read_cleanup;

    begin
        @(posedge clk);
        wb_cyc_i = 0;
        wb_stb_i = 0;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(13'h0000, 1'b0, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Write Reg0 (Base Address)", test_num);
        reset_dut();

        wb_write(32'h0000_0000, 32'h0080_0000);
        #1;

        check_outputs(13'h1000, 1'b0, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Write Reg1 (Enable Signal)", test_num);
        reset_dut();

        wb_write(32'h0000_0004, 32'h0000_0001);
        #1;

        check_outputs(13'h0000, 1'b1, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Read Reg0 Data", test_num);
        reset_dut();
        wb_write(32'h0000_0000, 32'h1234_5678);
        wb_read_setup(32'h0000_0000);


        #1;



        check_outputs(13'h068A, 1'b0, 1'b1, 32'h1234_5678, 1'b0);
        wb_read_cleanup();
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Read Reg1 Data", test_num);
        reset_dut();
        wb_write(32'h0000_0004, 32'hAAAA_5551);
        wb_read_setup(32'h0000_0004);

        #1;


        check_outputs(13'h0000, 1'b1, 1'b1, 32'hAAAA_5551, 1'b0);
        wb_read_cleanup();
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Reset During Operation", test_num);
        reset_dut();
        wb_write(32'h0, 32'hFFFF_FFFF);
        wb_write(32'h4, 32'h0000_0001);

        res = 1;
        #2;

        #1;


        check_outputs(13'h0000, 1'b0, 1'b0, 32'h0, 1'b0);
        res = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tessera_vga_wbif Testbench");
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
        input [12:0] expected_base;
        input expected_enable;
        input expected_wb_ack_o;
        input [31:0] expected_wb_dat_o;
        input expected_wb_err_o;
        begin
            if (expected_base === (expected_base ^ base ^ expected_base) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o) &&
                expected_wb_err_o === (expected_wb_err_o ^ wb_err_o ^ expected_wb_err_o)) begin
                $display("PASS");
                $display("  Outputs: base=%h, enable=%b, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b",
                         base, enable, wb_ack_o, wb_dat_o, wb_err_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: base=%h, enable=%b, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b",
                         expected_base, expected_enable, expected_wb_ack_o, expected_wb_dat_o, expected_wb_err_o);
                $display("  Got:      base=%h, enable=%b, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b",
                         base, enable, wb_ack_o, wb_dat_o, wb_err_o);
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
        $dumpvars(0,clk, res, wb_adr_i, wb_cab_i, wb_cyc_i, wb_dat_i, wb_sel_i, wb_stb_i, wb_we_i, base, enable, wb_ack_o, wb_dat_o, wb_err_o);
    end

endmodule
