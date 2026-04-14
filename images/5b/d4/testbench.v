`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] Address;
    reg [31:0] D_In;
    reg clk;
    reg dm_cs;
    reg dm_rd;
    reg dm_wr;
    wire [31:0] D_Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .D_In(D_In),
        .clk(clk),
        .dm_cs(dm_cs),
        .dm_rd(dm_rd),
        .dm_wr(dm_wr),
        .D_Out(D_Out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Address = 12'b0;
            D_In = 32'b0;
            dm_cs = 0;
            dm_rd = 0;
            dm_wr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);
            reset_dut();


            dm_cs = 1; dm_wr = 1; dm_rd = 0;
            Address = 12'h000;
            D_In = 32'h12345678;
            @(posedge clk);
            #1;


            dm_wr = 0;
            @(posedge clk);
            #1;


            dm_cs = 1; dm_rd = 1;
            Address = 12'h000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read at Address 0x500", test_num);
            reset_dut();


            dm_cs = 1; dm_wr = 1; dm_rd = 0;
            Address = 12'h500;
            D_In = 32'hABCDEFFF;
            @(posedge clk);
            #1;

            dm_wr = 0;
            @(posedge clk);
            #1;


            dm_cs = 1; dm_rd = 1;
            Address = 12'h500;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hABCDEFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-Z check (dm_cs = 0)", test_num);
            reset_dut();


            dm_cs = 0; dm_rd = 1; dm_wr = 0;
            Address = 12'h000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hzzzzzzzz);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-Z check (dm_rd=0, dm_wr=0)", test_num);
            reset_dut();


            dm_cs = 1; dm_rd = 0; dm_wr = 0;
            Address = 12'h000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hzzzzzzzz);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (0xFFC)", test_num);
            reset_dut();


            dm_cs = 1; dm_wr = 1; dm_rd = 0;
            Address = 12'hFFC;
            D_In = 32'h55AA55AA;
            @(posedge clk);
            #1;

            dm_wr = 0;
            @(posedge clk);
            #1;


            dm_cs = 1; dm_rd = 1;
            Address = 12'hFFC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence across multiple addresses", test_num);
            reset_dut();


            dm_cs = 1; dm_wr = 1; Address = 12'h000; D_In = 32'h11111111;
            @(posedge clk); #1;


            dm_cs = 1; dm_wr = 1; Address = 12'h004; D_In = 32'h22222222;
            @(posedge clk); #1;


            dm_wr = 0; dm_rd = 1; Address = 12'h000;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h11111111);
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
        input [31:0] expected_D_Out;
        begin
            if (expected_D_Out === (expected_D_Out ^ D_Out ^ expected_D_Out)) begin
                $display("PASS");
                $display("  Outputs: D_Out=%h",
                         D_Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_Out=%h",
                         expected_D_Out);
                $display("  Got:      D_Out=%h",
                         D_Out);
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
        $dumpvars(0,Address, D_In, clk, dm_cs, dm_rd, dm_wr, D_Out);
    end

endmodule
