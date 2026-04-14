`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Enable;
    reg [15:0] MaskIn;
    reg [15:0] MaskReset;
    reg [5:0] PieceIn;
    reg PushPop;
    reg Reset;
    wire [15:0] ToSMaskOut;
    wire [5:0] ToSPieceOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Enable(Enable),
        .MaskIn(MaskIn),
        .MaskReset(MaskReset),
        .PieceIn(PieceIn),
        .PushPop(PushPop),
        .Reset(Reset),
        .ToSMaskOut(ToSMaskOut),
        .ToSPieceOut(ToSPieceOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Enable = 0;
            PushPop = 0;
            PieceIn = 0;
            MaskIn = 0;
            MaskReset = 0;
            @(posedge Clk);
            #2 Reset = 0;
            @(posedge Clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single Push", test_num);
            reset_dut();

            @(posedge Clk);
            #1;
            Enable = 1;
            PushPop = 1;
            PieceIn = 6'h1A;
            MaskIn = 16'hA5A5;

            @(posedge Clk);
            #1;
            Enable = 0;

            #1;


            check_outputs(16'hA5A5, 6'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multiple Pushes (LIFO Top)", test_num);
            reset_dut();


            @(posedge Clk);
            #1;
            Enable = 1; PushPop = 1; PieceIn = 6'h01; MaskIn = 16'h1111;
            @(posedge Clk);
            #1;

            PieceIn = 6'h02; MaskIn = 16'h2222;
            @(posedge Clk);
            #1;
            Enable = 0;


            #1;



            check_outputs(16'h2222, 6'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Push and Pop", test_num);
            reset_dut();


            @(posedge Clk);
            #1;
            Enable = 1; PushPop = 1; PieceIn = 6'h11; MaskIn = 16'hAAAA;
            @(posedge Clk);
            #1;

            PieceIn = 6'h22; MaskIn = 16'hBBBB;
            @(posedge Clk);
            #1;

            PushPop = 0;
            @(posedge Clk);
            #1;
            Enable = 0;


            #1;



            check_outputs(16'hAAAA, 6'h11);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Capacity and Deep Pop", test_num);
            reset_dut();


            Enable = 1;
            PushPop = 1;
            for (i = 1; i <= 5; i = i + 1) begin
                PieceIn = i[5:0];
                MaskIn = i[15:0] | (i[15:0] << 8);
                @(posedge Clk);
                #1;
            end


            PushPop = 0;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge Clk);
                #1;
            end
            Enable = 0;


            #1;



            check_outputs(16'h0101, 6'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Enable Signal Verification", test_num);
            reset_dut();

            @(posedge Clk);
            #1;
            Enable = 0;
            PushPop = 1;
            PieceIn = 6'h3F;
            MaskIn = 16'hFFFF;

            @(posedge Clk);
            #1;

            #1;


            check_outputs(16'h0000, 6'h00);
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
        input [15:0] expected_ToSMaskOut;
        input [5:0] expected_ToSPieceOut;
        begin
            if (expected_ToSMaskOut === (expected_ToSMaskOut ^ ToSMaskOut ^ expected_ToSMaskOut) &&
                expected_ToSPieceOut === (expected_ToSPieceOut ^ ToSPieceOut ^ expected_ToSPieceOut)) begin
                $display("PASS");
                $display("  Outputs: ToSMaskOut=%h, ToSPieceOut=%h",
                         ToSMaskOut, ToSPieceOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ToSMaskOut=%h, ToSPieceOut=%h",
                         expected_ToSMaskOut, expected_ToSPieceOut);
                $display("  Got:      ToSMaskOut=%h, ToSPieceOut=%h",
                         ToSMaskOut, ToSPieceOut);
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
        $dumpvars(0,Clk, Enable, MaskIn, MaskReset, PieceIn, PushPop, Reset, ToSMaskOut, ToSPieceOut);
    end

endmodule
