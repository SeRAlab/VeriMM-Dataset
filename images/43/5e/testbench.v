`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] v_addr;
    reg v_en;
    wire [7:0] v_data;
    wire v_rdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .v_addr(v_addr),
        .v_en(v_en),
        .v_data(v_data),
        .v_rdy(v_rdy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            v_en = 0;
            v_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase001: Read Address 0x000");
            reset_dut();
            v_addr = 11'h000;
            v_en = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase002: Read Address 0x05A");
            reset_dut();
            v_addr = 11'h05A;
            v_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase003: Check Disable (v_en=0)");
            reset_dut();
            v_addr = 11'h022;
            v_en = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(v_data, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase004: Read Max Address 0x7FF");
            reset_dut();
            v_addr = 11'h7FF;
            v_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase005: Address Transition 0x01 -> 0x02");
            reset_dut();

            v_addr = 11'h001;
            v_en = 1;
            @(posedge clk);
            #1;

            v_addr = 11'h002;
            v_en = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h02, 1'b1);
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
        input [7:0] expected_v_data;
        input expected_v_rdy;
        begin
            if (expected_v_data === (expected_v_data ^ v_data ^ expected_v_data) &&
                expected_v_rdy === (expected_v_rdy ^ v_rdy ^ expected_v_rdy)) begin
                $display("PASS");
                $display("  Outputs: v_data=%h, v_rdy=%b",
                         v_data, v_rdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_data=%h, v_rdy=%b",
                         expected_v_data, expected_v_rdy);
                $display("  Got:      v_data=%h, v_rdy=%b",
                         v_data, v_rdy);
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
        $dumpvars(0,clk, v_addr, v_en, v_data, v_rdy);
    end

endmodule
