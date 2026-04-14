`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A_IN;
    reg [3:0] B_IN;
    reg CY_IN;
    reg SUBP;
    wire CY_OUT;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_IN(A_IN),
        .B_IN(B_IN),
        .CY_IN(CY_IN),
        .SUBP(SUBP),
        .CY_OUT(CY_OUT),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition (3 + 4)", test_num);
            A_IN = 4'h3; B_IN = 4'h4; CY_IN = 1'b0; SUBP = 1'b0;
            #1;

            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Carry-Out (7 + 8)", test_num);
            A_IN = 4'h7; B_IN = 4'h8; CY_IN = 1'b0; SUBP = 1'b0;
            #1;

            check_outputs(1'b1, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max BCD Addition (9 + 9 + 1)", test_num);
            A_IN = 4'h9; B_IN = 4'h9; CY_IN = 1'b1; SUBP = 1'b0;
            #1;

            check_outputs(1'b1, 4'h9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition resulting in 10 (5 + 5)", test_num);
            A_IN = 4'h5; B_IN = 4'h5; CY_IN = 1'b0; SUBP = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Subtraction (8 - 3)", test_num);
            A_IN = 4'h8; B_IN = 4'h3; CY_IN = 1'b0; SUBP = 1'b1;
            #1;

            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction with Borrow (3 - 8)", test_num);
            A_IN = 4'h3; B_IN = 4'h8; CY_IN = 1'b0; SUBP = 1'b1;
            #1;

            check_outputs(1'b1, 4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction 0 - 1", test_num);
            A_IN = 4'h0; B_IN = 4'h1; CY_IN = 1'b0; SUBP = 1'b1;
            #1;

            check_outputs(1'b1, 4'h9);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction with Carry-In (5 - 2 - 1)", test_num);
            A_IN = 4'h5; B_IN = 4'h2; CY_IN = 1'b1; SUBP = 1'b1;
            #1;

            check_outputs(1'b0, 4'h2);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction 0 - 0 - 1", test_num);
            A_IN = 4'h0; B_IN = 4'h0; CY_IN = 1'b1; SUBP = 1'b1;
            #1;

            check_outputs(1'b1, 4'h9);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition 9 + 0 + 1", test_num);
            A_IN = 4'h9; B_IN = 4'h0; CY_IN = 1'b1; SUBP = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
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
        input expected_CY_OUT;
        input [3:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CY_OUT === (expected_CY_OUT ^ CY_OUT ^ expected_CY_OUT) &&
                expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: CY_OUT=%b, OUT=%h",
                         CY_OUT, OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CY_OUT=%b, OUT=%h",
                         expected_CY_OUT, expected_OUT);
                $display("  Got:      CY_OUT=%b, OUT=%h",
                         CY_OUT, OUT);
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
