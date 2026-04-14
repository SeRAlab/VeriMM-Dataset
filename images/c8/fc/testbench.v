`timescale 1ns/1ps

module binary_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] D;
    wire [2:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_encoder dut (
        .D(D),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        D = 2'b00;
        #10;
        $display("Test Case 001: Input D = %b", D);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        D = 2'b01;
        #10;
        $display("Test Case 002: Input D = %b", D);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        D = 2'b10;
        #10;
        $display("Test Case 003: Input D = %b", D);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        D = 2'b11;
        #10;
        $display("Test Case 004: Input D = %b", D);
        #1;

        check_outputs(3'b011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [2:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
