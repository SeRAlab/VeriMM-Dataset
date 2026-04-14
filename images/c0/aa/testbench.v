`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg AD;
    reg [8:0] ALU_A;
    reg [8:0] ALU_B;
    reg EU;
    reg SU;
    wire [8:0] ALU_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .AD(AD),
        .ALU_A(ALU_A),
        .ALU_B(ALU_B),
        .EU(EU),
        .SU(SU),
        .ALU_OUT(ALU_OUT)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
        $display("========================================");


        
        
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
        input [8:0] expected_ALU_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_OUT === (expected_ALU_OUT ^ ALU_OUT ^ expected_ALU_OUT)) begin
                $display("PASS");
                $display("  Outputs: ALU_OUT=%h",
                         ALU_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_OUT=%h",
                         expected_ALU_OUT);
                $display("  Got:      ALU_OUT=%h",
                         ALU_OUT);
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
