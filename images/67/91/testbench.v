`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg CE;
    reg CINVCTRL;
    reg [4:0] CNTVALUEIN;
    reg DATAIN;
    reg IDATAIN;
    reg INC;
    reg LD;
    reg LDPIPEEN;
    reg REGRST;
    wire [4:0] CNTVALUEOUT;
    wire DATAOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CE(CE),
        .CINVCTRL(CINVCTRL),
        .CNTVALUEIN(CNTVALUEIN),
        .DATAIN(DATAIN),
        .IDATAIN(IDATAIN),
        .INC(INC),
        .LD(LD),
        .LDPIPEEN(LDPIPEEN),
        .REGRST(REGRST),
        .CNTVALUEOUT(CNTVALUEOUT),
        .DATAOUT(DATAOUT)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

        begin
            CINVCTRL = 0;
            CNTVALUEIN = 5'b0;
            DATAIN = 0;
            IDATAIN = 0;
            INC = 0;
            LD = 0;
            LDPIPEEN = 0;
            REGRST = 1;
            CE = 0;
            repeat(2) @(posedge C);
            #1;
            REGRST = 0;
            @(posedge C);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            IDATAIN = 1'b1;
            #10;

            #1;


            check_outputs(5'b00000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            IDATAIN = 1'b0;
            CNTVALUEIN = 5'h0A;
            LD = 1;
            @(posedge C);
            #2;
            LD = 0;
            @(posedge C);
            #1;

            #1;


            check_outputs(5'h0A, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            CNTVALUEIN = 5'h10;
            LD = 1;
            @(posedge C);
            #1;
            LD = 0;

            INC = 1;
            CE = 1;
            @(posedge C);
            #2;
            CE = 0;
            IDATAIN = 1'b1;
            #5;

            #1;


            check_outputs(5'h11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            CNTVALUEIN = 5'h05;
            LD = 1;
            @(posedge C);
            #1;
            LD = 0;

            INC = 0;
            CE = 1;
            @(posedge C);
            #2;
            CE = 0;
            IDATAIN = 1'b0;
            #5;

            #1;


            check_outputs(5'h04, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            CNTVALUEIN = 5'h1F;
            LD = 1;
            @(posedge C);
            #1;
            LD = 0;

            INC = 1;
            CE = 0;
            @(posedge C);
            @(posedge C);
            #2;

            #1;


            check_outputs(5'h1F, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            LDPIPEEN = 1;
            CNTVALUEIN = 5'h07;
            LD = 1;
            @(posedge C);
            #1;
            LD = 0;

            @(posedge C);
            #2;
            IDATAIN = 1'b1;
            #5;
            #1;

            check_outputs(5'h07, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            CINVCTRL = 1;
            CNTVALUEIN = 5'h12;
            LD = 1;
            @(posedge C);
            #2;
            LD = 0;
            @(posedge C);
            #2;
            #1;

            check_outputs(5'h12, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            CNTVALUEIN = 5'h1F;
            LD = 1;
            @(posedge C);
            #1;
            LD = 0;

            INC = 1;
            CE = 1;
            @(posedge C);
            #2;
            CE = 0;

            #1;


            check_outputs(5'h00, 1'b0);
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
        testcase008();
        
        
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
        input [4:0] expected_CNTVALUEOUT;
        input expected_DATAOUT;
        begin
            if (expected_CNTVALUEOUT === (expected_CNTVALUEOUT ^ CNTVALUEOUT ^ expected_CNTVALUEOUT) &&
                expected_DATAOUT === (expected_DATAOUT ^ DATAOUT ^ expected_DATAOUT)) begin
                $display("PASS");
                $display("  Outputs: CNTVALUEOUT=%h, DATAOUT=%b",
                         CNTVALUEOUT, DATAOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CNTVALUEOUT=%h, DATAOUT=%b",
                         expected_CNTVALUEOUT, expected_DATAOUT);
                $display("  Got:      CNTVALUEOUT=%h, DATAOUT=%b",
                         CNTVALUEOUT, DATAOUT);
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
        $dumpvars(0,C, CE, CINVCTRL, CNTVALUEIN, DATAIN, IDATAIN, INC, LD, LDPIPEEN, REGRST, CNTVALUEOUT, DATAOUT);
    end

endmodule
