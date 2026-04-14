`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg ovf;
    reg rst;
    reg unaligned;
    wire [31:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ovf(ovf),
        .rst(rst),
        .unaligned(unaligned),
        .status(status)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both inputs 0", test_num);

            rst = 1;
            clk = 0;
            unaligned = 0;
            ovf = 0;
            #10;
            rst = 0;
            #10;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unaligned=1, Ovf=0", test_num);

            rst = 1;
            clk = 0;
            unaligned = 1;
            ovf = 0;
            #10;
            rst = 0;
            #10;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unaligned=0, Ovf=1", test_num);

            rst = 1;
            clk = 0;
            unaligned = 0;
            ovf = 1;
            #10;
            rst = 0;
            #10;

            #1;


            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both inputs 1", test_num);

            rst = 1;
            clk = 0;
            unaligned = 1;
            ovf = 1;
            #10;
            rst = 0;
            #10;

            #1;


            check_outputs(32'h00000003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle inputs after reset", test_num);

            rst = 1;
            clk = 0;
            unaligned = 0;
            ovf = 0;
            #10;
            rst = 0;
            #5;
            unaligned = 1;
            #5;
            ovf = 1;
            #10;

            #1;


            check_outputs(32'h00000003);
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
        input [31:0] expected_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
