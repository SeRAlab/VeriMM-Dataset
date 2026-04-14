`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IEN_d;
    reg IOF_d;
    reg IRQ;
    reg [11:0] PC;
    reg RTI_d;
    reg branch_d;
    reg clock;
    wire [11:0] ISR_adr;
    wire branch_ISR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IEN_d(IEN_d),
        .IOF_d(IOF_d),
        .IRQ(IRQ),
        .PC(PC),
        .RTI_d(RTI_d),
        .branch_d(branch_d),
        .clock(clock),
        .ISR_adr(ISR_adr),
        .branch_ISR(branch_ISR)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            IEN_d = 0;
            IOF_d = 0;
            IRQ = 0;
            PC = 12'h000;
            RTI_d = 0;
            branch_d = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            PC = 12'hABC;
            IEN_d = 1;
            IRQ = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(12'h001, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            PC = 12'h123;
            IEN_d = 0;
            IRQ = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(ISR_adr, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            PC = 12'hABC;
            IEN_d = 1;
            IRQ = 1;
            @(posedge clock);
            #1;
            IRQ = 0;
            IEN_d = 1;


            RTI_d = 1;
            @(posedge clock);
            #2;

            #1;


            check_outputs(12'hABC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            PC = 12'h555;
            branch_d = 1;
            IRQ = 0;
            IEN_d = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(ISR_adr, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            PC = 12'hFED;
            IEN_d = 1;
            IRQ = 1;
            @(posedge clock);
            #1;
            IRQ = 0;
            RTI_d = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(12'hFED, 1'b1);
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
        input [11:0] expected_ISR_adr;
        input expected_branch_ISR;
        begin
            if (expected_ISR_adr === (expected_ISR_adr ^ ISR_adr ^ expected_ISR_adr) &&
                expected_branch_ISR === (expected_branch_ISR ^ branch_ISR ^ expected_branch_ISR)) begin
                $display("PASS");
                $display("  Outputs: ISR_adr=%h, branch_ISR=%b",
                         ISR_adr, branch_ISR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ISR_adr=%h, branch_ISR=%b",
                         expected_ISR_adr, expected_branch_ISR);
                $display("  Got:      ISR_adr=%h, branch_ISR=%b",
                         ISR_adr, branch_ISR);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,IEN_d, IOF_d, IRQ, PC, RTI_d, branch_d, clock, ISR_adr, branch_ISR);
    end

endmodule
