`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] extended_times_four;
    reg [31:0] pc_plus_four;
    wire [31:0] branch_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .extended_times_four(extended_times_four),
        .pc_plus_four(pc_plus_four),
        .branch_address(branch_address)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic forward branch", test_num);
            pc_plus_four = 32'h00001000;
            extended_times_four = 32'h00000004;
            #1;

            check_outputs(32'h00001004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic backward branch", test_num);
            pc_plus_four = 32'h00001000;
            extended_times_four = 32'hfffffffc;
            #1;

            check_outputs(32'h00000ffc);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero offset", test_num);
            pc_plus_four = 32'h12345678;
            extended_times_four = 32'h00000000;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition causing overflow (wraparound)", test_num);
            pc_plus_four = 32'hfffffffc;
            extended_times_four = 32'h00000008;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large forward offset", test_num);
            pc_plus_four = 32'h10000000;
            extended_times_four = 32'h20000000;
            #1;

            check_outputs(32'h30000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large backward offset (underflow)", test_num);
            pc_plus_four = 32'h00000010;
            extended_times_four = 32'hffff0000;
            #1;

            check_outputs(32'hffff0010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values", test_num);
            pc_plus_four = 32'hffffffff;
            extended_times_four = 32'hffffffff;
            #1;

            check_outputs(32'hfffffffe);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle range addition", test_num);
            pc_plus_four = 32'h70000000;
            extended_times_four = 32'h10000000;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_branch_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch_address === (expected_branch_address ^ branch_address ^ expected_branch_address)) begin
                $display("PASS");
                $display("  Outputs: branch_address=%h",
                         branch_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch_address=%h",
                         expected_branch_address);
                $display("  Got:      branch_address=%h",
                         branch_address);
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
