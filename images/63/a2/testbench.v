`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg mode;
    reg [3:0] spiclkcounter;
    reg spien;
    wire addrt;
    wire modet;
    wire rdld;
    wire rdt;
    wire spioe;
    wire wrt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mode(mode),
        .spiclkcounter(spiclkcounter),
        .spien(spien),
        .addrt(addrt),
        .modet(modet),
        .rdld(rdld),
        .rdt(rdt),
        .spioe(spioe),
        .wrt(wrt)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Disabled State (spien=0)", test_num);
            spien = 0;
            mode = 0;
            spiclkcounter = 4'd7;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Address Phase Start (spien=1, count=0)", test_num);
            spien = 1;
            mode = 0;
            spiclkcounter = 4'd0;

            #1;


            check_outputs(1, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Mode Bit Time (spien=1, count=7)", test_num);
            spien = 1;
            mode = 0;
            spiclkcounter = 4'd7;

            #1;


            check_outputs(1, 1, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Read Data Phase Start (spien=1, mode=0, count=8)", test_num);
            spien = 1;
            mode = 0;
            spiclkcounter = 4'd8;

            #1;


            check_outputs(0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Read Data Phase End/Load (spien=1, mode=0, count=15)", test_num);
            spien = 1;
            mode = 0;
            spiclkcounter = 4'd15;

            #1;


            check_outputs(0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Write Data Phase Start (spien=1, mode=1, count=8)", test_num);
            spien = 1;
            mode = 1;
            spiclkcounter = 4'd8;

            #1;


            check_outputs(0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Write Data Phase Pulse (spien=1, mode=1, count=15)", test_num);
            spien = 1;
            mode = 1;
            spiclkcounter = 4'd15;

            #1;


            check_outputs(0, 0, 0, 0, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Address Phase Mid-way (spien=1, count=4)", test_num);
            spien = 1;
            mode = 1;
            spiclkcounter = 4'd4;

            #1;


            check_outputs(1, 0, 0, 0, 1, 0);
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
        input expected_addrt;
        input expected_modet;
        input expected_rdld;
        input expected_rdt;
        input expected_spioe;
        input expected_wrt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addrt === (expected_addrt ^ addrt ^ expected_addrt) &&
                expected_modet === (expected_modet ^ modet ^ expected_modet) &&
                expected_rdld === (expected_rdld ^ rdld ^ expected_rdld) &&
                expected_rdt === (expected_rdt ^ rdt ^ expected_rdt) &&
                expected_spioe === (expected_spioe ^ spioe ^ expected_spioe) &&
                expected_wrt === (expected_wrt ^ wrt ^ expected_wrt)) begin
                $display("PASS");
                $display("  Outputs: addrt=%b, modet=%b, rdld=%b, rdt=%b, spioe=%b, wrt=%b",
                         addrt, modet, rdld, rdt, spioe, wrt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addrt=%b, modet=%b, rdld=%b, rdt=%b, spioe=%b, wrt=%b",
                         expected_addrt, expected_modet, expected_rdld, expected_rdt, expected_spioe, expected_wrt);
                $display("  Got:      addrt=%b, modet=%b, rdld=%b, rdt=%b, spioe=%b, wrt=%b",
                         addrt, modet, rdld, rdt, spioe, wrt);
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
