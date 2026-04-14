`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] inp_data;
    reg inp_valid;
    reg rstb;
    wire [3:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inp_data(inp_data),
        .inp_valid(inp_valid),
        .rstb(rstb),
        .out_data(out_data),
        .out_valid(out_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset State Verification", test_num);

            rstb = 0;
            inp_valid = 0;
            inp_data = 4'hF;
            #15;

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Valid Data (4'hA)", test_num);
            reset_dut();

            @(posedge clk);
            inp_valid = 1;
            inp_data = 4'hA;

            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Valid Data (4'h5)", test_num);
            reset_dut();

            @(posedge clk);
            inp_valid = 1;
            inp_data = 4'h5;

            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Invalid Input Handling", test_num);
            reset_dut();

            @(posedge clk);
            inp_valid = 0;
            inp_data = 4'hE;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive Data Burst", test_num);
            reset_dut();

            @(posedge clk);
            inp_valid = 1;
            inp_data = 4'h1;
            @(posedge clk);
            inp_data = 4'h2;
            @(posedge clk);
            inp_data = 4'h3;
            @(posedge clk);
            inp_valid = 0;

            #2;

            #1;


            check_outputs(4'h3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Mid-Operation", test_num);
            reset_dut();

            @(posedge clk);
            inp_valid = 1;
            inp_data = 4'h7;
            @(posedge clk);

            rstb = 0;
            #2;
            #1;

            check_outputs(4'h0, 1'b0);
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
        input [3:0] expected_out_data;
        input expected_out_valid;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
