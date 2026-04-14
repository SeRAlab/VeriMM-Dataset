`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_mst_rdy;
    reg i_rst_n;
    reg [63:0] i_slv_data;
    reg i_slv_valid;
    wire [7:0] o_mst_data;
    wire o_mst_valid;
    wire o_slv_rdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_mst_rdy(i_mst_rdy),
        .i_rst_n(i_rst_n),
        .i_slv_data(i_slv_data),
        .i_slv_valid(i_slv_valid),
        .o_mst_data(o_mst_data),
        .o_mst_valid(o_mst_valid),
        .o_slv_rdy(o_slv_rdy)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

    begin
        i_rst_n = 0;
        i_slv_valid = 0;
        i_slv_data = 0;
        i_mst_rdy = 0;
        repeat(2) @(posedge i_clk);
        #1 i_rst_n = 1;
        repeat(1) @(posedge i_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Initial state check after reset");
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Single word write, single byte read");
        reset_dut();


        @(posedge i_clk);
        i_slv_valid = 1;
        i_slv_data = 64'h1122334455667788;
        @(posedge i_clk);
        i_slv_valid = 0;


        i_mst_rdy = 1;
        @(posedge i_clk);
        #1;


        #1;



        check_outputs(8'h88, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Full word serialization (8 bytes)");
        reset_dut();


        @(posedge i_clk);
        i_slv_valid = 1;
        i_slv_data = 64'h0102030405060708;
        @(posedge i_clk);
        i_slv_valid = 0;


        i_mst_rdy = 1;
        repeat(8) begin
            wait(o_mst_valid);
            @(posedge i_clk);
        end
        i_mst_rdy = 0;
        #1;


        #1;



        check_outputs(o_mst_data, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Fill to 120-byte limit check");
        reset_dut();


        i_slv_valid = 1;
        for (i = 0; i < 15; i = i + 1) begin
            i_slv_data = {32'hAAAA_BBBB, i[31:0]};
            @(posedge i_clk);
            while(!o_slv_rdy) @(posedge i_clk);
        end
        i_slv_valid = 0;
        #1;


        #1;



        check_outputs(o_mst_data, o_mst_valid, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Read after reaching limit to restore readiness");
        reset_dut();


        i_slv_valid = 1;
        for (i = 0; i < 15; i = i + 1) begin
            i_slv_data = $random;
            @(posedge i_clk);
        end
        i_slv_valid = 0;


        i_mst_rdy = 1;
        repeat(8) begin
            wait(o_mst_valid);
            @(posedge i_clk);
        end
        i_mst_rdy = 0;
        #1;


        #1;



        check_outputs(o_mst_data, o_mst_valid, 1'b1);
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
        input [7:0] expected_o_mst_data;
        input expected_o_mst_valid;
        input expected_o_slv_rdy;
        begin
            if (expected_o_mst_data === (expected_o_mst_data ^ o_mst_data ^ expected_o_mst_data) &&
                expected_o_mst_valid === (expected_o_mst_valid ^ o_mst_valid ^ expected_o_mst_valid) &&
                expected_o_slv_rdy === (expected_o_slv_rdy ^ o_slv_rdy ^ expected_o_slv_rdy)) begin
                $display("PASS");
                $display("  Outputs: o_mst_data=%h, o_mst_valid=%b, o_slv_rdy=%b",
                         o_mst_data, o_mst_valid, o_slv_rdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_mst_data=%h, o_mst_valid=%b, o_slv_rdy=%b",
                         expected_o_mst_data, expected_o_mst_valid, expected_o_slv_rdy);
                $display("  Got:      o_mst_data=%h, o_mst_valid=%b, o_slv_rdy=%b",
                         o_mst_data, o_mst_valid, o_slv_rdy);
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
        $dumpvars(0,i_clk, i_mst_rdy, i_rst_n, i_slv_data, i_slv_valid, o_mst_data, o_mst_valid, o_slv_rdy);
    end

endmodule
