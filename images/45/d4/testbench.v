`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] jr;
    reg [5:0] opcode;
    reg [4:0] rdM;
    reg [4:0] rsD;
    wire mux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .jr(jr),
        .opcode(opcode),
        .rdM(rdM),
        .rsD(rsD),
        .mux(mux)
    );
    task testcase001;

        begin
            test_num = 1;
            opcode = NOP_OP;
            jr     = JR_INST;
            rdM    = 5'd10;
            rsD    = 5'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            opcode = 6'b000010;
            jr     = JR_INST;
            rdM    = 5'd10;
            rsD    = 5'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            opcode = NOP_OP;
            jr     = 6'b000000;
            rdM    = 5'd10;
            rsD    = 5'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            opcode = NOP_OP;
            jr     = JR_INST;
            rdM    = 5'd10;
            rsD    = 5'd11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            opcode = NOP_OP;
            jr     = JR_INST;
            rdM    = 5'd0;
            rsD    = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            opcode = NOP_OP;
            jr     = JR_INST;
            rdM    = 5'd31;
            rsD    = 5'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            opcode = 6'b111111;
            jr     = 6'b111111;
            rdM    = 5'd01;
            rsD    = 5'd02;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_mux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux === (expected_mux ^ mux ^ expected_mux)) begin
                $display("PASS");
                $display("  Outputs: mux=%b",
                         mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux=%b",
                         expected_mux);
                $display("  Got:      mux=%b",
                         mux);
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
