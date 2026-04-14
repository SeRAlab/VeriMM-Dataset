`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg emesh_access_in;
    reg [103:0] emesh_packet_in;
    reg etx_rd_wait;
    reg etx_wr_wait;
    reg remap_bypass;
    reg remap_en;
    reg reset;
    wire emesh_access_out;
    wire [103:0] emesh_packet_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .emesh_access_in(emesh_access_in),
        .emesh_packet_in(emesh_packet_in),
        .etx_rd_wait(etx_rd_wait),
        .etx_wr_wait(etx_wr_wait),
        .remap_bypass(remap_bypass),
        .remap_en(remap_en),
        .reset(reset),
        .emesh_access_out(emesh_access_out),
        .emesh_packet_out(emesh_packet_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            emesh_access_in = 0;
            emesh_packet_in = 0;
            etx_rd_wait = 0;
            etx_wr_wait = 0;
            remap_bypass = 0;
            remap_en = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Bypass Mode Pass-through");
            remap_bypass = 1;
            remap_en = 0;
            emesh_access_in = 1;
            emesh_packet_in = {8'h01, 32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hCCCC_CCCC};
            #1;

            check_outputs(1, {8'h01, 32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hCCCC_CCCC});
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Write Transaction Stall Logic");
            remap_bypass = 1;
            etx_wr_wait = 1;
            emesh_access_in = 1;

            emesh_packet_in = {7'h0, 1'b1, 32'h0, 32'h4444_4444, 32'h1111_1111};
            #1;

            check_outputs(0, 104'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Read Transaction Stall Logic");
            remap_bypass = 1;
            etx_rd_wait = 1;
            emesh_access_in = 1;

            emesh_packet_in = {6'h0, 1'b1, 1'b0, 32'h0, 32'h5555_5555, 32'h0};
            #1;

            check_outputs(0, 104'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Remap Enabled (Address Modification check)");
            remap_en = 1;
            remap_bypass = 0;
            emesh_access_in = 1;
            emesh_packet_in = {8'h01, 32'h0, 32'h8000_0000, 32'hDADA_DADA};



            @(posedge clk);
            #2;
            if (emesh_access_out === 1 && emesh_packet_out[31:0] === 32'hDADA_DADA) begin
                $display("PASS: Remap Access Propagated");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Remap Access Failed");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Recovery from Stall");
            remap_bypass = 1;
            etx_wr_wait = 1;
            emesh_access_in = 1;
            emesh_packet_in = {8'h01, 32'h0, 32'h2222_2222, 32'h3333_3333};
            @(posedge clk); #1;
            etx_wr_wait = 0;
            #1;

            check_outputs(1, {8'h01, 32'h0, 32'h2222_2222, 32'h3333_3333});
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase 006: Idle State");
            emesh_access_in = 0;
            #1;

            check_outputs(0, 104'h0);
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
        input expected_emesh_access_out;
        input [103:0] expected_emesh_packet_out;
        begin
            if (expected_emesh_access_out === (expected_emesh_access_out ^ emesh_access_out ^ expected_emesh_access_out) &&
                expected_emesh_packet_out === (expected_emesh_packet_out ^ emesh_packet_out ^ expected_emesh_packet_out)) begin
                $display("PASS");
                $display("  Outputs: emesh_access_out=%b, emesh_packet_out=%h",
                         emesh_access_out, emesh_packet_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: emesh_access_out=%b, emesh_packet_out=%h",
                         expected_emesh_access_out, expected_emesh_packet_out);
                $display("  Got:      emesh_access_out=%b, emesh_packet_out=%h",
                         emesh_access_out, emesh_packet_out);
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
        $dumpvars(0,clk, emesh_access_in, emesh_packet_in, etx_rd_wait, etx_wr_wait, remap_bypass, remap_en, reset, emesh_access_out, emesh_packet_out);
    end

endmodule
