`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] ra;
    reg [3:0] wa;
    reg [7:0] wd;
    reg we;
    wire [3:0] out;
    wire [7:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra(ra),
        .wa(wa),
        .wd(wd),
        .we(we),
        .out(out),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            wa = 0;
            wd = 0;
            ra = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            we = 1; wa = 4'h4; wd = 8'hA5;
            @(posedge clk);
            #1;
            we = 0;
            ra = 4'h4;
            #2;
            #1;

            check_outputs(4'h4, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            we = 0; wa = 4'h7; wd = 8'hFF;
            @(posedge clk);
            #1;
            ra = 4'h7;
            #2;

            if (rd !== 8'hFF) begin
                #1;

                check_outputs(4'h7, rd);
            end else begin
                $display("FAIL: Write occurred while WE was low");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            we = 1; wa = 4'hA; wd = 8'h12;
            @(posedge clk);
            #1;

            wa = 4'hA; wd = 8'h34;
            @(posedge clk);
            #1;
            we = 0;
            ra = 4'hA;
            #2;
            #1;

            check_outputs(4'hA, 8'h34);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            we = 1; wa = 4'h0; wd = 8'hAA;
            @(posedge clk);
            #1;

            wa = 4'hF; wd = 8'h55;
            @(posedge clk);
            #1;
            we = 0;
            ra = 4'hF;
            #2;
            #1;

            check_outputs(4'hF, 8'h55);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            ra = 4'hC;
            #2;

            #1;


            check_outputs(4'hC, rd);
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
        input [3:0] expected_out;
        input [7:0] expected_rd;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: out=%h, rd=%h",
                         out, rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, rd=%h",
                         expected_out, expected_rd);
                $display("  Got:      out=%h, rd=%h",
                         out, rd);
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
        $dumpvars(0,clk, ra, wa, wd, we, out, rd);
    end

endmodule
