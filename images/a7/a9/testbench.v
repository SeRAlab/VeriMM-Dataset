`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUOut;
    reg IorD;
    reg [31:0] PC_out;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOut(ALUOut),
        .IorD(IorD),
        .PC_out(PC_out),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select PC_out (IorD=0)", test_num);
            PC_out = 32'h12345678;
            ALUOut = 32'hDEADBEEF;
            IorD   = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select ALUOut (IorD=1)", test_num);
            PC_out = 32'h12345678;
            ALUOut = 32'hDEADBEEF;
            IorD   = 1'b1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select PC_out with Zero value", test_num);
            PC_out = 32'h00000000;
            ALUOut = 32'hFFFFFFFF;
            IorD   = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select ALUOut with All Ones", test_num);
            PC_out = 32'h00000000;
            ALUOut = 32'hFFFFFFFF;
            IorD   = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select PC_out with Alternating Bits", test_num);
            PC_out = 32'h55555555;
            ALUOut = 32'hAAAAAAAA;
            IorD   = 1'b0;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select ALUOut with Alternating Bits", test_num);
            PC_out = 32'h55555555;
            ALUOut = 32'hAAAAAAAA;
            IorD   = 1'b1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Switching IorD while inputs stay constant", test_num);
            PC_out = 32'hCAFEF00D;
            ALUOut = 32'hBADC0DE1;

            IorD = 1'b0;
            #1;
            IorD = 1'b1;
            #1;

            check_outputs(32'hBADC0DE1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Switching inputs while IorD stays constant", test_num);
            IorD = 1'b0;
            PC_out = 32'h11112222;
            ALUOut = 32'h33334444;
            #1;
            PC_out = 32'h99998888;
            #1;

            check_outputs(32'h99998888);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
