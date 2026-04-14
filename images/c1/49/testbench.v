`timescale 1ns/1ps

module hazard_detection_unit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] decoding_op_src1;
    reg [2:0] decoding_op_src2;
    reg [2:0] ex_op_dest;
    reg [2:0] mem_op_dest;
    reg [2:0] wb_op_dest;
    wire pipeline_stall_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection_unit dut (
        .decoding_op_src1(decoding_op_src1),
        .decoding_op_src2(decoding_op_src2),
        .ex_op_dest(ex_op_dest),
        .mem_op_dest(mem_op_dest),
        .wb_op_dest(wb_op_dest),
        .pipeline_stall_n(pipeline_stall_n)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hazard_detection_unit Testbench");
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
        input expected_pipeline_stall_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pipeline_stall_n === (expected_pipeline_stall_n ^ pipeline_stall_n ^ expected_pipeline_stall_n)) begin
                $display("PASS");
                $display("  Outputs: pipeline_stall_n=%b",
                         pipeline_stall_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pipeline_stall_n=%b",
                         expected_pipeline_stall_n);
                $display("  Got:      pipeline_stall_n=%b",
                         pipeline_stall_n);
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
