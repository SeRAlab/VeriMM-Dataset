`timescale 1ns/1ps

module SRAM_1bit_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RE;
    reg WE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_1bit dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RE = 0;
        forever #5 RE = ~RE;
    end

        task reset_dut;

        begin


            @(negedge RE);
            WE = 1;
            D = 0;
            @(negedge RE);
            WE = 0;
            D = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %03d: Write and Read 1", test_num);


            @(negedge RE);
            WE = 1; D = 1;
            @(negedge RE);
            WE = 0;


            @(posedge RE);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %03d: Write and Read 0", test_num);


            @(negedge RE);
            WE = 1; D = 1;
            @(negedge RE);


            WE = 1; D = 0;
            @(negedge RE);
            WE = 0;


            @(posedge RE);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %03d: Verify Q Hold when RE=0", test_num);


            @(negedge RE);
            WE = 1; D = 1;
            @(negedge RE);
            WE = 0;
            @(posedge RE);
            #2;


            @(negedge RE);
            WE = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %03d: Data stability (WE isolation)", test_num);


            @(negedge RE);
            WE = 1; D = 1;
            @(negedge RE);


            WE = 0; D = 0;
            #10;


            @(posedge RE);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %03d: Simultaneous Write and Read", test_num);


            @(posedge RE);
            WE = 1; D = 1;
            #2;
            #1;

            check_outputs(1'b1);


            WE = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_1bit Testbench");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,D, RE, WE, Q);
    end

endmodule
