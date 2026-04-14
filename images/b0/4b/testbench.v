`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] busA;
    reg [7:0] busB;
    wire [7:0] busXOR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .busA(busA),
        .busB(busB),
        .busXOR(busXOR)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: busA=00, busB=00 (All bits zero)", test_num);
            busA = 8'h00;
            busB = 8'h00;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: busA=FF, busB=FF (All bits one)", test_num);
            busA = 8'hFF;
            busB = 8'hFF;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: busA=AA, busB=55 (Inverted patterns)", test_num);
            busA = 8'hAA;
            busB = 8'h55;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: busA=F0, busB=0F (Inverted nibbles)", test_num);
            busA = 8'hF0;
            busB = 8'h0F;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: busA=CC, busB=AA (Overlapping patterns)", test_num);
            busA = 8'hCC;
            busB = 8'hAA;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: busA=12, busB=34 (Random hex values)", test_num);
            busA = 8'h12;
            busB = 8'h34;

            #1;


            check_outputs(8'hEF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: busA=88, busB=88", test_num);
            busA = 8'h88;
            busB = 8'h88;

            #1;


            check_outputs(8'h77);
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
        input [7:0] expected_busXOR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_busXOR === (expected_busXOR ^ busXOR ^ expected_busXOR)) begin
                $display("PASS");
                $display("  Outputs: busXOR=%h",
                         busXOR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busXOR=%h",
                         expected_busXOR);
                $display("  Got:      busXOR=%h",
                         busXOR);
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
