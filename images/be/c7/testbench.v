`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg MemtoReg;
    reg [31:0] alu_out;
    reg [31:0] dm_out;
    wire [31:0] mux3_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemtoReg(MemtoReg),
        .alu_out(alu_out),
        .dm_out(dm_out),
        .mux3_out(mux3_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select alu_out (MemtoReg = 0)", test_num);
            alu_out = 32'hDEADBEEF;
            dm_out  = 32'hCAFEBABE;
            MemtoReg = 0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dm_out (MemtoReg = 1)", test_num);
            alu_out = 32'hDEADBEEF;
            dm_out  = 32'hCAFEBABE;
            MemtoReg = 1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select alu_out with all zeros (MemtoReg = 0)", test_num);
            alu_out = 32'h00000000;
            dm_out  = 32'hFFFFFFFF;
            MemtoReg = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dm_out with all ones (MemtoReg = 1)", test_num);
            alu_out = 32'h00000000;
            dm_out  = 32'hFFFFFFFF;
            MemtoReg = 1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary values - alternating bits (MemtoReg = 0)", test_num);
            alu_out = 32'hAAAAAAAA;
            dm_out  = 32'h55555555;
            MemtoReg = 0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary values - alternating bits (MemtoReg = 1)", test_num);
            alu_out = 32'hAAAAAAAA;
            dm_out  = 32'h55555555;
            MemtoReg = 1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data with high bit set (MemtoReg = 0)", test_num);
            alu_out = 32'h80000000;
            dm_out  = 32'h7FFFFFFF;
            MemtoReg = 0;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data with high bit set (MemtoReg = 1)", test_num);
            alu_out = 32'h80000000;
            dm_out  = 32'h7FFFFFFF;
            MemtoReg = 1;
            #1;

            check_outputs(32'h7FFFFFFF);
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
        input [31:0] expected_mux3_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux3_out === (expected_mux3_out ^ mux3_out ^ expected_mux3_out)) begin
                $display("PASS");
                $display("  Outputs: mux3_out=%h",
                         mux3_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux3_out=%h",
                         expected_mux3_out);
                $display("  Got:      mux3_out=%h",
                         mux3_out);
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
