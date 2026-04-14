`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BCLK;
    reg BRESET;
    reg IVAR;
    reg [31:0] MVALID;
    reg NEW_PTB;
    reg PTB1;
    reg [31:0] UPDATE;
    reg [3:0] VADR;
    reg [3:0] VADR_R;
    reg WR_MRAM;
    wire [31:0] DAT_MV;
    wire NEW_PTB_RUN;
    wire [3:0] RADR_MV;
    wire [3:0] WADR_MV;
    wire WE_MV;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BCLK(BCLK),
        .BRESET(BRESET),
        .IVAR(IVAR),
        .MVALID(MVALID),
        .NEW_PTB(NEW_PTB),
        .PTB1(PTB1),
        .UPDATE(UPDATE),
        .VADR(VADR),
        .VADR_R(VADR_R),
        .WR_MRAM(WR_MRAM),
        .DAT_MV(DAT_MV),
        .NEW_PTB_RUN(NEW_PTB_RUN),
        .RADR_MV(RADR_MV),
        .WADR_MV(WADR_MV),
        .WE_MV(WE_MV)
    );

    // Clock generation (10ns period)
    initial begin
        BCLK = 0;
        forever #5 BCLK = ~BCLK;
    end

        task reset_dut;

        begin
            BRESET = 1;
            NEW_PTB = 0;
            PTB1 = 0;
            IVAR = 0;
            WR_MRAM = 0;
            VADR = 0;
            VADR_R = 0;
            MVALID = 0;
            UPDATE = 0;
            repeat(2) @(posedge BCLK);
            #1 BRESET = 0;
            @(posedge BCLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0, 4'h0, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge BCLK);
            NEW_PTB = 1;
            @(posedge BCLK);
            NEW_PTB = 0;
            #1;

            if (NEW_PTB_RUN === 1'b1) begin

                repeat(18) @(posedge BCLK);
                #1;

                check_outputs(DAT_MV, 1'b0, RADR_MV, WADR_MV, 1'b0);
            end else begin
                $display("Error: NEW_PTB_RUN did not activate");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge BCLK);
            WR_MRAM = 1;
            VADR = 4'hA;
            MVALID = 32'hAAAA_5555;
            @(posedge BCLK);
            #1;

            #1;


            check_outputs(32'hAAAA_5555, 1'b0, 4'hA, 4'hA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge BCLK);
            IVAR = 1;
            VADR_R = 4'h5;
            UPDATE = 32'h0000_0000;
            @(posedge BCLK);
            #1;

            #1;


            check_outputs(32'h0000_0000, 1'b0, 4'h5, 4'h5, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge BCLK);
            NEW_PTB = 1;
            WR_MRAM = 1;
            @(posedge BCLK);
            NEW_PTB = 0;
            #1;

            #1;


            check_outputs(DAT_MV, 1'b1, RADR_MV, WADR_MV, WE_MV);
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
        input [31:0] expected_DAT_MV;
        input expected_NEW_PTB_RUN;
        input [3:0] expected_RADR_MV;
        input [3:0] expected_WADR_MV;
        input expected_WE_MV;
        begin
            if (expected_DAT_MV === (expected_DAT_MV ^ DAT_MV ^ expected_DAT_MV) &&
                expected_NEW_PTB_RUN === (expected_NEW_PTB_RUN ^ NEW_PTB_RUN ^ expected_NEW_PTB_RUN) &&
                expected_RADR_MV === (expected_RADR_MV ^ RADR_MV ^ expected_RADR_MV) &&
                expected_WADR_MV === (expected_WADR_MV ^ WADR_MV ^ expected_WADR_MV) &&
                expected_WE_MV === (expected_WE_MV ^ WE_MV ^ expected_WE_MV)) begin
                $display("PASS");
                $display("  Outputs: DAT_MV=%h, NEW_PTB_RUN=%b, RADR_MV=%h, WADR_MV=%h, WE_MV=%b",
                         DAT_MV, NEW_PTB_RUN, RADR_MV, WADR_MV, WE_MV);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DAT_MV=%h, NEW_PTB_RUN=%b, RADR_MV=%h, WADR_MV=%h, WE_MV=%b",
                         expected_DAT_MV, expected_NEW_PTB_RUN, expected_RADR_MV, expected_WADR_MV, expected_WE_MV);
                $display("  Got:      DAT_MV=%h, NEW_PTB_RUN=%b, RADR_MV=%h, WADR_MV=%h, WE_MV=%b",
                         DAT_MV, NEW_PTB_RUN, RADR_MV, WADR_MV, WE_MV);
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
        $dumpvars(0,BCLK, BRESET, IVAR, MVALID, NEW_PTB, PTB1, UPDATE, VADR, VADR_R, WR_MRAM, DAT_MV, NEW_PTB_RUN, RADR_MV, WADR_MV, WE_MV);
    end

endmodule
