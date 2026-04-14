`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] DIN;
    reg [3:0] SHIFT;
    reg clk;
    wire [15:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .SHIFT(SHIFT),
        .clk(clk),
        .DOUT(DOUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DIN <= 16'h0;
            SHIFT <= 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left by 1 (SHIFT = 1)", test_num);
            reset_dut();
            DIN <= 16'h0001;
            SHIFT <= 4'sd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left by 4 (SHIFT = 4)", test_num);
            reset_dut();
            DIN <= 16'h00FF;
            SHIFT <= 4'sd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0FF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left by 7 (SHIFT = 7)", test_num);
            reset_dut();
            DIN <= 16'h0001;
            SHIFT <= 4'sd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right by 1 (SHIFT = -1)", test_num);
            reset_dut();
            DIN <= 16'h8000;
            SHIFT <= -4'sd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right by 4 (SHIFT = -4)", test_num);
            reset_dut();
            DIN <= 16'hF000;
            SHIFT <= -4'sd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right by 8 (SHIFT = -8)", test_num);
            reset_dut();
            DIN <= 16'hFFFF;
            SHIFT <= -4'sd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by Zero", test_num);
            reset_dut();
            DIN <= 16'hABCD;
            SHIFT <= 4'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left and check bit loss", test_num);
            reset_dut();
            DIN <= 16'hF000;
            SHIFT <= 4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hC000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right and check bit loss", test_num);
            reset_dut();
            DIN <= 16'h000F;
            SHIFT <= -4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0003);
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
        input [15:0] expected_DOUT;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
        $dumpvars(0,DIN, SHIFT, clk, DOUT);
    end

endmodule
