`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    reg select;
    wire [7:0] anyedge;
    wire [7:0] combined_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .select(select),
        .anyedge(anyedge),
        .combined_out(combined_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            select = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clk);
            #1 #1;
 check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            select = 1;
            in = 8'h00;
            @(posedge clk);
            in = 8'h01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            select = 1;
            in = 8'h0F;
            @(posedge clk);
            in = 8'hFF;
            @(posedge clk);


            #1 #1;
 check_outputs(8'hF0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            select = 1;
            in = 8'hFF;
            @(posedge clk);
            in = 8'h00;
            @(posedge clk);

            #1 #1;
 check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            select = 0;
            in = 8'hA5;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            select = 1;
            in = 8'h55;
            @(posedge clk);
            in = 8'h55;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00, 8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in = 8'h00;
            @(posedge clk);
            in = 8'h80;
            select = 0;
            @(posedge clk);

            #1 #1;
 check_outputs(8'h80, 8'h80);
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
        input [7:0] expected_anyedge;
        input [7:0] expected_combined_out;
        begin
            if (expected_anyedge === (expected_anyedge ^ anyedge ^ expected_anyedge) &&
                expected_combined_out === (expected_combined_out ^ combined_out ^ expected_combined_out)) begin
                $display("PASS");
                $display("  Outputs: anyedge=%h, combined_out=%h",
                         anyedge, combined_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anyedge=%h, combined_out=%h",
                         expected_anyedge, expected_combined_out);
                $display("  Got:      anyedge=%h, combined_out=%h",
                         anyedge, combined_out);
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
        $dumpvars(0,clk, in, reset, select, anyedge, combined_out);
    end

endmodule
