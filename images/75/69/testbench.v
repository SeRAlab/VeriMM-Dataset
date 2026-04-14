`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg tck;
    reg tdi;
    reg tdouser;
    reg tdoutap;
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
        .tck(tck),
        .tdi(tdi),
        .tdouser(tdouser),
        .tdoutap(tdoutap),
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
    task testcase001;

        begin
            test_num = 1;
            tck = 0;
            tdi = 0;
            tms = 0;
            tdoutap = 0;
            tdouser = 0;




            #1;





            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            tck = 0;
            tdi = 0;
            tms = 1;
            tdoutap = 0;
            tdouser = 0;


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            tck = 1;
            tdi = 0;
            tms = 0;
            tdoutap = 0;
            tdouser = 0;


            #1;



            check_outputs(0, 0, 0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            tck = 0;
            tdi = 1;
            tms = 0;
            tdoutap = 0;
            tdouser = 0;


            #1;



            check_outputs(0, 0, 0, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            tck = 0;
            tdi = 0;
            tms = 0;
            tdoutap = 1;
            tdouser = 0;


            #1;



            check_outputs(0, 0, 0, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            tck = 1;
            tdi = 1;
            tms = 1;
            tdoutap = 1;
            tdouser = 0;


            #1;



            check_outputs(0, 0, 0, 1, 1, 1, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            tck = 0; tdi = 0; tms = 0; tdoutap = 0; tdouser = 0;
            #10;
            tck = 1;
            #10;
            tck = 0;
            tdi = 1;
            tdoutap = 1;


            #1;



            check_outputs(0, 0, 0, 0, 1, 1, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            tck = 1;
            tdi = 0;
            tms = 1;
            tdoutap = 0;
            tdouser = 1;




            #1;





            check_outputs(0, 0, 0, 1, 0, 0, 1, 0, 0);
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
            #1; // Small delay for combinational logic to settle
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

endmodule
