`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] SW;
    wire [17:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .LEDR(LEDR)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            SW = 18'h00000;
            #1;

            check_outputs(18'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            SW = 18'h3FFFF;
            #1;

            check_outputs(18'h3FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pattern 1010...", test_num);
            SW = 18'h2AAAA;
            #1;

            check_outputs(18'h2AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pattern 0101...", test_num);
            SW = 18'h15555;
            #1;

            check_outputs(18'h15555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower half set", test_num);
            SW = 18'h001FF;
            #1;

            check_outputs(18'h001FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper half set", test_num);
            SW = 18'h3FE00;
            #1;

            check_outputs(18'h3FE00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking 1 - Bit 0", test_num);
            SW = 18'h00001;
            #1;

            check_outputs(18'h00001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking 1 - Bit 17", test_num);
            SW = 18'h20000;
            #1;

            check_outputs(18'h20000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary pattern A", test_num);
            SW = 18'h12345;
            #1;

            check_outputs(18'h12345);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary pattern B", test_num);
            SW = 18'h0F0F0;
            #1;

            check_outputs(18'h0F0F0);
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
        input [17:0] expected_LEDR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%h",
                         LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%h",
                         expected_LEDR);
                $display("  Got:      LEDR=%h",
                         LEDR);
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
