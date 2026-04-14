`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [3:0] din;
    reg ld;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .din(din),
        .ld(ld),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 0;
            din = 4'b0000;
            ld = 0;
            #15;
            clr = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            din = 4'b1010;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            din = 4'b0101;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clk);
            din = 4'b1111;
            ld = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            ld = 0;
            din = 4'b0000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            din = 4'b1011;
            ld = 1;
            @(posedge clk);
            #2;

            clr = 0;
            #1;
            #1;

            check_outputs(4'b0000);
            clr = 1;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            din = 4'b1000;
            ld = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            ld = 0;
            din = 4'b0001; #10;
            din = 4'b0010; #10;
            din = 4'b0100; #10;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            @(negedge clk);
            din = 4'b1111;
            ld = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            din = 4'b0000;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(negedge clk);
            ld = 1;
            din = 4'h1; @(posedge clk); #2;
            din = 4'h2; @(posedge clk); #2;
            din = 4'h4; @(posedge clk); #2;
            din = 4'h8; @(posedge clk); #2;
            #1;

            check_outputs(4'h8);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, clr, din, ld, q);
    end

endmodule
