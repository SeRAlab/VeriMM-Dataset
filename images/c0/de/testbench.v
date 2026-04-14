`timescale 1ns/1ps

module tessera_sdram_wbif_tb;

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
    tessera_sdram_wbif dut (
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
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_adr_i = 0;
            wb_sel_i = 0;
            wb_we_i = 0;
            wb_dat_i = 0;
            wb_cab_i = 0;
            write_ack = 0;
            read_ack = 0;
            read_data = 0;
            repeat(2) @(posedge clk);
            res = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and Idle state check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 4'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'h0, 4'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write Transaction", test_num);
            reset_dut();


            wb_adr_i = 32'h12345678;
            wb_dat_i = 32'hDEADBEEF;
            wb_sel_i = 4'b1111;
            wb_we_i  = 1'b1;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;


            @(posedge clk);
            #1;


            write_ack = 1'b1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 4'h0, 1'b0, 1'b1, 32'h0, 1'b0, 32'h12345678, 4'hf, 32'hDEADBEEF, 1'b1);


            wb_cyc_i = 0;
            wb_stb_i = 0;
            write_ack = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Read Transaction", test_num);
            reset_dut();


            wb_adr_i = 32'hAABBCCDD;
            wb_sel_i = 4'b1111;
            wb_we_i  = 1'b0;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;

            @(posedge clk);
            #1;


            read_data = 32'h55AA55AA;
            read_ack = 1'b1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hAABBCCDD, 4'hf, 1'b1, 1'b1, 32'h55AA55AA, 1'b0, 32'h0, 4'h0, 32'h0, 1'b0);


            wb_cyc_i = 0;
            wb_stb_i = 0;
            read_ack = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Byte Lane Selection (Write)", test_num);
            reset_dut();


            wb_adr_i = 32'h0000FF00;
            wb_dat_i = 32'h0000CAFE;
            wb_sel_i = 4'b0011;
            wb_we_i  = 1'b1;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;

            @(posedge clk);
            #1;
            write_ack = 1'b1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 4'h0, 1'b0, 1'b1, 32'h0, 1'b0, 32'h0000FF00, 4'b0011, 32'h0000CAFE, 1'b1);

            wb_cyc_i = 0;
            wb_stb_i = 0;
            write_ack = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wishbone Cycle with no Strobe", test_num);
            reset_dut();


            wb_adr_i = 32'h88888888;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b0;
            wb_we_i  = 1'b1;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 4'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'h0, 4'h0, 32'h0, 1'b0);

            wb_cyc_i = 0;
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read with partial Byte Selection", test_num);
            reset_dut();

            wb_adr_i = 32'h44444444;
            wb_sel_i = 4'b1000;
            wb_we_i  = 1'b0;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;

            @(posedge clk);
            #1;
            read_data = 32'hFF000000;
            read_ack = 1'b1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h44444444, 4'b1000, 1'b1, 1'b1, 32'hFF000000, 1'b0, 32'h0, 4'h0, 32'h0, 1'b0);

            wb_cyc_i = 0;
            wb_stb_i = 0;
            read_ack = 0;
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tessera_sdram_wbif Testbench");
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
