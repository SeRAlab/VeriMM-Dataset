`timescale 1ns/1ps

module data_swap_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg [1:0] swap_type;
    wire [31:0] data_swap;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_swap dut (
        .data_in(data_in),
        .swap_type(swap_type),
        .data_swap(data_swap)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_swap Testbench");
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
        input [31:0] expected_data_swap;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_swap === (expected_data_swap ^ data_swap ^ expected_data_swap)) begin
                $display("PASS");
                $display("  Outputs: data_swap=%h",
                         data_swap);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_swap=%h",
                         expected_data_swap);
                $display("  Got:      data_swap=%h",
                         data_swap);
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
