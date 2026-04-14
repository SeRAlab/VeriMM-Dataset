`timescale 1ns/1ps

module v84f0a1_v9a2a06_tb;

    // Testbench signals (combinational circuit)
    reg i0;
    reg i1;
    reg i2;
    reg i3;
    wire [3:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    v84f0a1_v9a2a06 dut (
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .o(o)
    );
    task testcase001;

    begin
        $display("Test Case 001: All zeros");
        i0 = 1'b0; i1 = 1'b0; i2 = 1'b0; i3 = 1'b0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: All ones");
        i0 = 1'b1; i1 = 1'b1; i2 = 1'b1; i3 = 1'b1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Single bit high (Otherwise case)");
        i0 = 1'b1; i1 = 1'b0; i2 = 1'b0; i3 = 1'b0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Single bit low (Otherwise case)");
        i0 = 1'b1; i1 = 1'b1; i2 = 1'b1; i3 = 1'b0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Mixed inputs (Otherwise case)");
        i0 = 1'b1; i1 = 1'b0; i2 = 1'b1; i3 = 1'b0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Mixed inputs variation (Otherwise case)");
        i0 = 1'b0; i1 = 1'b1; i2 = 1'b0; i3 = 1'b1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Another variation (Otherwise case)");
        i0 = 1'b0; i1 = 1'b0; i2 = 1'b1; i3 = 1'b1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("v84f0a1_v9a2a06 Testbench");
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
        input [3:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
