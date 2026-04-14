`timescale 1ns/1ps

module ACS_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] path_0_bmc;
    reg [7:0] path_0_pmc;
    reg path_0_valid;
    reg [1:0] path_1_bmc;
    reg [7:0] path_1_pmc;
    reg path_1_valid;
    wire [7:0] path_cost;
    wire selection;
    wire valid_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ACS dut (
        .path_0_bmc(path_0_bmc),
        .path_0_pmc(path_0_pmc),
        .path_0_valid(path_0_valid),
        .path_1_bmc(path_1_bmc),
        .path_1_pmc(path_1_pmc),
        .path_1_valid(path_1_valid),
        .path_cost(path_cost),
        .selection(selection),
        .valid_o(valid_o)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ACS Testbench");
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
        input [7:0] expected_path_cost;
        input expected_selection;
        input expected_valid_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_path_cost === (expected_path_cost ^ path_cost ^ expected_path_cost) &&
                expected_selection === (expected_selection ^ selection ^ expected_selection) &&
                expected_valid_o === (expected_valid_o ^ valid_o ^ expected_valid_o)) begin
                $display("PASS");
                $display("  Outputs: path_cost=%h, selection=%b, valid_o=%b",
                         path_cost, selection, valid_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path_cost=%h, selection=%b, valid_o=%b",
                         expected_path_cost, expected_selection, expected_valid_o);
                $display("  Got:      path_cost=%h, selection=%b, valid_o=%b",
                         path_cost, selection, valid_o);
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
