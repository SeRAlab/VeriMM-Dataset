`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [7:0] data;
    wire [15:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data(data),
        .display(display)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ctrl 00 - Data at start", test_num);
            ctrl = 2'b00;
            data = 8'hA5;
            #1;

            check_outputs(16'hA500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ctrl 01 - Data at end", test_num);
            ctrl = 2'b01;
            data = 8'h5A;
            #1;

            check_outputs(16'h005A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ctrl 10 - Data in center", test_num);
            ctrl = 2'b10;
            data = 8'hFF;

            #1;


            check_outputs(16'h0FF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ctrl 11 - Clear display", test_num);
            ctrl = 2'b11;
            data = 8'hFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ctrl 00 - Max data at start", test_num);
            ctrl = 2'b00;
            data = 8'hFF;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ctrl 01 - Min data at end", test_num);
            ctrl = 2'b01;
            data = 8'h01;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ctrl 10 - Pattern in center", test_num);
            ctrl = 2'b10;
            data = 8'h3C;

            #1;


            check_outputs(16'h03C0);
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
        input [15:0] expected_display;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: display=%h",
                         display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h",
                         expected_display);
                $display("  Got:      display=%h",
                         display);
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
