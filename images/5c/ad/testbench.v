`timescale 1ns/1ps

module or_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg enable;
    reg reset;
    wire [7:0] or_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    or_module dut (
        .a(a),
        .b(b),
        .enable(enable),
        .reset(reset),
        .or_result(or_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority Test", test_num);

            reset = 1;
            enable = 1;
            a = 8'hAA;
            b = 8'h55;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic OR Operation (0x55 | 0xAA)", test_num);

            reset = 1;
            #10;
            reset = 0;

            enable = 1;
            a = 8'h55;
            b = 8'hAA;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic OR Operation (0xF0 | 0x0F)", test_num);

            reset = 1;
            #10;
            reset = 0;

            enable = 1;
            a = 8'hF0;
            b = 8'h0F;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR with Zeroes", test_num);

            reset = 1;
            #10;
            reset = 0;

            enable = 1;
            a = 8'h00;
            b = 8'h00;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR with All Ones", test_num);

            reset = 1;
            #10;
            reset = 0;

            enable = 1;
            a = 8'hFF;
            b = 8'hFF;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise Check (0x12 | 0x48)", test_num);

            reset = 1;
            #10;
            reset = 0;

            enable = 1;
            a = 8'h12;
            b = 8'h48;
            #10;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Gating Check", test_num);

            reset = 1;
            #10;
            reset = 0;



            enable = 0;
            a = 8'hFF;
            b = 8'hFF;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("or_module Testbench");
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
        input [7:0] expected_or_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_or_result === (expected_or_result ^ or_result ^ expected_or_result)) begin
                $display("PASS");
                $display("  Outputs: or_result=%h",
                         or_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: or_result=%h",
                         expected_or_result);
                $display("  Got:      or_result=%h",
                         or_result);
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
