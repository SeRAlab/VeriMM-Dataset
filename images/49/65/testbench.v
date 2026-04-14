`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [6:0] regIdRm;
    reg [6:0] regIdRn;
    reg [6:0] regIdRs;
    reg [6:0] regIdRt;
    reg [31:0] regSrVal;
    reg [31:0] regValRn;
    reg reset;
    wire [31:0] regValRm;
    wire [31:0] regValRs;
    wire [31:0] regValRt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .regIdRm(regIdRm),
        .regIdRn(regIdRn),
        .regIdRs(regIdRs),
        .regIdRt(regIdRt),
        .regSrVal(regSrVal),
        .regValRn(regValRn),
        .reset(reset),
        .regValRm(regValRm),
        .regValRs(regValRs),
        .regValRt(regValRt)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            regIdRs = 0;
            regIdRt = 0;
            regIdRm = 0;
            regIdRn = 0;
            regValRn = 0;
            regSrVal = 0;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Bank LA)", test_num);


            regIdRn = 7'd5;
            regValRn = 32'hDEADBEEF;
            @(posedge clock);
            #1;


            regIdRs = 7'd5;
            regIdRt = 7'd5;
            regIdRm = 7'd5;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple writes and simultaneous reads", test_num);


            regIdRn = 7'd10;
            regValRn = 32'h11111111;
            @(posedge clock);
            #1;


            regIdRn = 7'd20;
            regValRn = 32'h22222222;
            @(posedge clock);
            #1;


            regIdRn = 7'd40;
            regValRn = 32'h44444444;
            @(posedge clock);
            #1;


            regIdRm = 7'd10;
            regIdRs = 7'd20;
            regIdRt = 7'd40;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h11111111, 32'h22222222, 32'h44444444);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Bank H access", test_num);


            regIdRn = 7'd60;
            regValRn = 32'hABCDE001;
            @(posedge clock);
            #1;


            regIdRs = 7'd60;
            regIdRt = 7'd0;
            regIdRm = 7'd60;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hABCDE001, 32'hABCDE001, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);


            regIdRn = 7'd1;
            regValRn = 32'hFFFFFFFF;
            @(posedge clock);
            #1;


            reset = 1;
            @(posedge clock);
            #1 reset = 0;


            regIdRs = 7'd1;
            regIdRt = 7'd1;
            regIdRm = 7'd1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential overwrites", test_num);


            regIdRn = 7'd15;
            regValRn = 32'hAAAA5555;
            @(posedge clock);
            #1;


            regIdRn = 7'd15;
            regValRn = 32'h5555AAAA;
            @(posedge clock);
            #1;


            regIdRs = 7'd15;
            regIdRt = 7'd15;
            regIdRm = 7'd15;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h5555AAAA, 32'h5555AAAA, 32'h5555AAAA);
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
        input [31:0] expected_regValRm;
        input [31:0] expected_regValRs;
        input [31:0] expected_regValRt;
        begin
            if (expected_regValRm === (expected_regValRm ^ regValRm ^ expected_regValRm) &&
                expected_regValRs === (expected_regValRs ^ regValRs ^ expected_regValRs) &&
                expected_regValRt === (expected_regValRt ^ regValRt ^ expected_regValRt)) begin
                $display("PASS");
                $display("  Outputs: regValRm=%h, regValRs=%h, regValRt=%h",
                         regValRm, regValRs, regValRt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regValRm=%h, regValRs=%h, regValRt=%h",
                         expected_regValRm, expected_regValRs, expected_regValRt);
                $display("  Got:      regValRm=%h, regValRs=%h, regValRt=%h",
                         regValRm, regValRs, regValRt);
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
        $dumpvars(0,clock, regIdRm, regIdRn, regIdRs, regIdRt, regSrVal, regValRn, reset, regValRm, regValRs, regValRt);
    end

endmodule
