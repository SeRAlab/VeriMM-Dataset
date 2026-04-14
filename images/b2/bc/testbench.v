`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] from_mux_branch;
    reg jump;
    reg [31:0] jump_address;
    wire [31:0] to_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .from_mux_branch(from_mux_branch),
        .jump(jump),
        .jump_address(jump_address),
        .to_pc(to_pc)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select from_mux_branch (jump=0)", test_num);
            jump = 1'b0;
            from_mux_branch = 32'hDEADBEEF;
            jump_address    = 32'hCAFEBABE;
            #10;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select jump_address (jump=1)", test_num);
            jump = 1'b1;
            from_mux_branch = 32'hDEADBEEF;
            jump_address    = 32'hCAFEBABE;
            #10;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros input, jump=0", test_num);
            jump = 1'b0;
            from_mux_branch = 32'h00000000;
            jump_address    = 32'hFFFFFFFF;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones input, jump=1", test_num);
            jump = 1'b1;
            from_mux_branch = 32'h00000000;
            jump_address    = 32'hFFFFFFFF;
            #10;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern, jump=0", test_num);
            jump = 1'b0;
            from_mux_branch = 32'h5555AAAA;
            jump_address    = 32'hAAAA5555;
            #10;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify immediate update on jump toggle", test_num);
            from_mux_branch = 32'h11111111;
            jump_address    = 32'h22222222;
            jump = 1'b0;
            #5;
            jump = 1'b1;
            #5;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large address values, jump=0", test_num);
            jump = 1'b0;
            from_mux_branch = 32'h80000000;
            jump_address    = 32'h7FFFFFFF;
            #10;
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
        input [31:0] expected_to_pc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_to_pc === (expected_to_pc ^ to_pc ^ expected_to_pc)) begin
                $display("PASS");
                $display("  Outputs: to_pc=%h",
                         to_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: to_pc=%h",
                         expected_to_pc);
                $display("  Got:      to_pc=%h",
                         to_pc);
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
