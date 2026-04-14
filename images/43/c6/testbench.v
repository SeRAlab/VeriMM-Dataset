`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] addr;
    wire [15:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .data(data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Address 0", test_num);
            addr = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Address 255 (Maximum Address)", test_num);
            addr = 8'd255;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Address 128 (Middle Point)", test_num);
            addr = 8'd128;
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Address 42 (Arbitrary value)", test_num);
            addr = 8'd42;
            #1;

            check_outputs(16'd42);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Address 170 (AA pattern)", test_num);
            addr = 8'hAA;
            #1;

            check_outputs(16'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Address 85 (55 pattern)", test_num);
            addr = 8'h55;
            #1;

            check_outputs(16'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Address 1", test_num);
            addr = 8'd1;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Address 254", test_num);
            addr = 8'd254;
            #1;

            check_outputs(16'd254);
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
        input [15:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
