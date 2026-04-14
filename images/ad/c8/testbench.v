`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CONTROL;
    reg [4:0] IN0;
    reg [4:0] IN1;
    wire [4:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CONTROL(CONTROL),
        .IN0(IN0),
        .IN1(IN1),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select IN0 (CONTROL=0)", test_num);
            CONTROL = 1'b0;
            IN0 = 5'h15;
            IN1 = 5'h0A;
            #10;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select IN1 (CONTROL=1)", test_num);
            CONTROL = 1'b1;
            IN0 = 5'h15;
            IN1 = 5'h0A;
            #10;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: All ones on IN0, CONTROL=0", test_num);
            CONTROL = 1'b0;
            IN0 = 5'b11111;
            IN1 = 5'b00000;
            #10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: All ones on IN1, CONTROL=1", test_num);
            CONTROL = 1'b1;
            IN0 = 5'b00000;
            IN1 = 5'b11111;
            #10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Alternating pattern, CONTROL=1", test_num);
            CONTROL = 1'b1;
            IN0 = 5'h00;
            IN1 = 5'h12;
            #10;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Undefined CONTROL (X), Output defaults to zero", test_num);
            CONTROL = 1'bx;
            IN0 = 5'h1F;
            IN1 = 5'h1F;
            #10;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Undefined CONTROL (Z), Output defaults to zero", test_num);
            CONTROL = 1'bz;
            IN0 = 5'h0F;
            IN1 = 5'h05;
            #10;
            #1;

            check_outputs(5'h00);
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
        input [4:0] expected_OUT;
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
