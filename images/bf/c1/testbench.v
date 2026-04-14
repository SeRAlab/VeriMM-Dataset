`timescale 1ns/1ps

module jt51_lin2exp_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] lin;
    wire [2:0] exp;
    wire [9:0] man;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jt51_lin2exp dut (
        .lin(lin),
        .exp(exp),
        .man(man)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jt51_lin2exp Testbench");
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
        input [2:0] expected_exp;
        input [9:0] expected_man;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exp === (expected_exp ^ exp ^ expected_exp) &&
                expected_man === (expected_man ^ man ^ expected_man)) begin
                $display("PASS");
                $display("  Outputs: exp=%h, man=%h",
                         exp, man);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exp=%h, man=%h",
                         expected_exp, expected_man);
                $display("  Got:      exp=%h, man=%h",
                         exp, man);
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
