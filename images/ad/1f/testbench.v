`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg du_stall;
    reg rst;
    reg [31:0] spr_addr;
    reg spr_cs;
    reg [31:0] spr_dat_i;
    reg spr_write;
    wire intr;
    wire [31:0] spr_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .du_stall(du_stall),
        .rst(rst),
        .spr_addr(spr_addr),
        .spr_cs(spr_cs),
        .spr_dat_i(spr_dat_i),
        .spr_write(spr_write),
        .intr(intr),
        .spr_dat_o(spr_dat_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power-on Reset and Initial State", test_num);


        rst = 1; du_stall = 0; spr_cs = 0; spr_write = 0; spr_addr = 0; spr_dat_i = 0;
        repeat(5) @(posedge clk);
        rst = 0;
        repeat(2) @(posedge clk);


        spr_addr = TTMR_ADDR;
        spr_cs = 1;
        spr_write = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
        spr_cs = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Restart Mode with Interrupt Match", test_num);

        rst = 1; #20 rst = 0;
        @(posedge clk);



        spr_addr = TTMR_ADDR;
        spr_dat_i = 32'h4800_000A;
        spr_cs = 1;
        spr_write = 1;
        @(posedge clk);
        spr_write = 0;
        spr_cs = 0;


        repeat(15) @(posedge clk);



        spr_addr = TTMR_ADDR;
        spr_cs = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'h5800_000A);
        spr_cs = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clearing Interrupt Pending Bit", test_num);

        rst = 1; #20 rst = 0;
        @(posedge clk);


        spr_addr = TTMR_ADDR;
        spr_dat_i = 32'h4800_0005;
        spr_cs = 1;
        spr_write = 1;
        @(posedge clk);
        spr_write = 0;
        repeat(10) @(posedge clk);


        spr_write = 1;
        spr_dat_i = 32'h4800_0005;
        @(posedge clk);
        spr_write = 0;


        spr_addr = TTMR_ADDR;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'h4800_0005);
        spr_cs = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Stall Functionality", test_num);

        rst = 1; #20 rst = 0;
        @(posedge clk);


        spr_addr = TTMR_ADDR;
        spr_dat_i = 32'h4800_FFFF;
        spr_cs = 1;
        spr_write = 1;
        @(posedge clk);
        spr_write = 0;


        repeat(3) @(posedge clk);
        du_stall = 1;


        repeat(10) @(posedge clk);


        spr_addr = TTCR_ADDR;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'h0000_0004);

        du_stall = 0;
        spr_cs = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Run Mode", test_num);

        rst = 1; #20 rst = 0;
        @(posedge clk);



        spr_addr = TTMR_ADDR;
        spr_dat_i = 32'h8800_0008;
        spr_cs = 1;
        spr_write = 1;
        @(posedge clk);
        spr_write = 0;


        repeat(20) @(posedge clk);


        spr_addr = TTCR_ADDR;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'h0000_0008);
        spr_cs = 0;
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
        input expected_intr;
        input [31:0] expected_spr_dat_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_intr === (expected_intr ^ intr ^ expected_intr) &&
                expected_spr_dat_o === (expected_spr_dat_o ^ spr_dat_o ^ expected_spr_dat_o)) begin
                $display("PASS");
                $display("  Outputs: intr=%b, spr_dat_o=%h",
                         intr, spr_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: intr=%b, spr_dat_o=%h",
                         expected_intr, expected_spr_dat_o);
                $display("  Got:      intr=%b, spr_dat_o=%h",
                         intr, spr_dat_o);
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

endmodule
