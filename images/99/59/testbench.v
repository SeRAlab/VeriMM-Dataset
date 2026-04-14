`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg datain;
    reg inclock;
    wire dataout_h;
    wire dataout_l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclr(aclr),
        .datain(datain),
        .inclock(inclock),
        .dataout_h(dataout_h),
        .dataout_l(dataout_l)
    );

    // Clock generation (10ns period)
    initial begin
        aclr = 0;
        forever #5 aclr = ~aclr;
    end

        task reset_dut;

    begin
        aclr = 1;
        datain = 0;
        #15;
        aclr = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Verifying outputs are 0 after reset", test_num);

        #20;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Data High on Rising, Low on Falling", test_num);


        @(posedge inclock);
        datain = 1;
        @(negedge inclock);
        datain = 0;
        @(posedge inclock);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Data Low on Rising, High on Falling", test_num);

        @(posedge inclock);
        datain = 0;
        @(negedge inclock);
        datain = 1;
        @(posedge inclock);

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Data High on both edges", test_num);

        datain = 1;
        @(posedge inclock);
        @(negedge inclock);
        @(posedge inclock);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Transitioning both outputs to Low", test_num);


        datain = 1;
        @(posedge inclock);
        @(negedge inclock);


        datain = 0;
        @(posedge inclock);
        @(negedge inclock);
        @(posedge inclock);

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Asynchronous Clear while outputs are High", test_num);


        datain = 1;
        @(posedge inclock);
        @(negedge inclock);
        #2;


        aclr = 1;
        #3;

        #1;


        check_outputs(1'b0, 1'b0);
        aclr = 0;
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
        input expected_dataout_h;
        input expected_dataout_l;
        begin
            if (expected_dataout_h === (expected_dataout_h ^ dataout_h ^ expected_dataout_h) &&
                expected_dataout_l === (expected_dataout_l ^ dataout_l ^ expected_dataout_l)) begin
                $display("PASS");
                $display("  Outputs: dataout_h=%b, dataout_l=%b",
                         dataout_h, dataout_l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout_h=%b, dataout_l=%b",
                         expected_dataout_h, expected_dataout_l);
                $display("  Got:      dataout_h=%b, dataout_l=%b",
                         dataout_h, dataout_l);
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
        $dumpvars(0,aclr, datain, inclock, dataout_h, dataout_l);
    end

endmodule
