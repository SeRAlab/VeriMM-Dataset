`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [1:0] sel;
    wire [15:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .sel(sel),
        .res(res)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'h000A;
            b = 16'h0014;
            c = 16'h0064;
            sel = 2'b00;
            #1;

            check_outputs(16'h001E);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'h000A;
            b = 16'h0014;
            c = 16'h0064;
            sel = 2'b01;
            #1;

            check_outputs(16'h006E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'h0064;
            b = 16'h0014;
            c = 16'h0001;
            sel = 2'b10;
            #1;

            check_outputs(16'h0050);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'hFFFF;
            b = 16'h0001;
            c = 16'h0000;
            sel = 2'b00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'h0000;
            b = 16'h0001;
            c = 16'h0000;
            sel = 2'b10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'h1234;
            b = 16'h0000;
            c = 16'hEDCB;
            sel = 2'b01;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
