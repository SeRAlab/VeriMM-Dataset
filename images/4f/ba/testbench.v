`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pc;
    wire [31:0] sal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc(pc),
        .sal(sal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial PC (0)", test_num);
            pc = 32'h00000000;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical instruction address", test_num);
            pc = 32'h00000100;
            #1;

            check_outputs(32'h00000104);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range address", test_num);
            pc = 32'h12345678;
            #1;

            check_outputs(32'h1234567C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large memory address", test_num);
            pc = 32'hABCDE000;
            #1;

            check_outputs(32'hABCDE004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary wrap-around (Max - 4)", test_num);
            pc = 32'hFFFFFFFC;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary wrap-around (Max)", test_num);
            pc = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern", test_num);
            pc = 32'h5A5A5A5A;
            #1;

            check_outputs(32'h5A5A5A5E);
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
        input [31:0] expected_sal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sal === (expected_sal ^ sal ^ expected_sal)) begin
                $display("PASS");
                $display("  Outputs: sal=%h",
                         sal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sal=%h",
                         expected_sal);
                $display("  Got:      sal=%h",
                         sal);
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
