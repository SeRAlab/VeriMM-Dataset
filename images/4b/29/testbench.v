`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg de_clk;
    reg de_rstn;
    reg ee_s0_hit;
    reg ee_s1_hit;
    reg [4:0] ee_tag_adr_rd;
    reg [4:0] ee_tag_adr_wr;
    reg eo_s0_hit;
    reg eo_s1_hit;
    reg [4:0] eo_tag_adr_rd;
    reg [4:0] eo_tag_adr_wr;
    reg oe_s0_hit;
    reg oe_s1_hit;
    reg [4:0] oe_tag_adr_rd;
    reg [4:0] oe_tag_adr_wr;
    reg oo_s0_hit;
    reg oo_s1_hit;
    reg [4:0] oo_tag_adr_rd;
    reg [4:0] oo_tag_adr_wr;
    wire ee_lru;
    wire eo_lru;
    wire oe_lru;
    wire oo_lru;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .de_clk(de_clk),
        .de_rstn(de_rstn),
        .ee_s0_hit(ee_s0_hit),
        .ee_s1_hit(ee_s1_hit),
        .ee_tag_adr_rd(ee_tag_adr_rd),
        .ee_tag_adr_wr(ee_tag_adr_wr),
        .eo_s0_hit(eo_s0_hit),
        .eo_s1_hit(eo_s1_hit),
        .eo_tag_adr_rd(eo_tag_adr_rd),
        .eo_tag_adr_wr(eo_tag_adr_wr),
        .oe_s0_hit(oe_s0_hit),
        .oe_s1_hit(oe_s1_hit),
        .oe_tag_adr_rd(oe_tag_adr_rd),
        .oe_tag_adr_wr(oe_tag_adr_wr),
        .oo_s0_hit(oo_s0_hit),
        .oo_s1_hit(oo_s1_hit),
        .oo_tag_adr_rd(oo_tag_adr_rd),
        .oo_tag_adr_wr(oo_tag_adr_wr),
        .ee_lru(ee_lru),
        .eo_lru(eo_lru),
        .oe_lru(oe_lru),
        .oo_lru(oo_lru)
    );

    // Clock generation (10ns period)
    initial begin
        de_clk = 0;
        forever #5 de_clk = ~de_clk;
    end

        task reset_dut;

        begin
            de_rstn = 0;
            ee_s0_hit = 0; ee_s1_hit = 0;
            eo_s0_hit = 0; eo_s1_hit = 0;
            oe_s0_hit = 0; oe_s1_hit = 0;
            oo_s0_hit = 0; oo_s1_hit = 0;
            ee_tag_adr_wr = 5'd0; eo_tag_adr_wr = 5'd0;
            oe_tag_adr_wr = 5'd0; oo_tag_adr_wr = 5'd0;
            ee_tag_adr_rd = 5'd0; eo_tag_adr_rd = 5'd0;
            oe_tag_adr_rd = 5'd0; oo_tag_adr_rd = 5'd0;
            repeat (2) @(posedge de_clk);
            #1 de_rstn = 1;
            @(posedge de_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ee_tag_adr_rd = 5'd0;
            eo_tag_adr_rd = 5'd0;
            oe_tag_adr_rd = 5'd0;
            oo_tag_adr_rd = 5'd0;
            #10;
            $display("Testcase %0d: Check default reset values (Address 0)", test_num);
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge de_clk);
            ee_tag_adr_wr = 5'd10; ee_s0_hit = 1;
            eo_tag_adr_wr = 5'd10; eo_s0_hit = 1;
            oe_tag_adr_wr = 5'd10; oe_s0_hit = 1;
            oo_tag_adr_wr = 5'd10; oo_s0_hit = 1;
            @(posedge de_clk);
            #1;
            ee_s0_hit = 0; eo_s0_hit = 0; oe_s0_hit = 0; oo_s0_hit = 0;
            ee_tag_adr_rd = 5'd10;
            eo_tag_adr_rd = 5'd10;
            oe_tag_adr_rd = 5'd10;
            oo_tag_adr_rd = 5'd10;
            #10;
            $display("Testcase %0d: All banks S0 hit at address 10", test_num);
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge de_clk);
            ee_tag_adr_wr = 5'd31; ee_s1_hit = 1;
            eo_tag_adr_wr = 5'd31; eo_s1_hit = 1;
            oe_tag_adr_wr = 5'd31; oe_s1_hit = 1;
            oo_tag_adr_wr = 5'd31; oo_s1_hit = 1;
            @(posedge de_clk);
            #1;
            ee_s1_hit = 0; eo_s1_hit = 0; oe_s1_hit = 0; oo_s1_hit = 0;
            ee_tag_adr_rd = 5'd31;
            eo_tag_adr_rd = 5'd31;
            oe_tag_adr_rd = 5'd31;
            oo_tag_adr_rd = 5'd31;
            #10;
            $display("Testcase %0d: All banks S1 hit at address 31", test_num);
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge de_clk);
            ee_tag_adr_wr = 5'd5; ee_s0_hit = 1;
            eo_tag_adr_wr = 5'd5; eo_s1_hit = 1;
            oe_tag_adr_wr = 5'd5; oe_s0_hit = 1;
            oo_tag_adr_wr = 5'd5; oo_s1_hit = 1;
            @(posedge de_clk);
            #1;
            ee_s0_hit = 0; eo_s1_hit = 0; oe_s0_hit = 0; oo_s1_hit = 0;
            ee_tag_adr_rd = 5'd5;
            eo_tag_adr_rd = 5'd5;
            oe_tag_adr_rd = 5'd5;
            oo_tag_adr_rd = 5'd5;
            #10;
            $display("Testcase %0d: Mixed S0/S1 hits at address 5", test_num);
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge de_clk);
            ee_tag_adr_wr = 5'd2; ee_s0_hit = 1;
            @(posedge de_clk);
            #1;

            ee_s0_hit = 0;
            ee_tag_adr_wr = 5'd3; ee_s1_hit = 1;
            @(posedge de_clk);
            #1;
            ee_s1_hit = 0;

            ee_tag_adr_rd = 5'd2;
            #10;
            $display("Testcase %0d: Verify address independence (Bank EE, addr 2 vs 3)", test_num);
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge de_clk);
            ee_tag_adr_wr = 5'd15; ee_s0_hit = 1;
            @(posedge de_clk);
            #1;

            ee_s0_hit = 0; ee_s1_hit = 1;
            @(posedge de_clk);
            #1;
            ee_s1_hit = 0;
            ee_tag_adr_rd = 5'd15;
            #10;
            $display("Testcase %0d: Verify overwrite at address 15", test_num);
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_ee_lru;
        input expected_eo_lru;
        input expected_oe_lru;
        input expected_oo_lru;
        begin
            if (expected_ee_lru === (expected_ee_lru ^ ee_lru ^ expected_ee_lru) &&
                expected_eo_lru === (expected_eo_lru ^ eo_lru ^ expected_eo_lru) &&
                expected_oe_lru === (expected_oe_lru ^ oe_lru ^ expected_oe_lru) &&
                expected_oo_lru === (expected_oo_lru ^ oo_lru ^ expected_oo_lru)) begin
                $display("PASS");
                $display("  Outputs: ee_lru=%b, eo_lru=%b, oe_lru=%b, oo_lru=%b",
                         ee_lru, eo_lru, oe_lru, oo_lru);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ee_lru=%b, eo_lru=%b, oe_lru=%b, oo_lru=%b",
                         expected_ee_lru, expected_eo_lru, expected_oe_lru, expected_oo_lru);
                $display("  Got:      ee_lru=%b, eo_lru=%b, oe_lru=%b, oo_lru=%b",
                         ee_lru, eo_lru, oe_lru, oo_lru);
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
        $dumpvars(0,de_clk, de_rstn, ee_s0_hit, ee_s1_hit, ee_tag_adr_rd, ee_tag_adr_wr, eo_s0_hit, eo_s1_hit, eo_tag_adr_rd, eo_tag_adr_wr, oe_s0_hit, oe_s1_hit, oe_tag_adr_rd, oe_tag_adr_wr, oo_s0_hit, oo_s1_hit, oo_tag_adr_rd, oo_tag_adr_wr, ee_lru, eo_lru, oe_lru, oo_lru);
    end

endmodule
