`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] d;
    reg reset;
    reg select;
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
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            d = 12'd10;
            select = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h32);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            d = 12'd200;
            select = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hE8);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            d = 12'd17; select = 0; @(posedge clk);

            d = 12'd2;  select = 1; @(posedge clk);
            #1 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            d = 12'd17; select = 0; @(posedge clk);

            d = 12'd1;  select = 1; @(posedge clk);
            #1 #1;
 check_outputs(8'hAB);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            d = 12'd205; select = 0; @(posedge clk);

            d = 12'd1;   select = 1; @(posedge clk);

            d = 12'd2;   select = 1; @(posedge clk);
            #1 #1;
 check_outputs(8'h06);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            d = 12'hFFF;
            select = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFB);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, reset, select, q);
    end

endmodule
