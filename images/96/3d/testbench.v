`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] IN;
    reg MODE;
    reg [1:0] SHIFT;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN(IN),
        .MODE(MODE),
        .SHIFT(SHIFT),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("\nRunning testcase001: Logical Left Shift (MODE=0)");
            MODE = 1'b0;


            IN = 4'b1011; SHIFT = 2'b00;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b1011);


            IN = 4'b1011; SHIFT = 2'b01;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b0110);


            IN = 4'b1011; SHIFT = 2'b10;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b1100);


            IN = 4'b1011; SHIFT = 2'b11;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Right Shift (MODE=1)");
            MODE = 1'b1;


            IN = 4'b1101; SHIFT = 2'b00;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b1101);


            IN = 4'b1101; SHIFT = 2'b01;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b0110);


            IN = 4'b1101; SHIFT = 2'b10;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b0011);


            IN = 4'b1101; SHIFT = 2'b11;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Edge Cases and Patterns");


            IN = 4'b0000; SHIFT = 2'b10; MODE = 1'b0;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b0000);


            IN = 4'b1111; SHIFT = 2'b10; MODE = 1'b0;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b1100);


            IN = 4'b1111; SHIFT = 2'b10; MODE = 1'b1;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b0011);


            IN = 4'b1010; SHIFT = 2'b01; MODE = 1'b0;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b0100);


            IN = 4'b0101; SHIFT = 2'b01; MODE = 1'b1;
            test_num = test_num + 1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Potential Arithmetic Right Check (MODE=1)");
            MODE = 1'b1;




            IN = 4'b1000; SHIFT = 2'b01;
            test_num = test_num + 1;

            $display("Checking for Arithmetic Right extension...");
            #1;

            check_outputs(4'b1100);
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
        input [3:0] expected_Y;
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
