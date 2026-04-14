`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ce;
    reg clk;
    reg clr;
    reg [7:0] d0;
    reg [7:0] d1;
    reg [7:0] d2;
    reg [7:0] d3;
    reg [7:0] d4;
    reg [7:0] d5;
    reg [7:0] d6;
    reg [7:0] d7;
    reg [2:0] sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .d4(d4),
        .d5(d5),
        .d6(d6),
        .d7(d7),
        .sel(sel),
        .y(y)
    );
    task initialize_inputs;

    begin
        clk = 0;
        ce = 0;
        clr = 0;
        sel = 0;
        d0 = 0; d1 = 0; d2 = 0; d3 = 0;
        d4 = 0; d5 = 0; d6 = 0; d7 = 0;
    end
        endtask

    task clock_pulse;

    begin
        #5 clk = 1;
        #5 clk = 0;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select d0", test_num);
        initialize_inputs();

        clr = 1; clock_pulse(); clr = 0;

        ce = 1; sel = 3'd0; d0 = 8'hA0;
        clock_pulse();
        #1;

        check_outputs(8'hA0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select d1", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;
        ce = 1; sel = 3'd1; d1 = 8'hB1;
        clock_pulse();
        #1;

        check_outputs(8'hB1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select d2", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;
        ce = 1; sel = 3'd2; d2 = 8'hC2;
        clock_pulse();
        #1;

        check_outputs(8'hC2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select d3", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;
        ce = 1; sel = 3'd3; d3 = 8'hD3;
        clock_pulse();
        #1;

        check_outputs(8'hD3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select d4", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;
        ce = 1; sel = 3'd4; d4 = 8'hE4;
        clock_pulse();
        #1;

        check_outputs(8'hE4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select d5", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;
        ce = 1; sel = 3'd5; d5 = 8'hF5;
        clock_pulse();
        #1;

        check_outputs(8'hF5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select d6", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;
        ce = 1; sel = 3'd6; d6 = 8'h06;
        clock_pulse();
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Select d7", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;
        ce = 1; sel = 3'd7; d7 = 8'h17;
        clock_pulse();
        #1;

        check_outputs(8'h17);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Verify Clock Enable", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;


        ce = 1; sel = 3'd0; d0 = 8'hA0;
        clock_pulse();


        ce = 0; d0 = 8'hFF;
        clock_pulse();


        #1;



        check_outputs(8'hA0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Verify Clear Priority", test_num);
        initialize_inputs();
        clr = 1; clock_pulse(); clr = 0;


        ce = 1; sel = 3'd1; d1 = 8'hB1;
        clock_pulse();


        clr = 1;
        clock_pulse();


        #1;



        check_outputs(8'h00);
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
