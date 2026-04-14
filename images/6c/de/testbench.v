`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg datain_h;
    reg datain_l;
    reg outclock;
    wire dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclr(aclr),
        .datain_h(datain_h),
        .datain_l(datain_l),
        .outclock(outclock),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        outclock = 0;
        forever #5 outclock = ~outclock;
    end

        task reset_dut;

    begin
        aclr = 1;
        datain_h = 0;
        datain_l = 0;
        #15;
        aclr = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Asynchronous Reset State", test_num);
        reset_dut();


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Capture High Data", test_num);
        reset_dut();
        datain_h = 1;
        datain_l = 1;
        @(posedge outclock);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Capture Low Data", test_num);
        reset_dut();

        datain_h = 1;
        datain_l = 1;
        @(posedge outclock);
        #10;

        datain_h = 0;
        datain_l = 0;
        @(posedge outclock);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Asynchronous Clear Mid-Cycle", test_num);
        reset_dut();
        datain_h = 1;
        datain_l = 1;
        @(posedge outclock);
        #2;

        aclr = 1;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data Persistence", test_num);
        reset_dut();
        datain_h = 1;
        datain_l = 1;
        @(posedge outclock);
        #2;

        datain_h = 0;
        datain_l = 0;
        #2;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Async Clear while Clock Low", test_num);
        reset_dut();
        datain_h = 1;
        datain_l = 1;
        @(posedge outclock);
        #2;
        @(negedge outclock);
        #2;

        aclr = 1;
        #1;
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
        $dumpvars(0,aclr, datain_h, datain_l, outclock, dataout);
    end

endmodule
