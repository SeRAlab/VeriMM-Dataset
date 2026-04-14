`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] i0;
    reg [2:0] i1;
    reg [2:0] i2;
    reg [2:0] i3;
    reg [2:0] i4;
    reg [1:0] sel;
    wire [2:0] o;

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
        .sel(sel),
        .o(o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting i0 (sel=00)", test_num);
            i0 = 3'd1; i1 = 3'd2; i2 = 3'd3; i3 = 3'd4; i4 = 3'd5;
            sel = 2'b00;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting i1 (sel=01)", test_num);
            i0 = 3'd1; i1 = 3'd2; i2 = 3'd3; i3 = 3'd4; i4 = 3'd5;
            sel = 2'b01;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting i2 (sel=10)", test_num);
            i0 = 3'd1; i1 = 3'd2; i2 = 3'd3; i3 = 3'd4; i4 = 3'd5;
            sel = 2'b10;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting i3 (sel=11)", test_num);
            i0 = 3'd1; i1 = 3'd2; i2 = 3'd3; i3 = 3'd4; i4 = 3'd5;
            sel = 2'b11;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying i2 with unique data (Addressing '2' double-entry error)", test_num);
            i0 = 3'b000; i1 = 3'b000; i2 = 3'b101; i3 = 3'b010; i4 = 3'b000;
            sel = 2'd2;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying i3 with unique data (Addressing '2' double-entry error)", test_num);
            i0 = 3'b111; i1 = 3'b111; i2 = 3'b000; i3 = 3'b110; i4 = 3'b111;
            sel = 2'd3;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting i0 and changing other inputs (Isolation Check)", test_num);
            i0 = 3'd5; i1 = 3'd0; i2 = 3'd0; i3 = 3'd0; i4 = 3'd0;
            sel = 2'b00;
            #1;
            i1 = 3'd7; i2 = 3'd7; i3 = 3'd7; i4 = 3'd7;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs same value", test_num);
            i0 = 3'd4; i1 = 3'd4; i2 = 3'd4; i3 = 3'd4; i4 = 3'd4;
            sel = 2'b01;
            #1;

            check_outputs(3'd4);
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
        input [2:0] expected_o;
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
