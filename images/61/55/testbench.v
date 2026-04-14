`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] a;
    reg [23:0] b;
    wire [23:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero multiplication (0 * 0)", test_num);
            a = 24'h0;
            b = 24'h0;
            #1;

            check_outputs(24'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by zero (123456 * 0)", test_num);
            a = 24'h123456;
            b = 24'h0;
            #1;

            check_outputs(24'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity multiplication (0xABCDEF * 1)", test_num);
            a = 24'hABCDEF;
            b = 24'h1;
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple small multiplication (100 * 250)", test_num);
            a = 24'd100;
            b = 24'd250;
            #1;

            check_outputs(24'd25000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 multiplication (2^10 * 2^10)", test_num);
            a = 24'h400;
            b = 24'h400;
            #1;

            check_outputs(24'h100000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication resulting in boundary overflow (2^12 * 2^12)", test_num);
            a = 24'h1000;
            b = 24'h1000;

            #1;


            check_outputs(24'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large value multiplication (0xFFFF * 0x2)", test_num);
            a = 24'h00FFFF;
            b = 24'h2;
            #1;

            check_outputs(24'h01FFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum 16-bit square in 24-bit (0xFFFF * 0xFFFF)", test_num);
            a = 24'hFFFF;
            b = 24'hFFFF;


            #1;



            check_outputs(24'hE00001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Patterned bits (0x555555 * 2)", test_num);
            a = 24'h555555;
            b = 24'h2;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max values truncation (0xFFFFFF * 0xFFFFFF)", test_num);
            a = 24'hFFFFFF;
            b = 24'hFFFFFF;


            #1;



            check_outputs(24'h1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prime-like large values (0x123456 * 0x13)", test_num);
            a = 24'h123456;
            b = 24'h13;


            #1;



            check_outputs(24'h59E262);
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
        testcase011();
        
        
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
        input [23:0] expected_OUT;
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
