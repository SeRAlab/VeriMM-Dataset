`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] X;
    reg [31:0] Y;
    wire [31:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .X(X),
        .Y(Y),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            X = 0;
            Y = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            X = 32'h00000000;
            Y = 32'h00000000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            X = 32'hFFFFFFFF;
            Y = 32'hFFFFFFFF;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            X = 32'h00000000;
            Y = 32'hFFFFFFFF;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            X = 32'hAAAAAAAA;
            Y = 32'h55555555;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            X = 32'h12345678;
            Y = 32'h87654321;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h12345678 ^ 32'h87654321);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            X = 32'hDEADBEEF;
            Y = 32'hCAFEBABE;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hDEADBEEF ^ 32'hCAFEBABE);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            X = 32'h00000001;
            Y = 32'h00000000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            X = 32'h80000000;
            Y = 32'h00000000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            X = 32'hF0F0F0F0;
            Y = 32'h0F0F0F0F;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            X = 32'hABCDDCBA;
            Y = 32'h12344321;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hABCDDCBA ^ 32'h12344321);
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
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
        $dumpvars(0,CLK, X, Y, Dout);
    end

endmodule
