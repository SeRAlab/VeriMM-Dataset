`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i0;
    reg [7:0] i1;
    reg [7:0] i2;
    reg [7:0] i3;
    reg [7:0] i4;
    reg [7:0] i5;
    reg [7:0] i6;
    reg [7:0] i7;
    reg [2:0] sel;
    wire [7:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .i4(i4),
        .i5(i5),
        .i6(i6),
        .i7(i7),
        .sel(sel),
        .o(o)
    );
    task set_distinct_inputs;

        begin
            i0 = 8'h00; i1 = 8'h11; i2 = 8'h22; i3 = 8'h33;
            i4 = 8'h44; i5 = 8'h55; i6 = 8'h66; i7 = 8'h77;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select i0", test_num);
        set_distinct_inputs();
        sel = 3'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select i1", test_num);
        set_distinct_inputs();
        sel = 3'd1;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select i2", test_num);
        set_distinct_inputs();
        sel = 3'd2;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select i3", test_num);
        set_distinct_inputs();
        sel = 3'd3;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select i4", test_num);
        set_distinct_inputs();
        sel = 3'd4;
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select i5", test_num);
        set_distinct_inputs();
        sel = 3'd5;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select i6", test_num);
        set_distinct_inputs();
        sel = 3'd6;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Select i7", test_num);
        set_distinct_inputs();
        sel = 3'd7;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: All inputs same (0xFF)", test_num);
        i0=8'hFF; i1=8'hFF; i2=8'hFF; i3=8'hFF;
        i4=8'hFF; i5=8'hFF; i6=8'hFF; i7=8'hFF;
        sel = 3'd3;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Change input value while selected", test_num);
        set_distinct_inputs();
        sel = 3'd5;
        #5;
        i5 = 8'hA5;
        #1;

        check_outputs(8'hA5);
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
        input [7:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
