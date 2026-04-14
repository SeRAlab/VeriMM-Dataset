`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cs;
    reg data_in;
    reg rst;
    reg sclk;
    reg sda;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cs(cs),
        .data_in(data_in),
        .rst(rst),
        .sclk(sclk),
        .sda(sda),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        sclk = 0;
        forever #5 sclk = ~sclk;
    end

        task reset_dut;

        begin
            rst = 1;
            cs = 0;
            data_in = 0;
            sda = 0;
            repeat(2) @(negedge sclk);
            rst = 0;
            @(negedge sclk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] send_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 8'hA5 via data_in (CS=0)", test_num);
            reset_dut();
            send_val = 8'hA5;
            cs = 0;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = send_val[7-i];
                @(negedge sclk);
            end

            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] send_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 8'h3C via sda (CS=1)", test_num);
            reset_dut();
            send_val = 8'h3C;
            cs = 1;
            for (i = 0; i < 8; i = i + 1) begin
                sda = send_val[7-i];
                @(negedge sclk);
            end
            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset functionality", test_num);
            reset_dut();

            cs = 0;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = 1;
                @(negedge sclk);
            end
            #1;

            rst = 1;
            repeat(2) @(negedge sclk);
            rst = 0;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset mid-transmission", test_num);
            reset_dut();
            cs = 1;

            for (i = 0; i < 4; i = i + 1) begin
                sda = 1;
                @(negedge sclk);
            end

            rst = 1;
            @(negedge sclk);
            rst = 0;

            for (i = 0; i < 4; i = i + 1) begin
                sda = 1;
                @(negedge sclk);
            end
            #1;




            if (data_out != 8'hFF) begin
                $display("PASS: Mid-transmission reset prevented full data capture");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Mid-transmission reset ignored");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting all zeros", test_num);
            reset_dut();
            cs = 0;
            data_in = 0;
            repeat(8) @(negedge sclk);
            #1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,cs, data_in, rst, sclk, sda, data_out);
    end

endmodule
