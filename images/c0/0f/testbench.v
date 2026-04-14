`timescale 1ns/1ps

module fm_3d_fcnv_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_f32;
    wire [21:0] o_f22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fm_3d_fcnv dut (
        .i_f32(i_f32),
        .o_f22(o_f22)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fm_3d_fcnv Testbench");
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
        input [21:0] expected_o_f22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_f22 === (expected_o_f22 ^ o_f22 ^ expected_o_f22)) begin
                $display("PASS");
                $display("  Outputs: o_f22=%h",
                         o_f22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_f22=%h",
                         expected_o_f22);
                $display("  Got:      o_f22=%h",
                         o_f22);
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
