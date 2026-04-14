`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    wire [4:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .r(r)
    );
    task testcase001;

        begin
            a = 5'd0; b = 5'd0;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase002;

        begin
            a = 5'd5; b = 5'd2;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase003;

        begin
            a = 5'd4; b = 5'd4;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase004;

        begin
            a = 5'd12; b = 5'd4;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase005;

        begin
            a = 5'd15; b = 5'd15;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase006;

        begin
            a = 5'd20; b = 5'd15;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase007;

        begin
            a = 5'd31; b = 5'd1;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase008;

        begin
            a = 5'd31; b = 5'd31;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase009;

        begin
            a = 5'd10; b = 5'd10;
            #1;

            check_outputs(reference_logic(a, b));
        end
        endtask

    task testcase010;

        begin
            a = 5'd7; b = 5'd1;
            #1;

            check_outputs(reference_logic(a, b));
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
        input [4:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
