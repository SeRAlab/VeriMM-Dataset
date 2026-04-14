`timescale 1ns/1ps

module slice_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] Din;
    wire [9:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slice_module dut (
        .Din(Din),
        .Dout(Dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            Din = 18'h00000;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            Din = 18'h3FFFF;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Only target bits (12:3) set", test_num);
            Din = 18'h01FF8;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Only bits outside range (17:13 and 2:0) set", test_num);
            Din = 18'h3E007;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern A", test_num);


            Din = 18'h15555;
            #1;

            check_outputs(10'h155);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern B", test_num);


            Din = 18'h2AAAA;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit at position 12 (MSB of slice)", test_num);
            Din = 18'h01000;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit at position 3 (LSB of slice)", test_num);
            Din = 18'h00008;
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking boundary bits 13 and 2 are excluded", test_num);
            Din = 18'h02004;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random pattern 0x3AC59", test_num);


            Din = 18'h3AC59;
            #1;

            check_outputs(10'h18B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slice_module Testbench");
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
        input [9:0] expected_Dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
