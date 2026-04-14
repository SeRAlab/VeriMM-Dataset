`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg flush_i;
    reg [31:0] inst_i;
    reg [31:0] pc_i;
    reg stall_i;
    wire [31:0] inst_o;
    wire [31:0] pc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .flush_i(flush_i),
        .inst_i(inst_i),
        .pc_i(pc_i),
        .stall_i(stall_i),
        .inst_o(inst_o),
        .pc_o(pc_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            flush_i = 1;
            stall_i = 0;
            inst_i = 0;
            pc_i = 0;
            @(posedge clk_i);
            #1;
            flush_i = 0;
            inst_i = 0;
            pc_i = 0;
            stall_i = 0;

            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Basic Pass-through", test_num);

            inst_i = 32'hA5A5_B6B6;
            pc_i   = 32'h0000_1000;
            stall_i = 0;
            flush_i = 0;

            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hA5A5_B6B6, 32'h0000_1000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Stall Functionality", test_num);


            inst_i = 32'h1111_1111;
            pc_i   = 32'h0000_1000;
            stall_i = 0;
            flush_i = 0;
            @(posedge clk_i);
            #1;


            inst_i = 32'h2222_2222;
            pc_i   = 32'h0000_2000;
            stall_i = 1;
            @(posedge clk_i);
            #1;


            #1;



            check_outputs(32'h1111_1111, 32'h0000_1000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Flush Functionality", test_num);

            inst_i = 32'hDEAD_BEEF;
            pc_i   = 32'h0000_4000;
            stall_i = 0;
            flush_i = 1;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(32'h0000_0000, 32'h0000_4000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Flush Priority Over Stall", test_num);


            inst_i = 32'hAAAA_AAAA;
            pc_i   = 32'h0000_1111;
            stall_i = 0;
            flush_i = 0;
            @(posedge clk_i);
            #1;


            inst_i = 32'hBBBB_BBBB;
            pc_i   = 32'h0000_2222;
            stall_i = 1;
            flush_i = 1;
            @(posedge clk_i);
            #1;



            #1;




            check_outputs(32'h0000_0000, 32'h0000_1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Recovery after Stall/Flush", test_num);


            flush_i = 1;
            stall_i = 1;
            @(posedge clk_i);
            #1;


            flush_i = 0;
            stall_i = 0;
            inst_i = 32'h1234_5678;
            pc_i   = 32'h0000_ABCD;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h1234_5678, 32'h0000_ABCD);
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
        input [31:0] expected_inst_o;
        input [31:0] expected_pc_o;
        begin
            if (expected_inst_o === (expected_inst_o ^ inst_o ^ expected_inst_o) &&
                expected_pc_o === (expected_pc_o ^ pc_o ^ expected_pc_o)) begin
                $display("PASS");
                $display("  Outputs: inst_o=%h, pc_o=%h",
                         inst_o, pc_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst_o=%h, pc_o=%h",
                         expected_inst_o, expected_pc_o);
                $display("  Got:      inst_o=%h, pc_o=%h",
                         inst_o, pc_o);
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
        $dumpvars(0,clk_i, flush_i, inst_i, pc_i, stall_i, inst_o, pc_o);
    end

endmodule
