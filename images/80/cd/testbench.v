`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg select;
    wire out_and;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .select(select),
        .out_and(out_and),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            select = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load (select=0)", test_num);
            reset_dut();
            d = 8'h55; select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority Storage (select=1, M=1)", test_num);
            reset_dut();
            d = 8'h07; select = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'h87);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority Storage (select=1, M=0)", test_num);
            reset_dut();
            d = 8'h81; select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Internal Reset Trigger (M=1 & q[7]=1)", test_num);
            reset_dut();

            d = 8'h80; select = 0;
            @(posedge clk);
            #1;

            d = 8'h07; select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: M=1 but q[7]=0 (No Reset)", test_num);
            reset_dut();
            d = 8'h03; select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h03);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority Truth Table (110)", test_num);
            reset_dut();
            d = 8'h06; select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h86);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority Truth Table (101)", test_num);
            reset_dut();
            d = 8'h05; select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h85);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority Truth Table (100 -> M=0)", test_num);
            reset_dut();
            d = 8'h04; select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h04);
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
        testcase008();
        
        
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
        input expected_out_and;
        input [7:0] expected_q;
        begin
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_and=%b, q=%h",
                         out_and, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%b, q=%h",
                         expected_out_and, expected_q);
                $display("  Got:      out_and=%b, q=%h",
                         out_and, q);
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
        $dumpvars(0,clk, d, reset, select, out_and, q);
    end

endmodule
