`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg resetn;
    wire clk_out1;
    wire clk_out2;
    wire clk_out3;
    wire clk_out4;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .resetn(resetn),
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .clk_out3(clk_out3),
        .clk_out4(clk_out4),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            @(negedge clk_in);
            resetn = 0;

            repeat(5) @(posedge clk_in);
            #1 resetn = 1;
            @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Checking outputs during reset...", test_num);
            resetn = 0;
            repeat(2) @(posedge clk_in);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Checking locked signal assertion after reset...", test_num);
            reset_dut();


            repeat(100) @(posedge clk_in);




            #1;





            check_outputs(clk_out1, clk_out2, clk_out3, clk_out4, 1'b1);
        end
        endtask

    task testcase003;

        reg c1, c2, c3, c4;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Checking clock toggling after locked...", test_num);
            reset_dut();


            wait(locked === 1'b1);
            repeat(5) @(posedge clk_in);


            c1 = clk_out1;
            c2 = clk_out2;
            c3 = clk_out3;
            c4 = clk_out4;


            repeat(20) @(posedge clk_in);



            #1;




            check_outputs(clk_out1, clk_out2, clk_out3, clk_out4, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Checking reset recovery during operation...", test_num);
            reset_dut();


            wait(locked === 1'b1);
            repeat(10) @(posedge clk_in);


            resetn = 0;
            repeat(5) @(posedge clk_in);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);


            #1 resetn = 1;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Long duration stability check...", test_num);
            reset_dut();


            #1000;


            if (locked === 1'b1)
                #1;

                check_outputs(clk_out1, clk_out2, clk_out3, clk_out4, 1'b1);
            else
                #1;

                check_outputs(clk_out1, clk_out2, clk_out3, clk_out4, 1'b1);
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
        input expected_clk_out1;
        input expected_clk_out2;
        input expected_clk_out3;
        input expected_clk_out4;
        input expected_locked;
        begin
            if (expected_clk_out1 === (expected_clk_out1 ^ clk_out1 ^ expected_clk_out1) &&
                expected_clk_out2 === (expected_clk_out2 ^ clk_out2 ^ expected_clk_out2) &&
                expected_clk_out3 === (expected_clk_out3 ^ clk_out3 ^ expected_clk_out3) &&
                expected_clk_out4 === (expected_clk_out4 ^ clk_out4 ^ expected_clk_out4) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: clk_out1=%b, clk_out2=%b, clk_out3=%b, clk_out4=%b, locked=%b",
                         clk_out1, clk_out2, clk_out3, clk_out4, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out1=%b, clk_out2=%b, clk_out3=%b, clk_out4=%b, locked=%b",
                         expected_clk_out1, expected_clk_out2, expected_clk_out3, expected_clk_out4, expected_locked);
                $display("  Got:      clk_out1=%b, clk_out2=%b, clk_out3=%b, clk_out4=%b, locked=%b",
                         clk_out1, clk_out2, clk_out3, clk_out4, locked);
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
        $dumpvars(0,clk_in, resetn, clk_out1, clk_out2, clk_out3, clk_out4, locked);
    end

endmodule
