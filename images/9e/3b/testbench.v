`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg iRST_N;
    reg [15:0] iYCbCr;
    reg iYCbCr_valid;
    wire [7:0] oCb;
    wire [7:0] oCr;
    wire [7:0] oY;
    wire oYCbCr_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iRST_N(iRST_N),
        .iYCbCr(iYCbCr),
        .iYCbCr_valid(iYCbCr_valid),
        .oCb(oCb),
        .oCr(oCr),
        .oY(oY),
        .oYCbCr_valid(oYCbCr_valid)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST_N = 0;
            iYCbCr = 16'h0000;
            iYCbCr_valid = 0;
            @(posedge iCLK);
            #2;
            iRST_N = 1;
            @(posedge iCLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic 2-pixel sequence", test_num);
            reset_dut();


            iYCbCr_valid <= 1;
            iYCbCr <= 16'h2211;
            @(posedge iCLK);


            iYCbCr <= 16'h4433;
            @(posedge iCLK);

            iYCbCr_valid <= 0;
            @(posedge iCLK);
            #1;

            #1;


            check_outputs(8'h22, 8'h44, 8'h33, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 4-pixel sequence check", test_num);
            reset_dut();

            iYCbCr_valid <= 1;
            iYCbCr <= 16'hA110;
            @(posedge iCLK);
            iYCbCr <= 16'hB111;
            @(posedge iCLK);
            iYCbCr <= 16'hA212;
            @(posedge iCLK);
            iYCbCr <= 16'hB213;
            @(posedge iCLK);

            iYCbCr_valid <= 0;
            @(posedge iCLK);
            #1;

            #1;


            check_outputs(8'hA2, 8'hB2, 8'h13, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Intermittent valid flag check", test_num);
            reset_dut();


            iYCbCr_valid <= 1;
            iYCbCr <= 16'h55AA;
            @(posedge iCLK);


            iYCbCr_valid <= 0;
            iYCbCr <= 16'hFFFF;
            @(posedge iCLK);
            @(posedge iCLK);


            iYCbCr_valid <= 1;
            iYCbCr <= 16'h66BB;
            @(posedge iCLK);

            #1;


            #1;



            check_outputs(8'h55, 8'h66, 8'hBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum signal values", test_num);
            reset_dut();

            iYCbCr_valid <= 1;
            iYCbCr <= 16'hFFFF;
            @(posedge iCLK);
            iYCbCr <= 16'hFFFF;
            @(posedge iCLK);

            #1;
            #1;

            check_outputs(8'hFF, 8'hFF, 8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-stream reset", test_num);
            reset_dut();

            iYCbCr_valid <= 1;
            iYCbCr <= 16'h1234;
            @(posedge iCLK);


            iRST_N <= 0;
            @(posedge iCLK);
            iRST_N <= 1;
            @(posedge iCLK);

            #1;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 1'b0);
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
        input [7:0] expected_oCb;
        input [7:0] expected_oCr;
        input [7:0] expected_oY;
        input expected_oYCbCr_valid;
        begin
            if (expected_oCb === (expected_oCb ^ oCb ^ expected_oCb) &&
                expected_oCr === (expected_oCr ^ oCr ^ expected_oCr) &&
                expected_oY === (expected_oY ^ oY ^ expected_oY) &&
                expected_oYCbCr_valid === (expected_oYCbCr_valid ^ oYCbCr_valid ^ expected_oYCbCr_valid)) begin
                $display("PASS");
                $display("  Outputs: oCb=%h, oCr=%h, oY=%h, oYCbCr_valid=%b",
                         oCb, oCr, oY, oYCbCr_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oCb=%h, oCr=%h, oY=%h, oYCbCr_valid=%b",
                         expected_oCb, expected_oCr, expected_oY, expected_oYCbCr_valid);
                $display("  Got:      oCb=%h, oCr=%h, oY=%h, oYCbCr_valid=%b",
                         oCb, oCr, oY, oYCbCr_valid);
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
        $dumpvars(0,iCLK, iRST_N, iYCbCr, iYCbCr_valid, oCb, oCr, oY, oYCbCr_valid);
    end

endmodule
