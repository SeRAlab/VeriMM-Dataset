`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg emesh_access_in;
    reg [103:0] emesh_packet_in;
    reg [31:0] remap_base;
    reg [1:0] remap_mode;
    reg [11:0] remap_pattern;
    reg [11:0] remap_sel;
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
        .remap_base(remap_base),
        .remap_mode(remap_mode),
        .remap_pattern(remap_pattern),
        .remap_sel(remap_sel),
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
            emesh_access_in = 0;
            emesh_packet_in = 104'b0;
            remap_base = 32'b0;
            remap_mode = 2'b0;
            remap_pattern = 12'b0;
            remap_sel = 12'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Bypass Mode");
            reset_dut();
            test_num = 1;
            emesh_access_in = 1;
            emesh_packet_in = 104'hDEADBEEF_CAFED00D_12345678_0A;
            remap_mode = 2'b00;
            remap_sel = 12'hABC;
            remap_pattern = 12'hABC;
            remap_base = 32'hFFFFFFFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 104'hDEADBEEF_CAFED00D_12345678_0A);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Static Remap Match");
            reset_dut();
            test_num = 2;
            emesh_access_in = 1;
            emesh_packet_in = 104'hAAAAAAAABBBBBBBB0000000011;
            remap_mode = 2'b01;
            remap_sel = 12'h555;
            remap_pattern = 12'h555;
            remap_base = 32'hEEEEEEEE;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 104'hAAAAAAAABBBBBBBBEEEEEEEE);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Static Remap Mismatch");
            reset_dut();
            test_num = 3;
            emesh_access_in = 1;
            emesh_packet_in = 104'h11112222333344445555666677;
            remap_mode = 2'b01;
            remap_sel = 12'hAAA;
            remap_pattern = 12'hBBB;
            remap_base = 32'h0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 104'h11112222333344445555666677);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Dynamic Remap Mode");
            reset_dut();
            test_num = 4;
            emesh_access_in = 1;
            emesh_packet_in = 104'hFFFFFFFFFFFFFFFF00000000FF;
            remap_mode = 2'b10;
            remap_base = 32'h12345678;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 104'hFFFFFFFFFFFFFFFF12345678);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Access Gating");
            reset_dut();
            test_num = 5;
            emesh_access_in = 0;
            emesh_packet_in = 104'hFFFFFFFFFFFFFFFFFFFFFFFFFF;
            remap_mode = 2'b00;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 104'hFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Preservation of Payload");
            reset_dut();
            test_num = 6;
            emesh_access_in = 1;

            emesh_packet_in = {72'hFEDCBA9876543210FF, 32'h00000000};
            remap_mode = 2'b01;
            remap_sel = 12'hFFF;
            remap_pattern = 12'hFFF;
            remap_base = 32'h87654321;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, {72'hFEDCBA9876543210FF, 32'h87654321});
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
        $dumpvars(0,clk, emesh_access_in, emesh_packet_in, remap_base, remap_mode, remap_pattern, remap_sel, emesh_access_out, emesh_packet_out);
    end

endmodule
