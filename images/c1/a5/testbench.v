`timescale 1ns/1ps

module zipjiffies_tb;

    // Testbench signals (sequential circuit)
    reg i_ce;
    reg i_clk;
    reg i_wb_cyc;
    reg [31:0] i_wb_data;
    reg i_wb_stb;
    reg i_wb_we;
    wire o_int;
    wire o_wb_ack;
    wire [31:0] o_wb_data;
    wire o_wb_stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zipjiffies dut (
        .i_ce(i_ce),
        .i_clk(i_clk),
        .i_wb_cyc(i_wb_cyc),
        .i_wb_data(i_wb_data),
        .i_wb_stb(i_wb_stb),
        .i_wb_we(i_wb_we),
        .o_int(o_int),
        .o_wb_ack(o_wb_ack),
        .o_wb_data(o_wb_data),
        .o_wb_stall(o_wb_stall)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

    begin
        i_ce = 0;
        i_wb_cyc = 0;
        i_wb_stb = 0;
        i_wb_we = 0;
        i_wb_data = 32'h0;
        @(posedge i_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Basic Increment...");
        reset_dut();
        i_ce = 1;
        repeat(10) @(posedge i_clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 32'd10, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Wishbone Write and Ack...");
        reset_dut();
        i_wb_cyc = 1;
        i_wb_stb = 1;
        i_wb_we = 1;
        i_wb_data = 32'h0000_000F;
        @(posedge i_clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 32'd0, 1'b0);
        i_wb_cyc = 0;
        i_wb_stb = 0;
        i_wb_we = 0;
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Interrupt Generation...");
        reset_dut();

        i_wb_cyc = 1; i_wb_stb = 1; i_wb_we = 1; i_wb_data = 32'd5;
        @(posedge i_clk);
        i_wb_cyc = 0; i_wb_stb = 0; i_wb_we = 0;

        i_ce = 1;
        repeat(6) @(posedge i_clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0, 32'd5, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Clock Enable Control...");
        reset_dut();
        i_ce = 1;
        repeat(5) @(posedge i_clk);
        i_ce = 0;
        repeat(5) @(posedge i_clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 32'd5, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Wishbone Read...");
        reset_dut();
        i_ce = 1;
        repeat(25) @(posedge i_clk);
        i_ce = 0;

        i_wb_cyc = 1; i_wb_stb = 1; i_wb_we = 0;
        @(posedge i_clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 32'd25, 1'b0);
        i_wb_cyc = 0; i_wb_stb = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zipjiffies Testbench");
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
        input expected_o_int;
        input expected_o_wb_ack;
        input [31:0] expected_o_wb_data;
        input expected_o_wb_stall;
        begin
            if (expected_o_int === (expected_o_int ^ o_int ^ expected_o_int) &&
                expected_o_wb_ack === (expected_o_wb_ack ^ o_wb_ack ^ expected_o_wb_ack) &&
                expected_o_wb_data === (expected_o_wb_data ^ o_wb_data ^ expected_o_wb_data) &&
                expected_o_wb_stall === (expected_o_wb_stall ^ o_wb_stall ^ expected_o_wb_stall)) begin
                $display("PASS");
                $display("  Outputs: o_int=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         o_int, o_wb_ack, o_wb_data, o_wb_stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_int=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         expected_o_int, expected_o_wb_ack, expected_o_wb_data, expected_o_wb_stall);
                $display("  Got:      o_int=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         o_int, o_wb_ack, o_wb_data, o_wb_stall);
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
        $dumpvars(0,i_ce, i_clk, i_wb_cyc, i_wb_data, i_wb_stb, i_wb_we, o_int, o_wb_ack, o_wb_data, o_wb_stall);
    end

endmodule
