`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rcv;
    reg usb_clk;
    reg vm;
    reg vp;
    wire rcv_s;
    wire vm_s;
    wire vp_s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rcv(rcv),
        .usb_clk(usb_clk),
        .vm(vm),
        .vp(vp),
        .rcv_s(rcv_s),
        .vm_s(vm_s),
        .vp_s(vp_s)
    );

    // Clock generation (10ns period)
    initial begin
        usb_clk = 0;
        forever #5 usb_clk = ~usb_clk;
    end

        task reset_dut;

        begin
            rcv = 0;
            vp  = 0;
            vm  = 0;

            repeat(10) @(posedge usb_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Inputs All Zeros", test_num);
            reset_dut();
            rcv = 0; vp = 0; vm = 0;
            repeat(10) @(posedge usb_clk);
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: RCV High Only", test_num);
            reset_dut();
            rcv = 1; vp = 0; vm = 0;
            repeat(10) @(posedge usb_clk);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: VP High Only", test_num);
            reset_dut();
            rcv = 0; vp = 1; vm = 0;
            repeat(10) @(posedge usb_clk);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: VM High Only", test_num);
            reset_dut();
            rcv = 0; vp = 0; vm = 1;
            repeat(10) @(posedge usb_clk);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: RCV and VP High", test_num);
            reset_dut();
            rcv = 1; vp = 1; vm = 0;
            repeat(10) @(posedge usb_clk);
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: RCV and VM High", test_num);
            reset_dut();
            rcv = 1; vp = 0; vm = 1;
            repeat(10) @(posedge usb_clk);
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Inputs High", test_num);
            reset_dut();
            rcv = 1; vp = 1; vm = 1;
            repeat(10) @(posedge usb_clk);
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Transition High to VM", test_num);
            reset_dut();

            rcv = 1; vp = 1; vm = 1;
            repeat(10) @(posedge usb_clk);

            rcv = 0; vp = 0; vm = 1;
            repeat(10) @(posedge usb_clk);
            #1;

            check_outputs(0, 1, 0);
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
        input expected_rcv_s;
        input expected_vm_s;
        input expected_vp_s;
        begin
            if (expected_rcv_s === (expected_rcv_s ^ rcv_s ^ expected_rcv_s) &&
                expected_vm_s === (expected_vm_s ^ vm_s ^ expected_vm_s) &&
                expected_vp_s === (expected_vp_s ^ vp_s ^ expected_vp_s)) begin
                $display("PASS");
                $display("  Outputs: rcv_s=%b, vm_s=%b, vp_s=%b",
                         rcv_s, vm_s, vp_s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rcv_s=%b, vm_s=%b, vp_s=%b",
                         expected_rcv_s, expected_vm_s, expected_vp_s);
                $display("  Got:      rcv_s=%b, vm_s=%b, vp_s=%b",
                         rcv_s, vm_s, vp_s);
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
        $dumpvars(0,rcv, usb_clk, vm, vp, rcv_s, vm_s, vp_s);
    end

endmodule
