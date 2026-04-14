`timescale 1ns/1ps

module concat_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i0;
    reg [7:0] i1;
    reg [7:0] i2;
    reg [7:0] i3;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    concat_module dut (
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            i3 = 8'h00;
            i2 = 8'h00;
            i1 = 8'h00;
            i0 = 8'h00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones", test_num);
            i3 = 8'hFF;
            i2 = 8'hFF;
            i1 = 8'hFF;
            i0 = 8'hFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Incremental Values", test_num);
            i3 = 8'h12;
            i2 = 8'h34;
            i1 = 8'h56;
            i0 = 8'h78;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Alternating Bit Patterns", test_num);
            i3 = 8'hAA;
            i2 = 8'h55;
            i1 = 8'hAA;
            i0 = 8'h55;
            #1;

            check_outputs(32'hAA55AA55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Distinct Hex Values (DEADBEEF)", test_num);
            i3 = 8'hDE;
            i2 = 8'hAD;
            i1 = 8'hBE;
            i0 = 8'hEF;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Power of Two Alignment", test_num);
            i3 = 8'h80;
            i2 = 8'h40;
            i1 = 8'h20;
            i0 = 8'h10;
            #1;

            check_outputs(32'h80402010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Single Bit Shift", test_num);
            i3 = 8'h01;
            i2 = 8'h02;
            i1 = 8'h04;
            i0 = 8'h08;
            #1;

            check_outputs(32'h01020408);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("concat_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_o;
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
