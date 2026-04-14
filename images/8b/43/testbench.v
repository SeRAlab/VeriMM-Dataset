`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg aset;
    reg datain_h;
    reg datain_l;
    reg oe;
    reg outclock;
    reg outclocken;
    reg sclr;
    reg sset;
    wire dataout;
    wire oe_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclr(aclr),
        .aset(aset),
        .datain_h(datain_h),
        .datain_l(datain_l),
        .oe(oe),
        .outclock(outclock),
        .outclocken(outclocken),
        .sclr(sclr),
        .sset(sset),
        .dataout(dataout),
        .oe_out(oe_out)
    );

    // Clock generation (10ns period)
    initial begin
        outclock = 0;
        forever #5 outclock = ~outclock;
    end

        task reset_dut;

        begin
            aclr = 1'b1;
            aset = 1'b0;
            datain_h = 1'b0;
            datain_l = 1'b0;
            oe = 1'b0;
            outclocken = 1'b0;
            sclr = 1'b0;
            sset = 1'b0;
            #20;
            aclr = 1'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous Clear", test_num);
            reset_dut();

            datain_h = 1'b1;
            outclocken = 1'b1;
            oe = 1'b1;
            @(posedge outclock);
            #2;
            aclr = 1'b1;
            #5;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous Set", test_num);
            reset_dut();
            oe = 1'b1;
            aset = 1'b1;
            #5;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Data High (Rising Edge)", test_num);
            reset_dut();
            datain_h = 1'b1;
            datain_l = 1'b0;
            outclocken = 1'b1;
            oe = 1'b1;
            @(posedge outclock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Data Low (Falling Edge)", test_num);
            reset_dut();
            datain_h = 1'b1;
            datain_l = 1'b0;
            outclocken = 1'b1;
            oe = 1'b1;
            @(posedge outclock);
            @(negedge outclock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock Enable (Disabled)", test_num);
            reset_dut();

            datain_h = 1'b1;
            outclocken = 1'b1;
            oe = 1'b1;
            @(posedge outclock);
            #2;

            outclocken = 1'b0;
            datain_h = 1'b0;
            @(posedge outclock);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Clear", test_num);
            reset_dut();
            datain_h = 1'b1;
            outclocken = 1'b1;
            oe = 1'b1;
            @(posedge outclock);
            #2;
            sclr = 1'b1;
            @(posedge outclock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Set", test_num);
            reset_dut();
            datain_h = 1'b0;
            outclocken = 1'b1;
            oe = 1'b1;
            @(posedge outclock);
            #2;
            sset = 1'b1;
            @(posedge outclock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Output Enable Check", test_num);
            reset_dut();
            oe = 1'b0;
            #5;


            #1;



            check_outputs(dataout, 1'b0);
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
        input expected_oe_out;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_oe_out === (expected_oe_out ^ oe_out ^ expected_oe_out)) begin
                $display("PASS");
                $display("  Outputs: dataout=%b, oe_out=%b",
                         dataout, oe_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%b, oe_out=%b",
                         expected_dataout, expected_oe_out);
                $display("  Got:      dataout=%b, oe_out=%b",
                         dataout, oe_out);
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
        $dumpvars(0,aclr, aset, datain_h, datain_l, oe, outclock, outclocken, sclr, sset, dataout, oe_out);
    end

endmodule
