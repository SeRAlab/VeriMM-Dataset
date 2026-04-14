`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pc;
    wire [31:0] inst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc(pc),
        .inst(inst)
    );
    task init_mem_clear;

        integer i;
        begin
            for (i = 0; i < 65536; i = i + 1) begin
                dut.mem[i] = 8'h00;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase001: Read from address 0x0000");
            dut.mem[0] = 8'h12;
            dut.mem[1] = 8'h34;
            dut.mem[2] = 8'h56;
            dut.mem[3] = 8'h78;
            pc = 32'h00000000;


            #1;



            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase002: Read from address 0x0100");
            dut.mem[16'h0100] = 8'hDE;
            dut.mem[16'h0101] = 8'hAD;
            dut.mem[16'h0102] = 8'hBE;
            dut.mem[16'h0103] = 8'hEF;
            pc = 32'h00000100;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase003: Masking upper PC bits (PC[31:16] should be ignored)");
            dut.mem[16'h0004] = 8'hAA;
            dut.mem[16'h0005] = 8'hBB;
            dut.mem[16'h0006] = 8'hCC;
            dut.mem[16'h0007] = 8'hDD;

            pc = 32'hFFFF0004;
            #1;

            check_outputs(32'hAABBCCDD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase004: Misaligned read at offset 1");
            dut.mem[1] = 8'h11;
            dut.mem[2] = 8'h22;
            dut.mem[3] = 8'h33;
            dut.mem[4] = 8'h44;
            pc = 32'h00000001;
            #1;

            check_outputs(32'h11223344);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase005: Boundary check at 0xFFFC");
            dut.mem[16'hFFFC] = 8'hFE;
            dut.mem[16'hFFFD] = 8'hDC;
            dut.mem[16'hFFFE] = 8'hBA;
            dut.mem[16'hFFFF] = 8'h98;
            pc = 32'h0000FFFC;
            #1;

            check_outputs(32'hFEDCBA98);
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
        input [31:0] expected_inst;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inst === (expected_inst ^ inst ^ expected_inst)) begin
                $display("PASS");
                $display("  Outputs: inst=%h",
                         inst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst=%h",
                         expected_inst);
                $display("  Got:      inst=%h",
                         inst);
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
