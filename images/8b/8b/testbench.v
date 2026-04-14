`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CTRL;
    reg [3:0] IN0;
    reg [3:0] IN1;
    wire [3:0] OUT1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CTRL(CTRL),
        .IN0(IN0),
        .IN1(IN1),
        .OUT1(OUT1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select IN0 with CTRL=0", test_num);
            IN0 = 4'hA;
            IN1 = 4'h5;
            CTRL = 1'b0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select IN1 with CTRL=1", test_num);
            IN0 = 4'hA;
            IN1 = 4'h5;
            CTRL = 1'b1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select All-Zeros from IN0", test_num);
            IN0 = 4'h0;
            IN1 = 4'hF;
            CTRL = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select All-Ones from IN1", test_num);
            IN0 = 4'h0;
            IN1 = 4'hF;
            CTRL = 1'b1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Toggle check - select IN0 with specific bit pattern", test_num);
            IN0 = 4'b1100;
            IN1 = 4'b0011;
            CTRL = 1'b0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Toggle check - select IN1 with specific bit pattern", test_num);
            IN0 = 4'b1100;
            IN1 = 4'b0011;
            CTRL = 1'b1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary condition - Both inputs identical, CTRL=0", test_num);
            IN0 = 4'h7;
            IN1 = 4'h7;
            CTRL = 1'b0;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary condition - Both inputs identical, CTRL=1", test_num);
            IN0 = 4'h7;
            IN1 = 4'h7;
            CTRL = 1'b1;
            #1;

            check_outputs(4'h7);
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
        input [3:0] expected_OUT1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT1 === (expected_OUT1 ^ OUT1 ^ expected_OUT1)) begin
                $display("PASS");
                $display("  Outputs: OUT1=%h",
                         OUT1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT1=%h",
                         expected_OUT1);
                $display("  Got:      OUT1=%h",
                         OUT1);
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
