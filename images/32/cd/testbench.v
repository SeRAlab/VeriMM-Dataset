`timescale 1ns/1ps

module adc_interface_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] data_in;
    reg enable;
    wire [23:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_interface dut (
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disable output with non-zero data", test_num);
            enable = 1'b0;
            data_in = 24'hABCDEF;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable output with positive value", test_num);
            enable = 1'b1;
            data_in = 24'h123456;
            #1;

            check_outputs(24'h123456);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable output with all bits high", test_num);
            enable = 1'b1;
            data_in = 24'hFFFFFF;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disable output with all bits high", test_num);
            enable = 1'b0;
            data_in = 24'hFFFFFF;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable output with zero data", test_num);
            enable = 1'b1;
            data_in = 24'h000000;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable output with alternating bits (pattern A)", test_num);
            enable = 1'b1;
            data_in = 24'hAAAAAA;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable output with alternating bits (pattern 5)", test_num);
            enable = 1'b1;
            data_in = 24'h555555;
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition from Enable to Disable", test_num);
            data_in = 24'hDEADC0;
            enable = 1'b1;
            #5;
            enable = 1'b0;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_interface Testbench");
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
        input [23:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
