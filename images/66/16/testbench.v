`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg confirm;
    reg [7:0] password;
    reg request;
    reg [7:0] user;
    wire writeRegP;
    wire writeRegQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .confirm(confirm),
        .password(password),
        .request(request),
        .user(user),
        .writeRegP(writeRegP),
        .writeRegQ(writeRegQ)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            request = 0;
            confirm = 0;
            password = 8'h00;
            user = 8'h00;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid Login (MSB=0)", test_num);
            reset_dut();

            user = 8'h5A;
            password = 8'h5A;
            request = 1;
            @(posedge clock);
            #1;
            request = 0;
            confirm = 1;
            @(posedge clock);
            #1;
            confirm = 0;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid Login (MSB=1)", test_num);
            reset_dut();

            user = 8'hA5;
            password = 8'hA5;
            request = 1;
            @(posedge clock);
            #1;
            request = 0;
            confirm = 1;
            @(posedge clock);
            #1;
            confirm = 0;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid Login (Wrong Password)", test_num);
            reset_dut();

            user = 8'h12;
            password = 8'h99;
            request = 1;
            @(posedge clock);
            #1;
            request = 0;
            confirm = 1;
            @(posedge clock);
            #1;
            confirm = 0;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State (No Request)", test_num);
            reset_dut();

            user = 8'hFF;
            password = 8'hFF;
            request = 0;
            repeat(3) @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pending Confirm (Stay in S1)", test_num);
            reset_dut();

            user = 8'h55;
            password = 8'h55;
            request = 1;
            @(posedge clock);
            #1;
            request = 0;
            confirm = 0;
            repeat(2) @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, 1'b0);
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
        input expected_writeRegP;
        input expected_writeRegQ;
        begin
            if (expected_writeRegP === (expected_writeRegP ^ writeRegP ^ expected_writeRegP) &&
                expected_writeRegQ === (expected_writeRegQ ^ writeRegQ ^ expected_writeRegQ)) begin
                $display("PASS");
                $display("  Outputs: writeRegP=%b, writeRegQ=%b",
                         writeRegP, writeRegQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: writeRegP=%b, writeRegQ=%b",
                         expected_writeRegP, expected_writeRegQ);
                $display("  Got:      writeRegP=%b, writeRegQ=%b",
                         writeRegP, writeRegQ);
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
        $dumpvars(0,clock, confirm, password, request, user, writeRegP, writeRegQ);
    end

endmodule
