`timescale 1ns/1ps

module tessera_mem_wbif_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_ack;
    reg [31:0] read_data;
    reg res;
    reg [31:0] wb_adr_i;
    reg wb_cab_i;
    reg wb_cyc_i;
    reg [31:0] wb_dat_i;
    reg [3:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    reg write_ack;
    wire [31:0] read_address;
    wire [3:0] read_byte;
    wire read_req;
    wire wb_ack_o;
    wire [31:0] wb_dat_o;
    wire wb_err_o;
    wire [31:0] write_address;
    wire [3:0] write_byte;
    wire [31:0] write_data;
    wire write_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tessera_mem_wbif dut (
        .clk(clk),
        .read_ack(read_ack),
        .read_data(read_data),
        .res(res),
        .wb_adr_i(wb_adr_i),
        .wb_cab_i(wb_cab_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .write_ack(write_ack),
        .read_address(read_address),
        .read_byte(read_byte),
        .read_req(read_req),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o),
        .wb_err_o(wb_err_o),
        .write_address(write_address),
        .write_byte(write_byte),
        .write_data(write_data),
        .write_req(write_req)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            res = 1;
            wb_cyc_i = 0; wb_stb_i = 0; wb_we_i = 0;
            wb_adr_i = 0; wb_dat_i = 0; wb_sel_i = 0;
            wb_cab_i = 0; write_ack = 0; read_ack = 0; read_data = 0;
            @(posedge clk);
            #1 res = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Write Operation");
            reset_dut();
            @(posedge clk);
            wb_cyc_i = 1; wb_stb_i = 1; wb_we_i = 1;
            wb_adr_i = 32'hAAAA_5555; wb_dat_i = 32'h1234_5678; wb_sel_i = 4'hF;
            #1;
            write_ack = 1;
            #1;
            #1;

            check_outputs(0, 0, 0, 1, 0, 0, 32'hAAAA_5555, 4'hF, 32'h1234_5678, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simple Read Operation");
            reset_dut();
            @(posedge clk);
            wb_cyc_i = 1; wb_stb_i = 1; wb_we_i = 0;
            wb_adr_i = 32'hBBBB_CCCC; wb_sel_i = 4'hF;
            #1;
            read_ack = 1;
            read_data = 32'hDEAF_BEEF;
            #1;
            #1;

            check_outputs(32'hBBBB_CCCC, 4'hF, 1, 1, 32'hDEAF_BEEF, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Partial Write (Byte Selects)");
            reset_dut();
            @(posedge clk);
            wb_cyc_i = 1; wb_stb_i = 1; wb_we_i = 1;
            wb_adr_i = 32'h0000_0100; wb_dat_i = 32'h0000_FF00; wb_sel_i = 4'b0010;
            #1;
            write_ack = 1;
            #1;
            #1;

            check_outputs(0, 0, 0, 1, 0, 0, 32'h0000_0100, 4'b0010, 32'h0000_FF00, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Inactive Strobe (CYC=1, STB=0)");
            reset_dut();
            @(posedge clk);
            wb_cyc_i = 1; wb_stb_i = 0; wb_we_i = 1;
            wb_adr_i = 32'hFFFF_FFFF;
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tessera_mem_wbif Testbench");
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
        input [31:0] expected_read_address;
        input [3:0] expected_read_byte;
        input expected_read_req;
        input expected_wb_ack_o;
        input [31:0] expected_wb_dat_o;
        input expected_wb_err_o;
        input [31:0] expected_write_address;
        input [3:0] expected_write_byte;
        input [31:0] expected_write_data;
        input expected_write_req;
        begin
            if (expected_read_address === (expected_read_address ^ read_address ^ expected_read_address) &&
                expected_read_byte === (expected_read_byte ^ read_byte ^ expected_read_byte) &&
                expected_read_req === (expected_read_req ^ read_req ^ expected_read_req) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o) &&
                expected_wb_err_o === (expected_wb_err_o ^ wb_err_o ^ expected_wb_err_o) &&
                expected_write_address === (expected_write_address ^ write_address ^ expected_write_address) &&
                expected_write_byte === (expected_write_byte ^ write_byte ^ expected_write_byte) &&
                expected_write_data === (expected_write_data ^ write_data ^ expected_write_data) &&
                expected_write_req === (expected_write_req ^ write_req ^ expected_write_req)) begin
                $display("PASS");
                $display("  Outputs: read_address=%h, read_byte=%h, read_req=%b, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b, write_address=%h, write_byte=%h, write_data=%h, write_req=%b",
                         read_address, read_byte, read_req, wb_ack_o, wb_dat_o, wb_err_o, write_address, write_byte, write_data, write_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_address=%h, read_byte=%h, read_req=%b, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b, write_address=%h, write_byte=%h, write_data=%h, write_req=%b",
                         expected_read_address, expected_read_byte, expected_read_req, expected_wb_ack_o, expected_wb_dat_o, expected_wb_err_o, expected_write_address, expected_write_byte, expected_write_data, expected_write_req);
                $display("  Got:      read_address=%h, read_byte=%h, read_req=%b, wb_ack_o=%b, wb_dat_o=%h, wb_err_o=%b, write_address=%h, write_byte=%h, write_data=%h, write_req=%b",
                         read_address, read_byte, read_req, wb_ack_o, wb_dat_o, wb_err_o, write_address, write_byte, write_data, write_req);
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
        $dumpvars(0,clk, read_ack, read_data, res, wb_adr_i, wb_cab_i, wb_cyc_i, wb_dat_i, wb_sel_i, wb_stb_i, wb_we_i, write_ack, read_address, read_byte, read_req, wb_ack_o, wb_dat_o, wb_err_o, write_address, write_byte, write_data, write_req);
    end

endmodule
