`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dataIn;
    reg [5:0] opCodeThingIn;
    wire [31:0] dataOut;
    wire [5:0] opCodeThingOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataIn(dataIn),
        .opCodeThingIn(opCodeThingIn),
        .dataOut(dataOut),
        .opCodeThingOut(opCodeThingOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        dataIn = 0;
        opCodeThingIn = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d...", test_num);
        reset_dut();

        dataIn = 32'h12345678;
        opCodeThingIn = 6'h0A;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h12345678, 6'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d...", test_num);
        reset_dut();

        dataIn = 32'hFFFFFFFF;
        opCodeThingIn = 6'h3F;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF, 6'h3F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d...", test_num);
        reset_dut();

        dataIn = 32'hAAAAAAAA;
        opCodeThingIn = 6'h2A;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAAAAAA, 6'h2A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d...", test_num);
        reset_dut();

        dataIn = 32'h55555555;
        opCodeThingIn = 6'h15;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h55555555, 6'h15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d...", test_num);
        reset_dut();

        dataIn = 32'hCAFEBABE;
        opCodeThingIn = 6'h1F;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hCAFEBABE, 6'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d...", test_num);
        reset_dut();


        dataIn = 32'h11111111;
        opCodeThingIn = 6'h11;
        @(posedge clk);
        #2;


        dataIn = 32'hEEEEEEEE;
        opCodeThingIn = 6'h22;
        #2;


        if (dataOut === 32'h11111111 && opCodeThingOut === 6'h11) begin

             @(posedge clk);
             #2;
             #1;

             check_outputs(32'hEEEEEEEE, 6'h22);
        end else begin
            $display("FAIL: Data changed without clock edge");
            fail_count = fail_count + 1;
        end
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
        input [31:0] expected_dataOut;
        input [5:0] expected_opCodeThingOut;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut) &&
                expected_opCodeThingOut === (expected_opCodeThingOut ^ opCodeThingOut ^ expected_opCodeThingOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h, opCodeThingOut=%h",
                         dataOut, opCodeThingOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h, opCodeThingOut=%h",
                         expected_dataOut, expected_opCodeThingOut);
                $display("  Got:      dataOut=%h, opCodeThingOut=%h",
                         dataOut, opCodeThingOut);
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
        $dumpvars(0,clk, dataIn, opCodeThingIn, dataOut, opCodeThingOut);
    end

endmodule
