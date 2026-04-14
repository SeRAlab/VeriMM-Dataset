`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cpm_n;
    reg dos_turn_off;
    reg dos_turn_on;
    reg fclk;
    reg rst_n;
    wire dos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cpm_n(cpm_n),
        .dos_turn_off(dos_turn_off),
        .dos_turn_on(dos_turn_on),
        .fclk(fclk),
        .rst_n(rst_n),
        .dos(dos)
    );

    // Clock generation (10ns period)
    initial begin
        fclk = 0;
        forever #5 fclk = ~fclk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            cpm_n = 1;
            dos_turn_off = 0;
            dos_turn_on = 0;
            #10;
            rst_n = 1;
            @(posedge fclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Turn OFF (cpm_n=1)", test_num);
            reset_dut();

            cpm_n = 1'b1;
            dos_turn_off = 1'b1;
            @(posedge fclk);
            #1;
            dos_turn_off = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Turn ON after OFF", test_num);
            reset_dut();


            cpm_n = 1'b1;
            dos_turn_off = 1'b1;
            @(posedge fclk);
            #1;
            dos_turn_off = 1'b0;


            dos_turn_on = 1'b1;
            @(posedge fclk);
            #1;
            dos_turn_on = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: cpm_n LOW override", test_num);
            reset_dut();


            cpm_n = 1'b0;
            dos_turn_off = 1'b1;
            @(posedge fclk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maintain state (Hold LOW)", test_num);
            reset_dut();


            cpm_n = 1'b1;
            dos_turn_off = 1'b1;
            @(posedge fclk);
            #1;
            dos_turn_off = 1'b0;


            @(posedge fclk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous turn_on and turn_off", test_num);
            reset_dut();

            cpm_n = 1'b1;
            dos_turn_on = 1'b1;
            dos_turn_off = 1'b1;
            @(posedge fclk);
            #1;



            #1;




            check_outputs(1'b1);
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
        input expected_dos;
        begin
            if (expected_dos === (expected_dos ^ dos ^ expected_dos)) begin
                $display("PASS");
                $display("  Outputs: dos=%b",
                         dos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dos=%b",
                         expected_dos);
                $display("  Got:      dos=%b",
                         dos);
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
        $dumpvars(0,cpm_n, dos_turn_off, dos_turn_on, fclk, rst_n, dos);
    end

endmodule
