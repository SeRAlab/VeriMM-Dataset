`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLOCK;
    reg [31:0] iRD_ADDR;
    reg iRD_BUSY;
    reg iRD_REQ;
    reg iREMOVE;
    reg [31:0] iUP_ADDR;
    reg [31:0] iUP_DATA;
    reg [3:0] iUP_MASK;
    reg [1:0] iUP_ORDER;
    reg iUP_REQ;
    reg [31:0] iWR_ADDR;
    reg [511:0] iWR_DATA;
    reg [255:0] iWR_MMU_FLAGS;
    reg iWR_REQ;
    reg inRESET;
    wire oRD_BUSY;
    wire [31:0] oRD_DATA;
    wire oRD_HIT;
    wire [13:0] oRD_MMU_FLAGS;
    wire oRD_VALID;
    wire oUP_BUSY;
    wire oWR_BUSY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLOCK(iCLOCK),
        .iRD_ADDR(iRD_ADDR),
        .iRD_BUSY(iRD_BUSY),
        .iRD_REQ(iRD_REQ),
        .iREMOVE(iREMOVE),
        .iUP_ADDR(iUP_ADDR),
        .iUP_DATA(iUP_DATA),
        .iUP_MASK(iUP_MASK),
        .iUP_ORDER(iUP_ORDER),
        .iUP_REQ(iUP_REQ),
        .iWR_ADDR(iWR_ADDR),
        .iWR_DATA(iWR_DATA),
        .iWR_MMU_FLAGS(iWR_MMU_FLAGS),
        .iWR_REQ(iWR_REQ),
        .inRESET(inRESET),
        .oRD_BUSY(oRD_BUSY),
        .oRD_DATA(oRD_DATA),
        .oRD_HIT(oRD_HIT),
        .oRD_MMU_FLAGS(oRD_MMU_FLAGS),
        .oRD_VALID(oRD_VALID),
        .oUP_BUSY(oUP_BUSY),
        .oWR_BUSY(oWR_BUSY)
    );

    // Clock generation (10ns period)
    initial begin
        iCLOCK = 0;
        forever #5 iCLOCK = ~iCLOCK;
    end

        task reset_dut;

        begin
            inRESET = 0;
            iRD_ADDR = 32'h0;
            iRD_BUSY = 0;
            iRD_REQ = 0;
            iREMOVE = 0;
            iUP_ADDR = 32'h0;
            iUP_DATA = 32'h0;
            iUP_MASK = 4'h0;
            iUP_ORDER = 2'h0;
            iUP_REQ = 0;
            iWR_ADDR = 32'h0;
            iWR_DATA = 512'h0;
            iWR_MMU_FLAGS = 256'h0;
            iWR_REQ = 0;
            #20;
            inRESET = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 14'h0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write Line and Read Hit");
            test_num = 2;
            reset_dut();


            iWR_ADDR = 32'h00001000;
            iWR_DATA = 512'h11112222333344445555666677778888AAAABBBBCCCCDDDD0000111122223333;
            iWR_MMU_FLAGS = 256'hFF;
            iWR_REQ = 1;
            #10;
            iWR_REQ = 0;
            #40;


            iRD_ADDR = 32'h00001000;
            iRD_REQ = 1;
            #10;
            iRD_REQ = 0;
            #20;




            #1;





            check_outputs(1'b0, 32'h33332222, 1'b1, 14'h0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Read Miss Check");
            test_num = 3;
            reset_dut();


            iRD_ADDR = 32'h0000ABCD;
            iRD_REQ = 1;
            #10;
            iRD_REQ = 0;
            #20;



            #1;




            check_outputs(1'b0, 32'h0, 1'b0, 14'h0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Update Word and Verify");
            test_num = 4;
            reset_dut();


            iWR_ADDR = 32'h00002000;
            iWR_DATA = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            iWR_REQ = 1;
            #10;
            iWR_REQ = 0;
            #20;


            iUP_ADDR = 32'h00002004;
            iUP_DATA = 32'hDEADBEEF;
            iUP_MASK = 4'hF;
            iUP_ORDER = 2'b10;
            iUP_REQ = 1;
            #10;
            iUP_REQ = 0;
            #20;


            iRD_ADDR = 32'h00002004;
            iRD_REQ = 1;
            #10;
            iRD_REQ = 0;
            #20;

            #1;


            check_outputs(1'b0, 32'hDEADBEEF, 1'b1, 14'h0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Invalidate Line");
            test_num = 5;
            reset_dut();


            iWR_ADDR = 32'h00003000;
            iWR_DATA = 512'h5555555555555555555555555555555555555555555555555555555555555555;
            iWR_REQ = 1;
            #10;
            iWR_REQ = 0;
            #20;


            iRD_ADDR = 32'h00003000;
            iREMOVE = 1;
            #10;
            iREMOVE = 0;
            #20;


            iRD_REQ = 1;
            #10;
            iRD_REQ = 0;
            #20;


            #1;



            check_outputs(1'b0, 32'h0, 1'b0, 14'h0, 1'b1, 1'b0, 1'b0);
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
        input expected_oRD_BUSY;
        input [31:0] expected_oRD_DATA;
        input expected_oRD_HIT;
        input [13:0] expected_oRD_MMU_FLAGS;
        input expected_oRD_VALID;
        input expected_oUP_BUSY;
        input expected_oWR_BUSY;
        begin
            if (expected_oRD_BUSY === (expected_oRD_BUSY ^ oRD_BUSY ^ expected_oRD_BUSY) &&
                expected_oRD_DATA === (expected_oRD_DATA ^ oRD_DATA ^ expected_oRD_DATA) &&
                expected_oRD_HIT === (expected_oRD_HIT ^ oRD_HIT ^ expected_oRD_HIT) &&
                expected_oRD_MMU_FLAGS === (expected_oRD_MMU_FLAGS ^ oRD_MMU_FLAGS ^ expected_oRD_MMU_FLAGS) &&
                expected_oRD_VALID === (expected_oRD_VALID ^ oRD_VALID ^ expected_oRD_VALID) &&
                expected_oUP_BUSY === (expected_oUP_BUSY ^ oUP_BUSY ^ expected_oUP_BUSY) &&
                expected_oWR_BUSY === (expected_oWR_BUSY ^ oWR_BUSY ^ expected_oWR_BUSY)) begin
                $display("PASS");
                $display("  Outputs: oRD_BUSY=%b, oRD_DATA=%h, oRD_HIT=%b, oRD_MMU_FLAGS=%h, oRD_VALID=%b, oUP_BUSY=%b, oWR_BUSY=%b",
                         oRD_BUSY, oRD_DATA, oRD_HIT, oRD_MMU_FLAGS, oRD_VALID, oUP_BUSY, oWR_BUSY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oRD_BUSY=%b, oRD_DATA=%h, oRD_HIT=%b, oRD_MMU_FLAGS=%h, oRD_VALID=%b, oUP_BUSY=%b, oWR_BUSY=%b",
                         expected_oRD_BUSY, expected_oRD_DATA, expected_oRD_HIT, expected_oRD_MMU_FLAGS, expected_oRD_VALID, expected_oUP_BUSY, expected_oWR_BUSY);
                $display("  Got:      oRD_BUSY=%b, oRD_DATA=%h, oRD_HIT=%b, oRD_MMU_FLAGS=%h, oRD_VALID=%b, oUP_BUSY=%b, oWR_BUSY=%b",
                         oRD_BUSY, oRD_DATA, oRD_HIT, oRD_MMU_FLAGS, oRD_VALID, oUP_BUSY, oWR_BUSY);
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
        $dumpvars(0,iCLOCK, iRD_ADDR, iRD_BUSY, iRD_REQ, iREMOVE, iUP_ADDR, iUP_DATA, iUP_MASK, iUP_ORDER, iUP_REQ, iWR_ADDR, iWR_DATA, iWR_MMU_FLAGS, iWR_REQ, inRESET, oRD_BUSY, oRD_DATA, oRD_HIT, oRD_MMU_FLAGS, oRD_VALID, oUP_BUSY, oWR_BUSY);
    end

endmodule
