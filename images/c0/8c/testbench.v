`timescale 1ns/1ps

module color_to_memory_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] color_depth_i;
    reg [31:0] color_i;
    reg [1:0] x_lsb_i;
    wire [31:0] mem_o;
    wire [3:0] sel_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    color_to_memory dut (
        .color_depth_i(color_depth_i),
        .color_i(color_i),
        .x_lsb_i(x_lsb_i),
        .mem_o(mem_o),
        .sel_o(sel_o)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("color_to_memory Testbench");
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
        input [31:0] expected_mem_o;
        input [3:0] expected_sel_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_o === (expected_mem_o ^ mem_o ^ expected_mem_o) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o)) begin
                $display("PASS");
                $display("  Outputs: mem_o=%h, sel_o=%h",
                         mem_o, sel_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_o=%h, sel_o=%h",
                         expected_mem_o, expected_sel_o);
                $display("  Got:      mem_o=%h, sel_o=%h",
                         mem_o, sel_o);
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
