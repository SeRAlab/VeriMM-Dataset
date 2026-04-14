`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [2:0] sel;
    wire flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .sel(sel),
        .flag(flag)
    );
    task reset_signals;

    begin
        a = 4'd0;
        b = 4'd0;
        sel = 3'd0;
        data0 = 4'd0;
        data1 = 4'd0;
        data2 = 4'd0;
        data3 = 4'd0;
        data4 = 4'd0;
        data5 = 4'd0;
        @(posedge clk);
        #1;
    end
    endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        reset_signals();

        a = 4'd10;
        b = 4'd5;

        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_signals();

        a = 4'd3;
        b = 4'd7;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_signals();

        a = 4'd8;
        b = 4'd8;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_signals();

        sel = 3'd0;
        data0 = 4'd2;
        a = 4'd6;
        b = 4'd2;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_signals();

        sel = 3'd1;
        data1 = 4'd12;
        a = 4'd4;
        b = 4'd12;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_signals();

        sel = 3'd5;
        data5 = 4'd1;
        a = 4'd15;
        b = 4'd1;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_signals();

        a = 4'd15;
        b = 4'd14;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_signals();

        a = 4'd0;
        b = 4'd1;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        reset_signals();

        sel = 3'd4;
        data4 = 4'd9;
        a = 4'd9;
        b = 4'd9;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        reset_signals();


        a = 4'd5; b = 4'd2;
        @(posedge clk);

        a = 4'd1; b = 4'd10;

        #1;
        if (flag === 1'b1) begin
            $display("Synchronous Check Part A: PASS");
        end else begin
            $display("Synchronous Check Part A: FAIL (Flag updated too early)");
        end


        @(posedge clk);
        #1;

        check_outputs(1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flag === (expected_flag ^ flag ^ expected_flag)) begin
                $display("PASS");
                $display("  Outputs: flag=%b",
                         flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag=%b",
                         expected_flag);
                $display("  Got:      flag=%b",
                         flag);
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
