`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg In0;
    reg In1;
    reg In2;
    reg In3;
    reg In4;
    reg In5;
    reg In6;
    wire [6:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In0(In0),
        .In1(In1),
        .In2(In2),
        .In3(In3),
        .In4(In4),
        .In5(In5),
        .In6(In6),
        .dout(dout)
    );
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            In0 = 0; In1 = 0; In2 = 0; In3 = 0; In4 = 0; In5 = 0; In6 = 0;
            #1;

            check_outputs(7'b0000000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All Ones");
            In0 = 1; In1 = 1; In2 = 1; In3 = 1; In4 = 1; In5 = 1; In6 = 1;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Bit 0 (In0) Only");
            In0 = 1; In1 = 0; In2 = 0; In3 = 0; In4 = 0; In5 = 0; In6 = 0;
            #1;

            check_outputs(7'b0000001);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Bit 3 (In3) Only");
            In0 = 0; In1 = 0; In2 = 0; In3 = 1; In4 = 0; In5 = 0; In6 = 0;
            #1;

            check_outputs(7'b0001000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Bit 6 (In6) Only");
            In0 = 0; In1 = 0; In2 = 0; In3 = 0; In4 = 0; In5 = 0; In6 = 1;
            #1;

            check_outputs(7'b1000000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Alternating Pattern 1010101");
            In0 = 1; In1 = 0; In2 = 1; In3 = 0; In4 = 1; In5 = 0; In6 = 1;
            #1;

            check_outputs(7'b1010101);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Alternating Pattern 0101010");
            In0 = 0; In1 = 1; In2 = 0; In3 = 1; In4 = 0; In5 = 1; In6 = 0;
            #1;

            check_outputs(7'b0101010);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Lower 4 bits high, Upper 3 bits low");
            In0 = 1; In1 = 1; In2 = 1; In3 = 1; In4 = 0; In5 = 0; In6 = 0;
            #1;

            check_outputs(7'b0001111);
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
        input [6:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
