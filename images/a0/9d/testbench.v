`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg reset;
    reg [2:0] sel;
    wire [7:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .reset(reset),
        .sel(sel),
        .final_output(final_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data0 = 0; data1 = 0; data2 = 0;
            data3 = 0; data4 = 0; data5 = 0;
            sel = 0;
            @(negedge clk);
            #1 reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset behavior and initial mux addition", test_num);
            reset_dut();
            data0 = 4'h5;
            sel = 3'd0;
            #2;

            #1;


            check_outputs(8'h05);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single shift on negedge", test_num);
            reset_dut();
            data1 = 4'hA;
            sel = 3'd1;
            @(negedge clk);
            #1;
            data1 = 4'h2;
            #2;

            #1;


            check_outputs(8'h0C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Double shift and mux addition", test_num);
            reset_dut();

            data0 = 4'h1; sel = 3'd0;
            @(negedge clk);
            #1;

            data2 = 4'h2; sel = 3'd2;
            @(negedge clk);
            #1;

            data3 = 4'h3; sel = 3'd3;
            #2;

            #1;


            check_outputs(8'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mux selection logic (lines 3, 4, 5)", test_num);
            reset_dut();

            data3 = 4'h7; sel = 3'd3;
            @(negedge clk);
            #1;

            data4 = 4'h8; sel = 3'd4;
            @(negedge clk);
            #1;

            data5 = 4'h9; sel = 3'd5;
            #2;

            #1;


            check_outputs(8'h81);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 8-bit addition wrap-around", test_num);
            reset_dut();

            data0 = 4'hF; sel = 3'd0;
            @(negedge clk);
            @(negedge clk);
            #1;

            data1 = 4'h1; sel = 3'd1;
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous reset clearing shift register", test_num);
            reset_dut();

            data0 = 4'hF; sel = 3'd0;
            @(negedge clk);
            #1;
            reset = 1;
            @(negedge clk);
            #1;
            reset = 0;
            data0 = 4'h5;
            #2;

            #1;


            check_outputs(8'h05);
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
        input [7:0] expected_final_output;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h",
                         final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h",
                         expected_final_output);
                $display("  Got:      final_output=%h",
                         final_output);
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
        $dumpvars(0,clk, data0, data1, data2, data3, data4, data5, reset, sel, final_output);
    end

endmodule
