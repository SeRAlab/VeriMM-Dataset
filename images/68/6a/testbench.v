`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg datainhi;
    reg datainlo;
    reg ena;
    reg muxsel;
    reg sreset;
    wire dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .datainhi(datainhi),
        .datainlo(datainlo),
        .ena(ena),
        .muxsel(muxsel),
        .sreset(sreset),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        areset = 1;
        sreset = 0;
        clk = 0;
        datainlo = 0;
        datainhi = 0;
        muxsel = 0;
        ena = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Asynchronous Reset Priority", test_num);
        reset_dut();


        @(negedge clk);
        ena = 1;
        datainlo = 1;
        datainhi = 1;


        #3;
        areset = 1;
        #2;

        #1;


        check_outputs(1'b0);


        areset = 0;
        #5;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Synchronous Reset", test_num);
        reset_dut();

        @(negedge clk);
        ena = 1;
        sreset = 1;
        datainlo = 1;
        datainhi = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Data Input Low Selection (muxsel=0)", test_num);
        reset_dut();

        @(negedge clk);
        ena = 1;
        muxsel = 0;
        datainlo = 1;
        datainhi = 0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Data Input High Selection (muxsel=1)", test_num);
        reset_dut();

        @(negedge clk);
        ena = 1;
        muxsel = 1;
        datainlo = 0;
        datainhi = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Clock Enable Logic", test_num);
        reset_dut();


        @(negedge clk);
        ena = 1;
        muxsel = 0;
        datainlo = 1;
        @(posedge clk);
        #2;


        @(negedge clk);
        ena = 0;
        datainlo = 0;
        @(posedge clk);
        #2;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Dynamic Mux Selection", test_num);
        reset_dut();

        @(negedge clk);
        ena = 1;
        datainlo = 0;
        datainhi = 1;
        muxsel = 0;

        @(posedge clk);
        #2;

        @(negedge clk);
        muxsel = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Integrated Control Check", test_num);
        reset_dut();

        @(negedge clk);
        ena = 1;
        sreset = 0;
        datainhi = 1;
        datainlo = 1;
        muxsel = 1;

        @(posedge clk);
        #2;


        @(negedge clk);
        datainlo = 0;
        datainhi = 0;
        sreset = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
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
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%b",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%b",
                         expected_dataout);
                $display("  Got:      dataout=%b",
                         dataout);
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
        $dumpvars(0,areset, clk, datainhi, datainlo, ena, muxsel, sreset, dataout);
    end

endmodule
