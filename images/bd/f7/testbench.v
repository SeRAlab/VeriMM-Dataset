`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr;
    wire [6:0] dev;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .dev(dev)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All zeros input", test_num);
            addr = 32'h0000_0000;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Upper bits zero, middle bits non-zero", test_num);
            addr = 32'h0000_01FC;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 10 set (Minimum upper bit)", test_num);
            addr = 32'h0000_0404;
            #1;

            check_outputs(7'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 31 set (Maximum upper bit)", test_num);
            addr = 32'h8000_0010;
            #1;

            check_outputs(7'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All bits one", test_num);
            addr = 32'hFFFF_FFFF;
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random address with non-zero upper bits", test_num);
            addr = 32'h00ABC124;
            #1;

            check_outputs(7'h49);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Only bits 9-0 set", test_num);
            addr = 32'h0000_03FF;
            #1;

            check_outputs(7'h00);
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
        input [6:0] expected_dev;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dev === (expected_dev ^ dev ^ expected_dev)) begin
                $display("PASS");
                $display("  Outputs: dev=%h",
                         dev);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dev=%h",
                         expected_dev);
                $display("  Got:      dev=%h",
                         dev);
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
