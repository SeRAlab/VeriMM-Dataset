`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DATA;
    reg [1:0] SHIFT;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA(DATA),
        .SHIFT(SHIFT),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            DATA = 4'b1010;
            SHIFT = 2'b00;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            DATA = 4'b1010;
            SHIFT = 2'b01;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            DATA = 4'b1010;
            SHIFT = 2'b10;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            DATA = 4'b1010;
            SHIFT = 2'b11;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            DATA = 4'b0001;
            SHIFT = 2'b01;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            DATA = 4'b0001;
            SHIFT = 2'b10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            DATA = 4'b0001;
            SHIFT = 2'b11;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            DATA = 4'b1111;
            SHIFT = 2'b01;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            DATA = 4'b1111;
            SHIFT = 2'b10;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            DATA = 4'b1111;
            SHIFT = 2'b11;
            #1;

            check_outputs(4'b1000);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
