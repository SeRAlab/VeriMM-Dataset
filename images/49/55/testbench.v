`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i0;
    reg [7:0] i1;
    reg [7:0] i2;
    reg [7:0] i3;
    reg [7:0] i4;
    wire [31:0] o;

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
        .o(o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            i0 = 32'h00000064;
            i1 = 8'h00; i2 = 8'h00; i3 = 8'h00; i4 = 8'h14;

            #1;


            check_outputs(32'h00000050);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            i0 = 32'h00000014;
            i1 = 8'h00; i2 = 8'h00; i3 = 8'h00; i4 = 8'h64;

            #1;


            check_outputs(32'h00000050);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            i0 = 32'hABCDEFF0;
            i1 = 8'hAB; i2 = 8'hCD; i3 = 8'hEF; i4 = 8'hF0;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            i0 = 32'h00000000;
            i1 = 8'h00; i2 = 8'h00; i3 = 8'h00; i4 = 8'h01;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            i0 = 32'hFFFFFFFF;
            i1 = 8'h00; i2 = 8'h00; i3 = 8'h00; i4 = 8'h00;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            i0 = 32'h80000000;
            i1 = 8'h00; i2 = 8'h00; i3 = 8'h00; i4 = 8'h00;


            #1;



            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            i0 = 32'h00000000;
            i1 = 8'h12; i2 = 8'h34; i3 = 8'h56; i4 = 8'h78;


            #1;



            check_outputs(32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            i0 = 32'h7FFFFFFF;
            i1 = 8'h80; i2 = 8'h00; i3 = 8'h00; i4 = 8'h00;


            #1;



            check_outputs(32'h00000001);
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
