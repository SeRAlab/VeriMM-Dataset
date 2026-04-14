`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ABC;
    reg EN;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABC(ABC),
        .EN(EN),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            EN = 1'b0;
            ABC = 3'b000;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            EN = 1'b0;
            ABC = 3'b111;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            EN = 1'b1;
            ABC = 3'b000;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            EN = 1'b1;
            ABC = 3'b001;
            #1;

            check_outputs(8'b0000_0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            EN = 1'b1;
            ABC = 3'b010;
            #1;

            check_outputs(8'b0000_0100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            EN = 1'b1;
            ABC = 3'b011;
            #1;

            check_outputs(8'b0000_1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            EN = 1'b1;
            ABC = 3'b100;
            #1;

            check_outputs(8'b0001_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            EN = 1'b1;
            ABC = 3'b101;
            #1;

            check_outputs(8'b0010_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            EN = 1'b1;
            ABC = 3'b110;
            #1;

            check_outputs(8'b0100_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            EN = 1'b1;
            ABC = 3'b111;
            #1;

            check_outputs(8'b1000_0000);
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
