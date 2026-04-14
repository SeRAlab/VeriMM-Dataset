`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] in;
    reg vdd18;
    wire [7:0] vrefcode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .vdd18(vdd18),
        .vrefcode(vrefcode)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 7'b0000000;
            vdd18 = 1'b0;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 7'b1111111;
            vdd18 = 1'b1;
            #1;

            check_outputs(8'b11111110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 7'b1010101;
            vdd18 = 1'b1;
            #1;

            check_outputs(8'b10101010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 7'b0101010;
            vdd18 = 1'b0;
            #1;

            check_outputs(8'b01010100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 7'b1100110;
            vdd18 = 1'b1;
            #1;

            check_outputs(8'b11001100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 7'b0011001;
            vdd18 = 1'b0;
            #1;

            check_outputs(8'b00110010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 7'h7F;
            vdd18 = 1'b0;
            #1;

            check_outputs(8'hFE);
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
        input [7:0] expected_vrefcode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vrefcode === (expected_vrefcode ^ vrefcode ^ expected_vrefcode)) begin
                $display("PASS");
                $display("  Outputs: vrefcode=%h",
                         vrefcode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vrefcode=%h",
                         expected_vrefcode);
                $display("  Got:      vrefcode=%h",
                         vrefcode);
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
