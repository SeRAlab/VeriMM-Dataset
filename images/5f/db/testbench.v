`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg s;
    reg [1:0] x;
    reg [1:0] y;
    wire [1:0] m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .x(x),
        .y(y),
        .m(m)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select X (s=0), X=2'b00, Y=2'b11", test_num);
            x = 2'b00;
            y = 2'b11;
            s = 1'b0;
            #5;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select X (s=0), X=2'b01, Y=2'b10", test_num);
            x = 2'b01;
            y = 2'b10;
            s = 1'b0;
            #5;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select X (s=0), X=2'b10, Y=2'b01", test_num);
            x = 2'b10;
            y = 2'b01;
            s = 1'b0;
            #5;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select X (s=0), X=2'b11, Y=2'b00", test_num);
            x = 2'b11;
            y = 2'b00;
            s = 1'b0;
            #5;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select Y (s=1), X=2'b11, Y=2'b00", test_num);
            x = 2'b11;
            y = 2'b00;
            s = 1'b1;
            #5;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select Y (s=1), X=2'b10, Y=2'b01", test_num);
            x = 2'b10;
            y = 2'b01;
            s = 1'b1;
            #5;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select Y (s=1), X=2'b01, Y=2'b10", test_num);
            x = 2'b01;
            y = 2'b10;
            s = 1'b1;
            #5;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select Y (s=1), X=2'b00, Y=2'b11", test_num);
            x = 2'b00;
            y = 2'b11;
            s = 1'b1;
            #5;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Change select signal from 0 to 1 with fixed inputs", test_num);
            x = 2'b01;
            y = 2'b11;
            s = 1'b0;
            #5;
            s = 1'b1;
            #5;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Change input X while s=0", test_num);
            s = 1'b0;
            x = 2'b00;
            y = 2'b11;
            #5;
            x = 2'b10;
            #5;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: m=%h",
                         m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%h",
                         expected_m);
                $display("  Got:      m=%h",
                         m);
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
