`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] data_in;
    reg [3:0] n;
    wire [10:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .n(n),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No rotation (n=0)", test_num);
            data_in = 11'h401;
            n = 4'b0000;
            #1;

            check_outputs(11'h401);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Right rotation by 1 (n=1)", test_num);
            data_in = 11'h001;
            n = 4'b0001;
            #1;

            check_outputs(11'h400);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Right rotation by 2 (n=2)", test_num);
            data_in = 11'h001;
            n = 4'b0010;
            #1;

            check_outputs(11'h200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Right rotation by 4 (n=4)", test_num);
            data_in = 11'h001;
            n = 4'b0100;
            #1;

            check_outputs(11'h080);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Right rotation by 8 (n=8)", test_num);
            data_in = 11'h001;
            n = 4'b1000;
            #1;

            check_outputs(11'h008);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Combined rotation (n=15 -> Right 4)", test_num);
            data_in = 11'h001;
            n = 4'b1111;
            #1;

            check_outputs(11'h080);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple bits Right rotate 3 (n=3)", test_num);
            data_in = 11'h007;
            n = 4'b0011;
            #1;

            check_outputs(11'h700);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rotation by width (n=11)", test_num);
            data_in = 11'h555;
            n = 4'b1011;
            #1;

            check_outputs(11'h555);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Right rotate 10 (Left 1)", test_num);
            data_in = 11'h001;
            n = 4'b1010;
            #1;

            check_outputs(11'h002);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones pattern", test_num);
            data_in = 11'h7FF;
            n = 4'b0101;
            #1;

            check_outputs(11'h7FF);
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
        input [10:0] expected_data_out;
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
