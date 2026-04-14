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
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Behavior");
            reset_dut();

            #1;


            check_outputs(1'b0, 104'h0);
        end
        endtask

    task testcase002;

        reg [103:0] test_packet;
        begin
            $display("Testcase 002: Bypass Mode (Pass-through)");
            reset_dut();
            test_packet = 104'hA5A5A5A5_B4B4B4B4_C3C3C3C3_D2;
            remap_bypass = 1;
            emesh_access_in = 1;
            emesh_packet_in = test_packet;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, test_packet);
        end
        endtask

    task testcase003;

        reg [103:0] write_packet;
        begin
            $display("Testcase 003: ETX Write Wait Blocking");
            reset_dut();
            write_packet = 104'hFFFFFFFF_EEEEEEEE_DDDDDDDD_02;
            etx_wr_wait = 1;
            remap_bypass = 1;
            emesh_access_in = 1;
            emesh_packet_in = write_packet;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 104'h0);
        end
        endtask

    task testcase004;

        reg [103:0] read_packet;
        begin
            $display("Testcase 004: ETX Read Wait Blocking");
            reset_dut();
            read_packet = 104'h11111111_22222222_33333333_01;
            etx_rd_wait = 1;
            remap_bypass = 1;
            emesh_access_in = 1;
            emesh_packet_in = read_packet;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 104'h0);
        end
        endtask

    task testcase005;

        reg [103:0] test_packet;
        begin
            $display("Testcase 005: Remap Enabled Signal Propagation");
            reset_dut();
            test_packet = 104'h12345678_9ABCDEF0_13579BDF_02;
            remap_en = 1;
            remap_bypass = 0;
            emesh_access_in = 1;
            emesh_packet_in = test_packet;

            @(posedge clk);
            #1;

            if (emesh_access_out === 1'b1) begin
                $display("PASS: Access bit propagated with remap enabled");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Access bit did not propagate with remap enabled");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        reg [103:0] write_packet;
        begin
            $display("Testcase 006: Write Wait Released");
            reset_dut();
            write_packet = 104'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_02;
            etx_wr_wait = 0;
            remap_bypass = 1;
            emesh_access_in = 1;
            emesh_packet_in = write_packet;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, write_packet);
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
