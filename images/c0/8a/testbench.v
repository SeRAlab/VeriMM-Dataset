`timescale 1ns/1ps

module wb_slv_wrapper_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] adr_i;
    reg clk_i;
    reg [31:0] dat_i;
    reg [31:0] data_in;
    reg rst_i;
    reg stb_i;
    reg we_i;
    wire ack_o;
    wire [7:0] addr_out;
    wire clk;
    wire [31:0] dat_o;
    wire [31:0] data_out;
    wire rd_out;
    wire rst;
    wire wr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wb_slv_wrapper dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .data_in(data_in),
        .rst_i(rst_i),
        .stb_i(stb_i),
        .we_i(we_i),
        .ack_o(ack_o),
        .addr_out(addr_out),
        .clk(clk),
        .dat_o(dat_o),
        .data_out(data_out),
        .rd_out(rd_out),
        .rst(rst),
        .wr_out(wr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1'b1;
            stb_i = 1'b0;
            we_i = 1'b0;
            adr_i = 32'h0;
            dat_i = 32'h0;
            data_in = 32'h0;
            repeat(2) @(posedge clk_i);
            #1;
            rst_i = 1'b0;
            repeat(1) @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset and Idle State...");
            reset_dut();


            #1;



            check_outputs(1'b0, 8'h00, 1'b1, 32'h0, 32'h0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Basic Write Operation...");
            reset_dut();
            adr_i = 32'h0000_0010;
            dat_i = 32'hDEADBEEF;
            we_i  = 1'b1;
            stb_i = 1'b1;
            @(posedge clk_i);
            #1;


            #1;



            check_outputs(ack_o, 8'h10, 1'b1, 32'h0, 32'hDEADBEEF, 1'b0, 1'b0, 1'b1);
            stb_i = 1'b0;
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Basic Read Operation...");
            reset_dut();
            adr_i   = 32'h0000_0020;
            data_in = 32'hCAFEBABE;
            we_i    = 1'b0;
            stb_i   = 1'b1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(ack_o, 8'h20, 1'b1, 32'hCAFEBABE, 32'h0, 1'b1, 1'b0, 1'b0);
            stb_i = 1'b0;
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Address Truncation...");
            reset_dut();
            adr_i = 32'h1234_5678;
            dat_i = 32'hAAAA_BBBB;
            we_i  = 1'b1;
            stb_i = 1'b1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(ack_o, 8'h78, 1'b1, 32'h0, 32'hAAAA_BBBB, 1'b0, 1'b0, 1'b1);
            stb_i = 1'b0;
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Inactive Strobe Verification...");
            reset_dut();
            adr_i = 32'h0000_00FF;
            dat_i = 32'h1122_3344;
            we_i  = 1'b1;
            stb_i = 1'b0;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0, 8'hFF, 1'b1, 32'h0, 32'h1122_3344, 1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wb_slv_wrapper Testbench");
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
        input expected_ack_o;
        input [7:0] expected_addr_out;
        input expected_clk;
        input [31:0] expected_dat_o;
        input [31:0] expected_data_out;
        input expected_rd_out;
        input expected_rst;
        input expected_wr_out;
        begin
            if (expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_addr_out === (expected_addr_out ^ addr_out ^ expected_addr_out) &&
                expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_rd_out === (expected_rd_out ^ rd_out ^ expected_rd_out) &&
                expected_rst === (expected_rst ^ rst ^ expected_rst) &&
                expected_wr_out === (expected_wr_out ^ wr_out ^ expected_wr_out)) begin
                $display("PASS");
                $display("  Outputs: ack_o=%b, addr_out=%h, clk=%b, dat_o=%h, data_out=%h, rd_out=%b, rst=%b, wr_out=%b",
                         ack_o, addr_out, clk, dat_o, data_out, rd_out, rst, wr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_o=%b, addr_out=%h, clk=%b, dat_o=%h, data_out=%h, rd_out=%b, rst=%b, wr_out=%b",
                         expected_ack_o, expected_addr_out, expected_clk, expected_dat_o, expected_data_out, expected_rd_out, expected_rst, expected_wr_out);
                $display("  Got:      ack_o=%b, addr_out=%h, clk=%b, dat_o=%h, data_out=%h, rd_out=%b, rst=%b, wr_out=%b",
                         ack_o, addr_out, clk, dat_o, data_out, rd_out, rst, wr_out);
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
        $dumpvars(0,adr_i, clk_i, dat_i, data_in, rst_i, stb_i, we_i, ack_o, addr_out, clk, dat_o, data_out, rd_out, rst, wr_out);
    end

endmodule
