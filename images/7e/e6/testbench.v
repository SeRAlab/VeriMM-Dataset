`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [31:0] i_data;
    reg i_reset;
    wire o_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_data(i_data),
        .i_reset(i_reset),
        .o_error(o_error)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_reset = 1;
            i_data = 32'h0;
            @(posedge i_clk);
            #1;
            i_reset = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-on Reset check", test_num);
            reset_dut();
            i_data = 32'hA5A5A5A5;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Detect all-X data", test_num);
            reset_dut();
            i_data = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Mixed data (some X, some 0)", test_num);
            reset_dut();
            i_data = 32'hFFFF_000x;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Error latching (sticky bit)", test_num);
            reset_dut();

            i_data = 32'bx;
            @(posedge i_clk);
            #1;

            i_data = 32'h12345678;
            @(posedge i_clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset clearing latched error", test_num);
            reset_dut();

            i_data = 32'bx;
            @(posedge i_clk);
            #1;

            i_reset = 1;
            @(posedge i_clk);
            #1;
            i_reset = 0;
            i_data = 32'h0;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All zeros data", test_num);
            reset_dut();
            i_data = 32'h00000000;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: All ones data", test_num);
            reset_dut();
            i_data = 32'hFFFFFFFF;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        testcase007();
        
        
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
        input expected_o_error;
        begin
            if (expected_o_error === (expected_o_error ^ o_error ^ expected_o_error)) begin
                $display("PASS");
                $display("  Outputs: o_error=%b",
                         o_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_error=%b",
                         expected_o_error);
                $display("  Got:      o_error=%b",
                         o_error);
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
        $dumpvars(0,i_clk, i_data, i_reset, o_error);
    end

endmodule
