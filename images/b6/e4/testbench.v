`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_d;
    reg i_load;
    reg i_right;
    reg [4:0] i_shamt;
    reg i_shamt_msb;
    reg i_signbit;
    wire o_done;
    wire o_q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_d(i_d),
        .i_load(i_load),
        .i_right(i_right),
        .i_shamt(i_shamt),
        .i_shamt_msb(i_shamt_msb),
        .i_signbit(i_signbit),
        .o_done(o_done),
        .o_q(o_q)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_load      = 1'b0;
            i_d         = 1'b0;
            i_shamt     = 5'b0;
            i_shamt_msb = 1'b0;
            i_signbit   = 1'b0;
            i_right     = 1'b0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Logical Right Shift (Amt=4)");
            reset_dut();
            @(negedge i_clk);
            i_load      = 1'b1;
            i_shamt     = 5'd4;
            i_shamt_msb = 1'b0;
            i_right     = 1'b1;
            i_signbit   = 1'b0;
            i_d         = 1'b1;
            @(negedge i_clk);
            i_load      = 1'b0;


            repeat(10) begin
                if (o_done) break;
                @(posedge i_clk);
            end

            #1;


            check_outputs(1'b1, o_q);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Logical Left Shift (Amt=2)");
            reset_dut();
            @(negedge i_clk);
            i_load      = 1'b1;
            i_shamt     = 5'd2;
            i_shamt_msb = 1'b0;
            i_right     = 1'b0;
            i_signbit   = 1'b0;
            @(negedge i_clk);
            i_load      = 1'b0;

            repeat(10) begin
                if (o_done) break;
                @(posedge i_clk);
            end

            #1;


            check_outputs(1'b1, o_q);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Arithmetic Right Shift (Sign=1, Amt=5)");
            reset_dut();
            @(negedge i_clk);
            i_load      = 1'b1;
            i_shamt     = 5'd5;
            i_shamt_msb = 1'b0;
            i_right     = 1'b1;
            i_signbit   = 1'b1;
            @(negedge i_clk);
            i_load      = 1'b0;

            repeat(15) begin
                if (o_done) break;
                @(posedge i_clk);
            end

            #1;


            check_outputs(1'b1, o_q);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Arithmetic Right Shift (Sign=0, Amt=3)");
            reset_dut();
            @(negedge i_clk);
            i_load      = 1'b1;
            i_shamt     = 5'd3;
            i_shamt_msb = 1'b0;
            i_right     = 1'b1;
            i_signbit   = 1'b0;
            @(negedge i_clk);
            i_load      = 1'b0;

            repeat(10) begin
                if (o_done) break;
                @(posedge i_clk);
            end

            #1;


            check_outputs(1'b1, o_q);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Large Shift (Amt=32)");
            reset_dut();
            @(negedge i_clk);
            i_load      = 1'b1;
            i_shamt     = 5'd0;
            i_shamt_msb = 1'b1;
            i_right     = 1'b1;
            @(negedge i_clk);
            i_load      = 1'b0;

            repeat(40) begin
                if (o_done) break;
                @(posedge i_clk);
            end

            #1;


            check_outputs(1'b1, o_q);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Zero Shift");
            reset_dut();
            @(negedge i_clk);
            i_load      = 1'b1;
            i_shamt     = 5'd0;
            i_shamt_msb = 1'b0;
            @(negedge i_clk);
            i_load      = 1'b0;

            repeat(5) begin
                if (o_done) break;
                @(posedge i_clk);
            end

            #1;


            check_outputs(1'b1, o_q);
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
        input expected_o_done;
        input expected_o_q;
        begin
            if (expected_o_done === (expected_o_done ^ o_done ^ expected_o_done) &&
                expected_o_q === (expected_o_q ^ o_q ^ expected_o_q)) begin
                $display("PASS");
                $display("  Outputs: o_done=%b, o_q=%b",
                         o_done, o_q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_done=%b, o_q=%b",
                         expected_o_done, expected_o_q);
                $display("  Got:      o_done=%b, o_q=%b",
                         o_done, o_q);
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
        $dumpvars(0,i_clk, i_d, i_load, i_right, i_shamt, i_shamt_msb, i_signbit, o_done, o_q);
    end

endmodule
