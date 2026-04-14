`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] a;
    reg clk_cog;
    reg [31:0] d;
    reg ena_bus;
    reg w;
    reg [3:0] wb;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk_cog(clk_cog),
        .d(d),
        .ena_bus(ena_bus),
        .w(w),
        .wb(wb),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk_cog = 0;
        forever #5 clk_cog = ~clk_cog;
    end

        task reset_dut;

        begin
            ena_bus = 0;
            w = 0;
            wb = 4'b0000;
            a = 14'h0;
            d = 32'h0;
            @(posedge clk_cog);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Full Word Write and Read");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clk_cog);
            ena_bus = 1;
            w = 1;
            wb = 4'b1111;
            a = 14'h00A5;
            d = 32'hDEADBEEF;

            @(negedge clk_cog);

            w = 0;

            @(posedge clk_cog);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Byte-wise Write Operations");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clk_cog);
            ena_bus = 1;
            w = 1;
            wb = 4'b1111;
            a = 14'h0010;
            d = 32'h00000000;


            @(negedge clk_cog);
            wb = 4'b0101;
            d = 32'hFFBBFFAA;

            @(negedge clk_cog);
            w = 0;

            @(posedge clk_cog);
            #2;
            #1;

            check_outputs(32'h00BB00AA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bus Enable Gating");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clk_cog);
            ena_bus = 0;
            w = 1;
            wb = 4'b1111;
            a = 14'h0020;
            d = 32'h5555AAAA;

            @(negedge clk_cog);

            ena_bus = 1;
            w = 0;
            a = 14'h0020;

            @(posedge clk_cog);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Address Decoding Isolation");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clk_cog);
            ena_bus = 1;
            w = 1;
            wb = 4'b1111;
            a = 14'h0001;
            d = 32'h11111111;


            @(negedge clk_cog);
            a = 14'h3FFF;
            d = 32'hFFFFFFFF;


            @(negedge clk_cog);
            w = 0;
            a = 14'h0001;

            @(posedge clk_cog);
            #2;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting existing data");
            reset_dut();
            test_num = test_num + 1;

            @(negedge clk_cog);
            ena_bus = 1;
            w = 1;
            wb = 4'b1111;
            a = 14'h0100;
            d = 32'hAAAAAAAA;

            @(negedge clk_cog);
            d = 32'h55555555;

            @(negedge clk_cog);
            w = 0;

            @(posedge clk_cog);
            #2;
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,a, clk_cog, d, ena_bus, w, wb, q);
    end

endmodule
