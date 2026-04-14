`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] input_sel;
    reg ld_val;
    reg [7:0] mac0;
    reg [7:0] mac1;
    reg [7:0] mac2;
    reg [7:0] mac3;
    reg [7:0] mac4;
    reg [7:0] mac5;
    reg [7:0] mac6;
    reg [7:0] mac7;
    reg [7:0] mac8;
    reg [7:0] mac9;
    reg t;
    wire [7:0] store_values_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_sel(input_sel),
        .ld_val(ld_val),
        .mac0(mac0),
        .mac1(mac1),
        .mac2(mac2),
        .mac3(mac3),
        .mac4(mac4),
        .mac5(mac5),
        .mac6(mac6),
        .mac7(mac7),
        .mac8(mac8),
        .mac9(mac9),
        .t(t),
        .store_values_out(store_values_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ld_val = 0;
            t = 0;
            input_sel = 0;
            mac0 = 0; mac1 = 0; mac2 = 0; mac3 = 0; mac4 = 0;
            mac5 = 0; mac6 = 0; mac7 = 0; mac8 = 0; mac9 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Load Lower Half (t=0)", test_num);
            reset_dut();


            ld_val = 1;
            t = 0;
            mac0 = 8'h00; mac1 = 8'h11; mac2 = 8'h22; mac3 = 8'h33; mac4 = 8'h44;
            mac5 = 8'h55; mac6 = 8'h66; mac7 = 8'h77; mac8 = 8'h88; mac9 = 8'h99;

            @(posedge clk);
            #2;
            ld_val = 0;


            input_sel = 7;
            #1;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Load Upper Half (t=1)", test_num);
            reset_dut();


            ld_val = 1;
            t = 1;
            mac0 = 8'hAA; mac1 = 8'hAB; mac2 = 8'hAC; mac3 = 8'hAD; mac4 = 8'hAE;
            mac5 = 8'hAF; mac6 = 8'hB0; mac7 = 8'hB1; mac8 = 8'hB2; mac9 = 8'hB3;

            @(posedge clk);
            #2;
            ld_val = 0;


            input_sel = 15;
            #1;
            #1;

            check_outputs(8'hAF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Data Persistence (ld_val=0)", test_num);
            reset_dut();


            ld_val = 1; t = 0; mac2 = 8'h22;
            @(posedge clk);
            #2;


            ld_val = 0; mac2 = 8'hFF;
            @(posedge clk);
            #2;


            input_sel = 2;
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Full Array Verification", test_num);
            reset_dut();


            ld_val = 1; t = 0;
            mac0 = 8'h01; mac9 = 8'h09;
            @(posedge clk); #2;


            ld_val = 1; t = 1;
            mac0 = 8'h10; mac9 = 8'h19;
            @(posedge clk); #2;

            ld_val = 0;


            input_sel = 19;
            #1;
            #1;

            check_outputs(8'h19);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Async Output Selection", test_num);
            reset_dut();


            ld_val = 1; t = 0;
            mac0 = 8'h12; mac1 = 8'h34;
            @(posedge clk); #2;
            ld_val = 0;


            input_sel = 0; #5;
            input_sel = 1; #5;

            #1;


            check_outputs(8'h34);
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
        input [7:0] expected_store_values_out;
        begin
            if (expected_store_values_out === (expected_store_values_out ^ store_values_out ^ expected_store_values_out)) begin
                $display("PASS");
                $display("  Outputs: store_values_out=%h",
                         store_values_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: store_values_out=%h",
                         expected_store_values_out);
                $display("  Got:      store_values_out=%h",
                         store_values_out);
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
        $dumpvars(0,clk, input_sel, ld_val, mac0, mac1, mac2, mac3, mac4, mac5, mac6, mac7, mac8, mac9, t, store_values_out);
    end

endmodule
