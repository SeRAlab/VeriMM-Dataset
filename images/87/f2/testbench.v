`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rota;
    reg rotb;
    wire rot_direction;
    wire rot_event;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rota(rota),
        .rotb(rotb),
        .rot_direction(rot_direction),
        .rot_event(rot_event)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rota = 0;
            rotb = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asserting rot_event (rota=1, rotb=1)", test_num);
            reset_dut();
            rota = 1;
            rotb = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Deasserting rot_event (rota=0, rotb=0 after high)", test_num);
            reset_dut();

            rota = 1; rotb = 1;
            @(posedge clk); #1;

            rota = 0; rotb = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asserting rot_direction (rota=0, rotb=1)", test_num);
            reset_dut();
            rota = 0;
            rotb = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Direction low (rota=1, rotb=0)", test_num);
            reset_dut();
            rota = 1;
            rotb = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Event hold state while Direction is active", test_num);
            reset_dut();

            rota = 1; rotb = 1;
            @(posedge clk); #1;

            rota = 0; rotb = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Event hold state during rota transition", test_num);
            reset_dut();

            rota = 1; rotb = 1;
            @(posedge clk); #1;

            rota = 1; rotb = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_rot_direction;
        input expected_rot_event;
        begin
            if (expected_rot_direction === (expected_rot_direction ^ rot_direction ^ expected_rot_direction) &&
                expected_rot_event === (expected_rot_event ^ rot_event ^ expected_rot_event)) begin
                $display("PASS");
                $display("  Outputs: rot_direction=%b, rot_event=%b",
                         rot_direction, rot_event);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rot_direction=%b, rot_event=%b",
                         expected_rot_direction, expected_rot_event);
                $display("  Got:      rot_direction=%b, rot_event=%b",
                         rot_direction, rot_event);
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
        $dumpvars(0,clk, rota, rotb, rot_direction, rot_event);
    end

endmodule
