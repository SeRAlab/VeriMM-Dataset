`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DselectWire2;
    reg DselectWire3;
    reg clk;
    reg dbusWire1;
    reg dbusWire2;
    wire dbus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DselectWire2(DselectWire2),
        .DselectWire3(DselectWire3),
        .clk(clk),
        .dbusWire1(dbusWire1),
        .dbusWire2(dbusWire2),
        .dbus(dbus)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DselectWire2 = 0;
            DselectWire3 = 0;
            dbusWire1 = 0;
            dbusWire2 = 0;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Propagating '1' from dbusWire1 through the pipeline", test_num);
            reset_dut();
            dbusWire1 = 1'b1;
            DselectWire2 = 1'b1;
            DselectWire3 = 1'b1;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Propagating '0' from dbusWire1 through the pipeline", test_num);
            reset_dut();

            dbusWire1 = 1'b1; DselectWire2 = 1'b1; DselectWire3 = 1'b1;
            repeat(5) @(posedge clk);

            dbusWire1 = 1'b0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting dbusWire2 as pipeline source", test_num);
            reset_dut();
            dbusWire1 = 1'b0;
            dbusWire2 = 1'b1;
            DselectWire2 = 1'b0;
            DselectWire3 = 1'b1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verifying DselectWire3 hold (enable) logic", test_num);
            reset_dut();

            dbusWire1 = 1'b1; DselectWire2 = 1'b1; DselectWire3 = 1'b1;
            repeat(5) @(posedge clk);

            DselectWire3 = 1'b0;
            dbusWire1 = 1'b0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verifying DselectWire2 mux switching", test_num);
            reset_dut();

            dbusWire1 = 1'b1; DselectWire2 = 1'b1; DselectWire3 = 1'b1;
            @(posedge clk);

            #1;
            dbusWire1 = 1'b1;
            dbusWire2 = 1'b0;
            DselectWire2 = 1'b0;
            repeat(5) @(posedge clk);
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
        input expected_dbus;
        begin
            if (expected_dbus === (expected_dbus ^ dbus ^ expected_dbus)) begin
                $display("PASS");
                $display("  Outputs: dbus=%b",
                         dbus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dbus=%b",
                         expected_dbus);
                $display("  Got:      dbus=%b",
                         dbus);
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
        $dumpvars(0,DselectWire2, DselectWire3, clk, dbusWire1, dbusWire2, dbus);
    end

endmodule
