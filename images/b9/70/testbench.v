`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] in;
    reg reset;
    reg select;
    wire [1023:0] out_demux;
    wire [3:0] out_hi;
    wire [3:0] out_lo;

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
        .out_demux(out_demux),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset check", test_num);
            reset = 1;
            in = 16'hFFFF;
            select = 1;
            @(posedge clk);
            #1;
            reset = 0;


            #1;



            check_outputs(1024'h0, 4'hF, 4'hF);
        end
        endtask

    task testcase002;

        reg [1023:0] exp_demux;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Index < 128 (Demux Mode)", test_num);
            reset = 1; @(posedge clk); reset = 0;


            in = 16'hA015;
            select = 0;
            @(posedge clk);
            #1;
            exp_demux = 0;
            exp_demux[1*4 +: 4] = 4'hA;

            #1;


            check_outputs(exp_demux, 4'hA, 4'hA);
        end
        endtask

    task testcase003;

        reg [1023:0] exp_demux;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Index >= 128, Select Lo Nibble", test_num);
            reset = 1; @(posedge clk); reset = 0;


            in = 16'hB803;
            select = 0;
            @(posedge clk);
            #1;
            exp_demux = 0;
            exp_demux[128*4 +: 4] = 4'hB;

            #1;


            check_outputs(exp_demux, 4'h3, 4'h3);
        end
        endtask

    task testcase004;

        reg [1023:0] exp_demux;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Index >= 128, Select Hi Nibble", test_num);
            reset = 1; @(posedge clk); reset = 0;


            in = 16'hCFF7;
            select = 1;
            @(posedge clk);
            #1;
            exp_demux = 0;
            exp_demux[255*4 +: 4] = 4'hC;

            #1;


            check_outputs(exp_demux, 4'hC, 4'hC);
        end
        endtask

    task testcase005;

        reg [1023:0] exp_demux;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Persistence Check", test_num);
            reset = 1; @(posedge clk); reset = 0;


            in = 16'h1000; @(posedge clk);

            in = 16'h77F0; @(posedge clk);

            in = 16'hEFF0; select = 1; @(posedge clk);

            #1;
            exp_demux = 0;
            exp_demux[0*4 +: 4] = 4'h1;
            exp_demux[127*4 +: 4] = 4'h7;
            exp_demux[255*4 +: 4] = 4'hE;


            #1;



            check_outputs(exp_demux, 4'hE, 4'hE);
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
        input [1023:0] expected_out_demux;
        input [3:0] expected_out_hi;
        input [3:0] expected_out_lo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_demux === (expected_out_demux ^ out_demux ^ expected_out_demux) &&
                expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: out_demux=%h, out_hi=%h, out_lo=%h",
                         out_demux, out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_demux=%h, out_hi=%h, out_lo=%h",
                         expected_out_demux, expected_out_hi, expected_out_lo);
                $display("  Got:      out_demux=%h, out_hi=%h, out_lo=%h",
                         out_demux, out_hi, out_lo);
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

endmodule
