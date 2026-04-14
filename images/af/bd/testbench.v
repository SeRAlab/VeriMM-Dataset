`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [3:0] data_i;
    reg [1:0] dest_r_i;
    reg reset_i;
    reg [3:0] src_r_i;
    wire [3:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .data_i(data_i),
        .dest_r_i(dest_r_i),
        .reset_i(reset_i),
        .src_r_i(src_r_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_i = 1;
            data_i = 4'b0000;
            src_r_i = 4'b0000;
            dest_r_i = 2'b00;
            @(posedge clk_i);
            #1;
            reset_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single source barrier", test_num);
            reset_dut();
            src_r_i = 4'b0001;
            data_i  = 4'b0001;
            dest_r_i = 2'b00;
            @(posedge clk_i);
            #1;


            #1;



            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-source barrier (Partial)", test_num);
            reset_dut();
            src_r_i = 4'b0011;
            data_i  = 4'b0001;
            dest_r_i = 2'b01;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-source barrier (Complete)", test_num);
            reset_dut();
            src_r_i = 4'b0011;
            data_i  = 4'b0011;
            dest_r_i = 2'b01;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full broadcast synchronization", test_num);
            reset_dut();
            src_r_i = 4'b1111;
            data_i  = 4'b1111;
            dest_r_i = 2'b11;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Destination routing check", test_num);
            reset_dut();
            src_r_i = 4'b0101;
            data_i  = 4'b0101;
            dest_r_i = 2'b10;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(4'b0100);
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
        input [3:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,clk_i, data_i, dest_r_i, reset_i, src_r_i, data_o);
    end

endmodule
