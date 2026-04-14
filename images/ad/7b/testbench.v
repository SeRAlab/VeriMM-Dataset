`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] mdata0;
    reg [11:0] mdata1;
    reg [11:0] mdata2;
    reg [11:0] mdata3;
    reg [1:0] sel;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mdata0(mdata0),
        .mdata1(mdata1),
        .mdata2(mdata2),
        .mdata3(mdata3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select mdata0", test_num);
            mdata0 = 12'hAAA;
            mdata1 = 12'hBBB;
            mdata2 = 12'hCCC;
            mdata3 = 12'hDDD;
            sel = 2'b00;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select mdata1", test_num);
            mdata0 = 12'hAAA;
            mdata1 = 12'hBBB;
            mdata2 = 12'hCCC;
            mdata3 = 12'hDDD;
            sel = 2'b01;
            #1;

            check_outputs(12'hBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select mdata2", test_num);
            mdata0 = 12'hAAA;
            mdata1 = 12'hBBB;
            mdata2 = 12'hCCC;
            mdata3 = 12'hDDD;
            sel = 2'b10;
            #1;

            check_outputs(12'hCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select mdata3", test_num);
            mdata0 = 12'hAAA;
            mdata1 = 12'hBBB;
            mdata2 = 12'hCCC;
            mdata3 = 12'hDDD;
            sel = 2'b11;
            #1;

            check_outputs(12'hDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All inputs zero, select mdata2", test_num);
            mdata0 = 12'h000;
            mdata1 = 12'h000;
            mdata2 = 12'h000;
            mdata3 = 12'h000;
            sel = 2'b10;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All inputs FFF, select mdata0", test_num);
            mdata0 = 12'hFFF;
            mdata1 = 12'hFFF;
            mdata2 = 12'hFFF;
            mdata3 = 12'hFFF;
            sel = 2'b00;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Unique patterns, select mdata1", test_num);
            mdata0 = 12'h123;
            mdata1 = 12'h456;
            mdata2 = 12'h789;
            mdata3 = 12'hABC;
            sel = 2'b01;
            #1;

            check_outputs(12'h456);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Check sensitivity to input change while selected", test_num);
            mdata3 = 12'h555;
            sel = 2'b11;
            #5;
            mdata3 = 12'hA5A;
            #1;

            check_outputs(12'hA5A);
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
