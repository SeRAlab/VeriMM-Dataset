`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg datain;
    reg devclrn;
    reg devpor;
    reg ena;
    reg update;
    wire dataout;
    wire dutycycledelaymode;
    wire [3:0] dutycycledelaysettings;
    wire [3:0] outputdelaysetting1;
    wire [2:0] outputdelaysetting2;
    wire outputfinedelaysetting1;
    wire outputfinedelaysetting2;
    wire [2:0] outputonlydelaysetting2;
    wire outputonlyfinedelaysetting2;
    wire [3:0] padtoinputregisterdelaysetting;
    wire padtoinputregisterfinedelaysetting;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena),
        .update(update),
        .dataout(dataout),
        .dutycycledelaymode(dutycycledelaymode),
        .dutycycledelaysettings(dutycycledelaysettings),
        .outputdelaysetting1(outputdelaysetting1),
        .outputdelaysetting2(outputdelaysetting2),
        .outputfinedelaysetting1(outputfinedelaysetting1),
        .outputfinedelaysetting2(outputfinedelaysetting2),
        .outputonlydelaysetting2(outputonlydelaysetting2),
        .outputonlyfinedelaysetting2(outputonlyfinedelaysetting2),
        .padtoinputregisterdelaysetting(padtoinputregisterdelaysetting),
        .padtoinputregisterfinedelaysetting(padtoinputregisterfinedelaysetting)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            devclrn = 0;
            devpor = 0;
            ena = 0;
            update = 0;
            datain = 0;
            repeat(2) @(posedge clk);
            #1;
            devclrn = 1;
            devpor = 1;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task shift_sr;

        input [22:0] pattern;
        integer i;
        begin
            for (i = 22; i >= 0; i = i - 1) begin
                datain = pattern[i];
                ena = 1;
                @(posedge clk);
                #2;
            end
            ena = 0;
            datain = 0;
            #2;
        end
        endtask

    task update_pulse;

        begin
            update = 1;
            @(posedge clk);
            #2;
            update = 0;
            @(posedge clk);
            #2;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power-on Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(0, 0, 4'h0, 4'h0, 3'h0, 0, 0, 3'h0, 0, 4'h0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Delay Configuration", test_num);
        reset_dut();
        shift_sr(23'h7FFFFF);
        update_pulse();

        #1;


        check_outputs(1, 1, 4'hF, 4'hF, 3'h7, 1, 1, 3'h7, 1, 4'hF, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Specific Pattern A Configuration", test_num);
        reset_dut();
        shift_sr(23'b1010_0101_101_0_1010_1_0_101_0_1);
        update_pulse();


        #1;



        check_outputs(1, 0, 4'hA, 4'h5, 3'h5, 1, 0, 3'h5, 0, 4'hA, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Specific Pattern B Configuration", test_num);
        reset_dut();
        shift_sr(23'b0101_1010_010_1_0101_0_1_010_1_0);
        update_pulse();


        #1;



        check_outputs(0, 1, 4'h5, 4'hA, 3'h2, 0, 1, 3'h2, 1, 4'h5, 0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable Signal Verification", test_num);
        reset_dut();


        for (i = 0; i < 11; i = i + 1) begin
            datain = 1; ena = 1; @(posedge clk); #2;
        end

        for (i = 0; i < 10; i = i + 1) begin
            datain = 0; ena = 0; @(posedge clk); #2;
        end

        for (i = 0; i < 12; i = i + 1) begin
            datain = 1; ena = 1; @(posedge clk); #2;
        end
        ena = 0;

        update_pulse();

        #1;


        check_outputs(1, 1, 4'hF, 4'hF, 3'h7, 1, 1, 3'h7, 1, 4'hF, 1);
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
        input expected_dataout;
        input expected_dutycycledelaymode;
        input [3:0] expected_dutycycledelaysettings;
        input [3:0] expected_outputdelaysetting1;
        input [2:0] expected_outputdelaysetting2;
        input expected_outputfinedelaysetting1;
        input expected_outputfinedelaysetting2;
        input [2:0] expected_outputonlydelaysetting2;
        input expected_outputonlyfinedelaysetting2;
        input [3:0] expected_padtoinputregisterdelaysetting;
        input expected_padtoinputregisterfinedelaysetting;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_dutycycledelaymode === (expected_dutycycledelaymode ^ dutycycledelaymode ^ expected_dutycycledelaymode) &&
                expected_dutycycledelaysettings === (expected_dutycycledelaysettings ^ dutycycledelaysettings ^ expected_dutycycledelaysettings) &&
                expected_outputdelaysetting1 === (expected_outputdelaysetting1 ^ outputdelaysetting1 ^ expected_outputdelaysetting1) &&
                expected_outputdelaysetting2 === (expected_outputdelaysetting2 ^ outputdelaysetting2 ^ expected_outputdelaysetting2) &&
                expected_outputfinedelaysetting1 === (expected_outputfinedelaysetting1 ^ outputfinedelaysetting1 ^ expected_outputfinedelaysetting1) &&
                expected_outputfinedelaysetting2 === (expected_outputfinedelaysetting2 ^ outputfinedelaysetting2 ^ expected_outputfinedelaysetting2) &&
                expected_outputonlydelaysetting2 === (expected_outputonlydelaysetting2 ^ outputonlydelaysetting2 ^ expected_outputonlydelaysetting2) &&
                expected_outputonlyfinedelaysetting2 === (expected_outputonlyfinedelaysetting2 ^ outputonlyfinedelaysetting2 ^ expected_outputonlyfinedelaysetting2) &&
                expected_padtoinputregisterdelaysetting === (expected_padtoinputregisterdelaysetting ^ padtoinputregisterdelaysetting ^ expected_padtoinputregisterdelaysetting) &&
                expected_padtoinputregisterfinedelaysetting === (expected_padtoinputregisterfinedelaysetting ^ padtoinputregisterfinedelaysetting ^ expected_padtoinputregisterfinedelaysetting)) begin
                $display("PASS");
                $display("  Outputs: dataout=%b, dutycycledelaymode=%b, dutycycledelaysettings=%h, outputdelaysetting1=%h, outputdelaysetting2=%h, outputfinedelaysetting1=%b, outputfinedelaysetting2=%b, outputonlydelaysetting2=%h, outputonlyfinedelaysetting2=%b, padtoinputregisterdelaysetting=%h, padtoinputregisterfinedelaysetting=%b",
                         dataout, dutycycledelaymode, dutycycledelaysettings, outputdelaysetting1, outputdelaysetting2, outputfinedelaysetting1, outputfinedelaysetting2, outputonlydelaysetting2, outputonlyfinedelaysetting2, padtoinputregisterdelaysetting, padtoinputregisterfinedelaysetting);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%b, dutycycledelaymode=%b, dutycycledelaysettings=%h, outputdelaysetting1=%h, outputdelaysetting2=%h, outputfinedelaysetting1=%b, outputfinedelaysetting2=%b, outputonlydelaysetting2=%h, outputonlyfinedelaysetting2=%b, padtoinputregisterdelaysetting=%h, padtoinputregisterfinedelaysetting=%b",
                         expected_dataout, expected_dutycycledelaymode, expected_dutycycledelaysettings, expected_outputdelaysetting1, expected_outputdelaysetting2, expected_outputfinedelaysetting1, expected_outputfinedelaysetting2, expected_outputonlydelaysetting2, expected_outputonlyfinedelaysetting2, expected_padtoinputregisterdelaysetting, expected_padtoinputregisterfinedelaysetting);
                $display("  Got:      dataout=%b, dutycycledelaymode=%b, dutycycledelaysettings=%h, outputdelaysetting1=%h, outputdelaysetting2=%h, outputfinedelaysetting1=%b, outputfinedelaysetting2=%b, outputonlydelaysetting2=%h, outputonlyfinedelaysetting2=%b, padtoinputregisterdelaysetting=%h, padtoinputregisterfinedelaysetting=%b",
                         dataout, dutycycledelaymode, dutycycledelaysettings, outputdelaysetting1, outputdelaysetting2, outputfinedelaysetting1, outputfinedelaysetting2, outputonlydelaysetting2, outputonlyfinedelaysetting2, padtoinputregisterdelaysetting, padtoinputregisterfinedelaysetting);
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
        $dumpvars(0,clk, datain, devclrn, devpor, ena, update, dataout, dutycycledelaymode, dutycycledelaysettings, outputdelaysetting1, outputdelaysetting2, outputfinedelaysetting1, outputfinedelaysetting2, outputonlydelaysetting2, outputonlyfinedelaysetting2, padtoinputregisterdelaysetting, padtoinputregisterfinedelaysetting);
    end

endmodule
