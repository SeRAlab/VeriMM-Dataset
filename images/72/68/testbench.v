`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] AD;
    reg CLK;
    reg [3:0] DI;
    reg WRE;
    wire [3:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AD(AD),
        .CLK(CLK),
        .DI(DI),
        .WRE(WRE),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            AD = 4'b0;
            DI = 4'b0;
            WRE = 1'b0;
            repeat(2) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write 4'hA to bit-index 0...", test_num);

            AD = 4'd0;
            DI = 4'b1010;
            WRE = 1'b1;

            @(posedge CLK);
            #2;
            WRE = 1'b0;

            @(negedge CLK);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write 4'h5 to bit-index 3...", test_num);

            AD = 4'd3;
            DI = 4'b0101;
            WRE = 1'b1;

            @(posedge CLK);
            #2;
            WRE = 1'b0;

            @(negedge CLK);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Persistence and Address Switching...", test_num);


            AD = 4'd0; DI = 4'hF; WRE = 1'b1;
            @(posedge CLK);


            #2; AD = 4'd1; DI = 4'h0;
            @(posedge CLK);


            #2; WRE = 1'b0; AD = 4'd0;
            @(negedge CLK);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write Enable (WRE) check...", test_num);


            AD = 4'd2; DI = 4'hC; WRE = 1'b1;
            @(posedge CLK);


            #2; WRE = 1'b0; DI = 4'h3;
            @(posedge CLK);


            @(negedge CLK);
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multi-bit Verification...", test_num);

            AD = 4'd0; DI = 4'h1; WRE = 1'b1; @(posedge CLK);
            #2; AD = 4'd1; DI = 4'h2; @(posedge CLK);
            #2; AD = 4'd2; DI = 4'h4; @(posedge CLK);
            #2; AD = 4'd3; DI = 4'h8; @(posedge CLK);

            #2; WRE = 1'b0; AD = 4'd2;
            @(negedge CLK);
            #1;

            check_outputs(4'h4);
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
        input [3:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,AD, CLK, DI, WRE, DO);
    end

endmodule
