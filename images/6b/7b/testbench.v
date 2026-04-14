`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_data;
    reg in_valid;
    reg reset;
    wire [31:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .reset(reset),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            in_valid = 0;
            in_data = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Data Write", test_num);
            reset_dut();

            in_data = 32'hDEADBEEF;
            in_valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Validity De-assertion After Access", test_num);
            reset_dut();


            in_data = 32'h12345678;
            in_valid = 1;
            @(posedge clk);
            #1;


            in_valid = 0;
            @(posedge clk);
            #1;




            #1;





            check_outputs(32'h12345678, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive Writes", test_num);
            reset_dut();


            in_data = 32'hAAAA_AAAA;
            in_valid = 1;
            @(posedge clk);
            #1;


            in_data = 32'hBBBB_BBBB;
            in_valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hBBBB_BBBB, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Ignore when in_valid=0", test_num);
            reset_dut();


            in_data = 32'hCAFE_BABE;
            in_valid = 1;
            @(posedge clk);
            #1;


            in_data = 32'h0000_0000;
            in_valid = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hCAFE_BABE, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Value 0xFFFFFFFF", test_num);
            reset_dut();

            in_data = 32'hFFFF_FFFF;
            in_valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b1);
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
        input [31:0] expected_out_data;
        input expected_out_valid;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, out_valid=%b",
                         out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, out_valid=%b",
                         expected_out_data, expected_out_valid);
                $display("  Got:      out_data=%h, out_valid=%b",
                         out_data, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, reset, out_data, out_valid);
    end

endmodule
