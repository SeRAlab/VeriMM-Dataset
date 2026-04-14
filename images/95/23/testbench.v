`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a_i;
    reg clk_i;
    reg [31:0] wd_i;
    reg we_i;
    wire [31:0] rd_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_i(a_i),
        .clk_i(clk_i),
        .wd_i(wd_i),
        .we_i(we_i),
        .rd_o(rd_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            a_i = 32'h0;
            wd_i = 32'h0;
            we_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read at Base Address (Index 0)", test_num);
            reset_dut();

            a_i = 32'h71000000;
            wd_i = 32'hAAAAAAAA;
            we_i = 1;
            @(posedge clk_i);
            #1 we_i = 0;
            #1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read at Last Entry (Index 63)", test_num);
            reset_dut();

            a_i = 32'h7100003F;
            wd_i = 32'h55555555;
            we_i = 1;
            @(posedge clk_i);
            #1 we_i = 0;
            #1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read from invalid upper bits (Mismatch)", test_num);
            reset_dut();

            a_i = 32'h71000000;
            wd_i = 32'h12345678;
            we_i = 1;
            @(posedge clk_i);
            #1 we_i = 0;

            a_i = 32'h71000100;
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read from address 0x0", test_num);
            reset_dut();
            a_i = 32'h00000000;
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write with we_i=0 (Should not store)", test_num);
            reset_dut();

            a_i = 32'h7100000A;
            wd_i = 32'hFFFFFFFF;
            we_i = 0;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite existing value", test_num);
            reset_dut();

            a_i = 32'h71000005;
            wd_i = 32'h00001111;
            we_i = 1;
            @(posedge clk_i);

            #1 wd_i = 32'h00002222;
            @(posedge clk_i);
            #1 we_i = 0;
            #1;
            #1;

            check_outputs(32'h00002222);
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
        input [31:0] expected_rd_o;
        begin
            if (expected_rd_o === (expected_rd_o ^ rd_o ^ expected_rd_o)) begin
                $display("PASS");
                $display("  Outputs: rd_o=%h",
                         rd_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_o=%h",
                         expected_rd_o);
                $display("  Got:      rd_o=%h",
                         rd_o);
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
        $dumpvars(0,a_i, clk_i, wd_i, we_i, rd_o);
    end

endmodule
