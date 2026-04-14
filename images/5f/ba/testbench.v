`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] data;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .count(count)
    );
    task testcase001;

        begin
            test_num = 1;
            data = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = ~128'h1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 128'h1;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 128'h55555555555555555555555555555555;
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = {{64{1'b1}}, {64{1'b0}}};
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data = ~128'h3FF;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data = {{28{1'b1}}, {100{1'b0}}};
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data = 128'hCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC;
            #1;

            check_outputs(8'd64);
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
        input [7:0] expected_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
