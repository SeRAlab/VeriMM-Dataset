`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] random_num;
    wire [15:0] password;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .random_num(random_num),
        .password(password)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            random_num = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial random_num assignment", test_num);
            reset_dut();
            random_num = 8'hA5;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hA500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: First counter increment (11 clk cycles)", test_num);
            reset_dut();
            random_num = 8'h12;
            repeat(11) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1201);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Second counter increment (33 clk cycles)", test_num);
            reset_dut();
            random_num = 8'hBC;
            repeat(33) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hBC02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic random_num update", test_num);
            reset_dut();
            random_num = 8'hF0;
            repeat(11) @(posedge clk);
            random_num = 8'h0F;
            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0F01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter rollover 255 -> 11", test_num);
            reset_dut();
            random_num = 8'hEE;




            repeat(5599) @(posedge clk);
            #1;
            if (password[7:0] !== 8'hFF) $display("  Note: Counter at cycle 5599 is %d", password[7:0]);


            repeat(22) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hEE0B);
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
        input [15:0] expected_password;
        begin
            if (expected_password === (expected_password ^ password ^ expected_password)) begin
                $display("PASS");
                $display("  Outputs: password=%h",
                         password);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: password=%h",
                         expected_password);
                $display("  Got:      password=%h",
                         password);
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
        $dumpvars(0,clk, random_num, password);
    end

endmodule
