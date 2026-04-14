`timescale 1ns/1ps

module WB_stage_tb;

    // Testbench signals (combinational circuit)
    reg [36:0] pipeline_reg_in;
    wire [15:0] reg_write_data;
    wire [2:0] reg_write_dest;
    wire reg_write_en;
    wire [2:0] wb_op_dest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    WB_stage dut (
        .pipeline_reg_in(pipeline_reg_in),
        .reg_write_data(reg_write_data),
        .reg_write_dest(reg_write_dest),
        .reg_write_en(reg_write_en),
        .wb_op_dest(wb_op_dest)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("WB_stage Testbench");
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
        input [15:0] expected_reg_write_data;
        input [2:0] expected_reg_write_dest;
        input expected_reg_write_en;
        input [2:0] expected_wb_op_dest;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reg_write_data === (expected_reg_write_data ^ reg_write_data ^ expected_reg_write_data) &&
                expected_reg_write_dest === (expected_reg_write_dest ^ reg_write_dest ^ expected_reg_write_dest) &&
                expected_reg_write_en === (expected_reg_write_en ^ reg_write_en ^ expected_reg_write_en) &&
                expected_wb_op_dest === (expected_wb_op_dest ^ wb_op_dest ^ expected_wb_op_dest)) begin
                $display("PASS");
                $display("  Outputs: reg_write_data=%h, reg_write_dest=%h, reg_write_en=%b, wb_op_dest=%h",
                         reg_write_data, reg_write_dest, reg_write_en, wb_op_dest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_write_data=%h, reg_write_dest=%h, reg_write_en=%b, wb_op_dest=%h",
                         expected_reg_write_data, expected_reg_write_dest, expected_reg_write_en, expected_wb_op_dest);
                $display("  Got:      reg_write_data=%h, reg_write_dest=%h, reg_write_en=%b, wb_op_dest=%h",
                         reg_write_data, reg_write_dest, reg_write_en, wb_op_dest);
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
