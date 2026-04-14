`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ntrst;
    reg tck;
    reg tdi;
    reg tms;
    wire clkdruser;
    wire runidleuser;
    wire shiftuser;
    wire tckutap;
    wire tdiutap;
    wire tdo;
    wire tmsutap;
    wire updateuser;
    wire usr1user;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ntrst(ntrst),
        .tck(tck),
        .tdi(tdi),
        .tms(tms),
        .clkdruser(clkdruser),
        .runidleuser(runidleuser),
        .shiftuser(shiftuser),
        .tckutap(tckutap),
        .tdiutap(tdiutap),
        .tdo(tdo),
        .tmsutap(tmsutap),
        .updateuser(updateuser),
        .usr1user(usr1user)
    );

    // Clock generation (10ns period)
    initial begin
        tck = 0;
        forever #5 tck = ~tck;
    end

        task reset_dut;

        begin
            ntrst = 0;
            tms = 1;
            tdi = 0;
            repeat (5) @(posedge tck);
            ntrst = 1;
            @(posedge tck);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();



            #1;




            check_outputs(0, 0, 0, 1, 0, 1'bz, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            tms = 0;
            tdi = 1;
            @(posedge tck);
            #1;

            #1;


            check_outputs(0, 0, 0, 1, 1, 1'bz, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            tms = 1;
            tdi = 1;
            @(posedge tck);
            #1;
            #1;

            check_outputs(0, 0, 0, 1, 1, 1'bz, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            tms = 0;
            tdi = 0;
            @(negedge tck);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 1'bz, 0, 0, 0);
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
        input expected_clkdruser;
        input expected_runidleuser;
        input expected_shiftuser;
        input expected_tckutap;
        input expected_tdiutap;
        input expected_tdo;
        input expected_tmsutap;
        input expected_updateuser;
        input expected_usr1user;
        begin
            if (expected_clkdruser === (expected_clkdruser ^ clkdruser ^ expected_clkdruser) &&
                expected_runidleuser === (expected_runidleuser ^ runidleuser ^ expected_runidleuser) &&
                expected_shiftuser === (expected_shiftuser ^ shiftuser ^ expected_shiftuser) &&
                expected_tckutap === (expected_tckutap ^ tckutap ^ expected_tckutap) &&
                expected_tdiutap === (expected_tdiutap ^ tdiutap ^ expected_tdiutap) &&
                expected_tdo === (expected_tdo ^ tdo ^ expected_tdo) &&
                expected_tmsutap === (expected_tmsutap ^ tmsutap ^ expected_tmsutap) &&
                expected_updateuser === (expected_updateuser ^ updateuser ^ expected_updateuser) &&
                expected_usr1user === (expected_usr1user ^ usr1user ^ expected_usr1user)) begin
                $display("PASS");
                $display("  Outputs: clkdruser=%b, runidleuser=%b, shiftuser=%b, tckutap=%b, tdiutap=%b, tdo=%b, tmsutap=%b, updateuser=%b, usr1user=%b",
                         clkdruser, runidleuser, shiftuser, tckutap, tdiutap, tdo, tmsutap, updateuser, usr1user);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkdruser=%b, runidleuser=%b, shiftuser=%b, tckutap=%b, tdiutap=%b, tdo=%b, tmsutap=%b, updateuser=%b, usr1user=%b",
                         expected_clkdruser, expected_runidleuser, expected_shiftuser, expected_tckutap, expected_tdiutap, expected_tdo, expected_tmsutap, expected_updateuser, expected_usr1user);
                $display("  Got:      clkdruser=%b, runidleuser=%b, shiftuser=%b, tckutap=%b, tdiutap=%b, tdo=%b, tmsutap=%b, updateuser=%b, usr1user=%b",
                         clkdruser, runidleuser, shiftuser, tckutap, tdiutap, tdo, tmsutap, updateuser, usr1user);
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
        $dumpvars(0,ntrst, tck, tdi, tms, clkdruser, runidleuser, shiftuser, tckutap, tdiutap, tdo, tmsutap, updateuser, usr1user);
    end

endmodule
