`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] data_in;
    reg rst;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive Input (0x000A)", test_num);

        rst = 1;
        data_in = 16'h0000;
        @(posedge clk);


        rst = 0;
        data_in = 16'h000A;
        @(posedge clk);


        #1;
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative Input (0xFFFF = -1)", test_num);

        rst = 1;
        data_in = 16'h0000;
        @(posedge clk);


        rst = 0;
        data_in = 16'hFFFF;
        @(posedge clk);


        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Input", test_num);

        rst = 1;
        @(posedge clk);


        rst = 0;
        data_in = 16'h0000;
        @(posedge clk);


        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive Signed Integer (0x7FFF)", test_num);

        rst = 1;
        @(posedge clk);


        rst = 0;
        data_in = 16'h7FFF;
        @(posedge clk);


        #1;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Negative Signed Integer (0x8000)", test_num);

        rst = 1;
        @(posedge clk);


        rst = 0;
        data_in = 16'h8000;
        @(posedge clk);


        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Behavior Check", test_num);

        rst = 1;
        data_in = 16'h1234;
        @(posedge clk);



        #1;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
