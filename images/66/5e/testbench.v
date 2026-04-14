`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0;
    reg [7:0] data1;
    reg sel;
    wire [7:0] bus1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .sel(sel),
        .bus1(bus1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data0 (sel=0)", test_num);
            data0 = 8'hA5;
            data1 = 8'h5A;
            sel = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data1 (sel=1)", test_num);
            data0 = 8'hA5;
            data1 = 8'h5A;
            sel = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data0 with all zeros (sel=0)", test_num);
            data0 = 8'h00;
            data1 = 8'hFF;
            sel = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data1 with all ones (sel=1)", test_num);
            data0 = 8'h00;
            data1 = 8'hFF;
            sel = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data0 with pattern 0xAA (sel=0)", test_num);
            data0 = 8'hAA;
            data1 = 8'h55;
            sel = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data1 with pattern 0x55 (sel=1)", test_num);
            data0 = 8'hAA;
            data1 = 8'h55;
            sel = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Check transparency of data0 (sel=0)", test_num);
            data0 = 8'h12;
            data1 = 8'h34;
            sel = 1'b0;
            #5;
            data0 = 8'h99;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Check transparency of data1 (sel=1)", test_num);
            data0 = 8'hBC;
            data1 = 8'hDE;
            sel = 1'b1;
            #5;
            data1 = 8'hF0;
            #1;

            check_outputs(8'hF0);
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
        input [7:0] expected_bus1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bus1 === (expected_bus1 ^ bus1 ^ expected_bus1)) begin
                $display("PASS");
                $display("  Outputs: bus1=%h",
                         bus1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus1=%h",
                         expected_bus1);
                $display("  Got:      bus1=%h",
                         bus1);
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
