`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg execute;
    reg [7:0] opcode;
    wire arm_adv;
    wire arm_basic;
    wire finish_now;
    wire resetCmd;
    wire wrFlags;
    wire wrTrigChain;
    wire wrTrigSelect;
    wire wrsize;
    wire wrspeed;
    wire [3:0] wrtrigcfg;
    wire [3:0] wrtrigmask;
    wire [3:0] wrtrigval;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .execute(execute),
        .opcode(opcode),
        .arm_adv(arm_adv),
        .arm_basic(arm_basic),
        .finish_now(finish_now),
        .resetCmd(resetCmd),
        .wrFlags(wrFlags),
        .wrTrigChain(wrTrigChain),
        .wrTrigSelect(wrTrigSelect),
        .wrsize(wrsize),
        .wrspeed(wrspeed),
        .wrtrigcfg(wrtrigcfg),
        .wrtrigmask(wrtrigmask),
        .wrtrigval(wrtrigval)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            execute = 0;
            opcode = 8'h00;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            opcode = 8'h00;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0, 4'h0, 4'h0, 4'h1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            opcode = 8'h03;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0, 4'h0, 4'h0, 4'h8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            opcode = 8'h05;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0, 4'h0, 4'h2, 4'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            opcode = 8'h0A;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0, 4'h4, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            opcode = 8'h0C;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,1, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            opcode = 8'h0D;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,1,0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            opcode = 8'h0E;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,1,0,0,0,0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            opcode = 8'h11;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,1,0,0,0,0,0,0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            opcode = 8'h13;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1,0,0,0,0,0,0,0,0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            opcode = 8'h14;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,1,0,0,0,0,0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            test_num = 11;
            opcode = 8'h0C;
            execute = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            test_num = 12;
            opcode = 8'hFF;
            execute = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0, 4'h0, 4'h0, 4'h0);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input expected_arm_adv;
        input expected_arm_basic;
        input expected_finish_now;
        input expected_resetCmd;
        input expected_wrFlags;
        input expected_wrTrigChain;
        input expected_wrTrigSelect;
        input expected_wrsize;
        input expected_wrspeed;
        input [3:0] expected_wrtrigcfg;
        input [3:0] expected_wrtrigmask;
        input [3:0] expected_wrtrigval;
        begin
            if (expected_arm_adv === (expected_arm_adv ^ arm_adv ^ expected_arm_adv) &&
                expected_arm_basic === (expected_arm_basic ^ arm_basic ^ expected_arm_basic) &&
                expected_finish_now === (expected_finish_now ^ finish_now ^ expected_finish_now) &&
                expected_resetCmd === (expected_resetCmd ^ resetCmd ^ expected_resetCmd) &&
                expected_wrFlags === (expected_wrFlags ^ wrFlags ^ expected_wrFlags) &&
                expected_wrTrigChain === (expected_wrTrigChain ^ wrTrigChain ^ expected_wrTrigChain) &&
                expected_wrTrigSelect === (expected_wrTrigSelect ^ wrTrigSelect ^ expected_wrTrigSelect) &&
                expected_wrsize === (expected_wrsize ^ wrsize ^ expected_wrsize) &&
                expected_wrspeed === (expected_wrspeed ^ wrspeed ^ expected_wrspeed) &&
                expected_wrtrigcfg === (expected_wrtrigcfg ^ wrtrigcfg ^ expected_wrtrigcfg) &&
                expected_wrtrigmask === (expected_wrtrigmask ^ wrtrigmask ^ expected_wrtrigmask) &&
                expected_wrtrigval === (expected_wrtrigval ^ wrtrigval ^ expected_wrtrigval)) begin
                $display("PASS");
                $display("  Outputs: arm_adv=%b, arm_basic=%b, finish_now=%b, resetCmd=%b, wrFlags=%b, wrTrigChain=%b, wrTrigSelect=%b, wrsize=%b, wrspeed=%b, wrtrigcfg=%h, wrtrigmask=%h, wrtrigval=%h",
                         arm_adv, arm_basic, finish_now, resetCmd, wrFlags, wrTrigChain, wrTrigSelect, wrsize, wrspeed, wrtrigcfg, wrtrigmask, wrtrigval);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: arm_adv=%b, arm_basic=%b, finish_now=%b, resetCmd=%b, wrFlags=%b, wrTrigChain=%b, wrTrigSelect=%b, wrsize=%b, wrspeed=%b, wrtrigcfg=%h, wrtrigmask=%h, wrtrigval=%h",
                         expected_arm_adv, expected_arm_basic, expected_finish_now, expected_resetCmd, expected_wrFlags, expected_wrTrigChain, expected_wrTrigSelect, expected_wrsize, expected_wrspeed, expected_wrtrigcfg, expected_wrtrigmask, expected_wrtrigval);
                $display("  Got:      arm_adv=%b, arm_basic=%b, finish_now=%b, resetCmd=%b, wrFlags=%b, wrTrigChain=%b, wrTrigSelect=%b, wrsize=%b, wrspeed=%b, wrtrigcfg=%h, wrtrigmask=%h, wrtrigval=%h",
                         arm_adv, arm_basic, finish_now, resetCmd, wrFlags, wrTrigChain, wrTrigSelect, wrsize, wrspeed, wrtrigcfg, wrtrigmask, wrtrigval);
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
        $dumpvars(0,clock, execute, opcode, arm_adv, arm_basic, finish_now, resetCmd, wrFlags, wrTrigChain, wrTrigSelect, wrsize, wrspeed, wrtrigcfg, wrtrigmask, wrtrigval);
    end

endmodule
