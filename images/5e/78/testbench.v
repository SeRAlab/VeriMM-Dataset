`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg Sel;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Sel(Sel),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Sel=0, Select Input A", test_num);
            A = 32'hDEADBEEF;
            B = 32'hCAFEBABE;
            Sel = 1'b0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Sel=1, Select Input B", test_num);
            A = 32'hDEADBEEF;
            B = 32'hCAFEBABE;
            Sel = 1'b1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sel=0, All 1s on A, All 0s on B", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            Sel = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sel=1, All 1s on A, All 0s on B", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            Sel = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sel=0, Alternating Bits Select A", test_num);
            A = 32'h55555555;
            B = 32'hAAAAAAAA;
            Sel = 1'b0;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sel=1, Alternating Bits Select B", test_num);
            A = 32'h55555555;
            B = 32'hAAAAAAAA;
            Sel = 1'b1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Data swap test, Sel=0", test_num);
            A = 32'h12345678;
            B = 32'h87654321;
            Sel = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Data swap test, Sel=1", test_num);
            A = 32'h12345678;
            B = 32'h87654321;
            Sel = 1'b1;
            #1;

            check_outputs(32'h87654321);
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
        input [31:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
