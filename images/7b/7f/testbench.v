`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [2:0] sel;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        sel = 3'd0;
        data0 = 4'hA; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
        #1;

        check_outputs(12'hA0A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        sel = 3'd1;
        data0 = 4'h0; data1 = 4'h5; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
        #1;

        check_outputs(12'hF5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        sel = 3'd2;
        data0 = 4'h0; data1 = 4'h0; data2 = 4'hF; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
        #1;

        check_outputs(12'hF0F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        sel = 3'd3;
        data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
        #1;

        check_outputs(12'hF0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        sel = 3'd4;
        data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h3; data5 = 4'h0;
        #1;

        check_outputs(12'h303);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        sel = 3'd5;
        data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'hC;
        #1;

        check_outputs(12'hFC3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        sel = 3'd0;
        data0 = 4'hF; data1 = 4'hF; data2 = 4'hF; data3 = 4'hF; data4 = 4'hF; data5 = 4'hF;
        #1;

        check_outputs(12'hF0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        sel = 3'd1;
        data0 = 4'hF; data1 = 4'hF; data2 = 4'hF; data3 = 4'hF; data4 = 4'hF; data5 = 4'hF;
        #1;

        check_outputs(12'hFF0);
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
        input [11:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
