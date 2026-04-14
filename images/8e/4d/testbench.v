`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] eai_csr_addr;
    reg eai_csr_valid;
    reg [31:0] eai_csr_wdata;
    reg eai_csr_wr;
    reg rst_n;
    wire [31:0] eai_csr_rdata;
    wire eai_csr_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .eai_csr_addr(eai_csr_addr),
        .eai_csr_valid(eai_csr_valid),
        .eai_csr_wdata(eai_csr_wdata),
        .eai_csr_wr(eai_csr_wr),
        .rst_n(rst_n),
        .eai_csr_rdata(eai_csr_rdata),
        .eai_csr_ready(eai_csr_ready)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Condition", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read Operation (Address 0x12345678)", test_num);
            reset_dut();
            @(posedge clk);
            eai_csr_valid = 1;
            eai_csr_addr = 32'h12345678;
            eai_csr_wr = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Operation (Address 0xDEADBEEF, Data 0xCAFEBABE)", test_num);
            reset_dut();
            @(posedge clk);
            eai_csr_valid = 1;
            eai_csr_addr = 32'hDEADBEEF;
            eai_csr_wr = 1;
            eai_csr_wdata = 32'hCAFEBABE;
            @(posedge clk);

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interface Idle (valid=0)", test_num);
            reset_dut();
            @(posedge clk);
            eai_csr_valid = 0;
            eai_csr_addr = 32'hFFFFFFFF;
            eai_csr_wr = 1;
            @(posedge clk);

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple cycle check", test_num);
            reset_dut();
            @(posedge clk);
            eai_csr_valid = 1;
            eai_csr_addr = 32'hA5A5A5A5;
            eai_csr_wr = 0;
            repeat(5) @(posedge clk);
            eai_csr_addr = 32'h5A5A5A5A;
            eai_csr_wr = 1;
            eai_csr_wdata = 32'h12344321;
            @(posedge clk);

            #1;


            check_outputs(32'h0, 1'b1);
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
        input [31:0] expected_eai_csr_rdata;
        input expected_eai_csr_ready;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eai_csr_rdata === (expected_eai_csr_rdata ^ eai_csr_rdata ^ expected_eai_csr_rdata) &&
                expected_eai_csr_ready === (expected_eai_csr_ready ^ eai_csr_ready ^ expected_eai_csr_ready)) begin
                $display("PASS");
                $display("  Outputs: eai_csr_rdata=%h, eai_csr_ready=%b",
                         eai_csr_rdata, eai_csr_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eai_csr_rdata=%h, eai_csr_ready=%b",
                         expected_eai_csr_rdata, expected_eai_csr_ready);
                $display("  Got:      eai_csr_rdata=%h, eai_csr_ready=%b",
                         eai_csr_rdata, eai_csr_ready);
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
