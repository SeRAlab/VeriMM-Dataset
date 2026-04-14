`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_a;
    reg [7:0] data_b;
    wire [7:0] data_hi;
    wire [7:0] data_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_a(data_a),
        .data_b(data_b),
        .data_hi(data_hi),
        .data_lo(data_lo)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: data_a > data_b", test_num);
            data_a = 8'hA5;
            data_b = 8'h5A;
            #1;

            check_outputs(8'hA5, 8'h5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: data_a < data_b", test_num);
            data_a = 8'h22;
            data_b = 8'hF0;
            #1;

            check_outputs(8'hF0, 8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: data_a == data_b", test_num);
            data_a = 8'h7F;
            data_b = 8'h7F;
            #1;

            check_outputs(8'h7F, 8'h7F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Extreme values (Max and Min)", test_num);
            data_a = 8'hFF;
            data_b = 8'h00;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Extreme values swapped", test_num);
            data_a = 8'h00;
            data_b = 8'hFF;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Neighboring values (High)", test_num);
            data_a = 8'h80;
            data_b = 8'h7F;
            #1;

            check_outputs(8'h80, 8'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Neighboring values (Low)", test_num);
            data_a = 8'h01;
            data_b = 8'h02;
            #1;

            check_outputs(8'h02, 8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All zeros", test_num);
            data_a = 8'h00;
            data_b = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_data_hi;
        input [7:0] expected_data_lo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_hi === (expected_data_hi ^ data_hi ^ expected_data_hi) &&
                expected_data_lo === (expected_data_lo ^ data_lo ^ expected_data_lo)) begin
                $display("PASS");
                $display("  Outputs: data_hi=%h, data_lo=%h",
                         data_hi, data_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_hi=%h, data_lo=%h",
                         expected_data_hi, expected_data_lo);
                $display("  Got:      data_hi=%h, data_lo=%h",
                         data_hi, data_lo);
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
