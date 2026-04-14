`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_A;
    reg CLK_A_SEND;
    reg CLK_B;
    reg CLK_B_SEND;
    wire CLK_A_RECV;
    wire CLK_B_RECV;
    wire ERR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_A(CLK_A),
        .CLK_A_SEND(CLK_A_SEND),
        .CLK_B(CLK_B),
        .CLK_B_SEND(CLK_B_SEND),
        .CLK_A_RECV(CLK_A_RECV),
        .CLK_B_RECV(CLK_B_RECV),
        .ERR(ERR)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_A = 0;
        forever #5 CLK_A = ~CLK_A;
    end

        task reset_dut;

        begin
            CLK_A_SEND = 0;
            CLK_B_SEND = 0;


            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: All inputs zero", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Both domains sending 1", test_num);
            reset_dut();
            CLK_A_SEND = 1;
            CLK_B_SEND = 1;

            #100;



            #1;




            check_outputs(1, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Mismatch (A=1, B=0)", test_num);
            reset_dut();
            CLK_A_SEND = 1;
            CLK_B_SEND = 0;
            #100;



            #1;




            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Mismatch (A=0, B=1)", test_num);
            reset_dut();
            CLK_A_SEND = 0;
            CLK_B_SEND = 1;
            #100;



            #1;




            check_outputs(1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Return to Idle (1->0 transition)", test_num);
            reset_dut();

            CLK_A_SEND = 1;
            CLK_B_SEND = 1;
            #100;
            CLK_A_SEND = 0;
            CLK_B_SEND = 0;
            #100;
            #1;

            check_outputs(0, 0, 0);
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
        input expected_CLK_A_RECV;
        input expected_CLK_B_RECV;
        input expected_ERR;
        begin
            if (expected_CLK_A_RECV === (expected_CLK_A_RECV ^ CLK_A_RECV ^ expected_CLK_A_RECV) &&
                expected_CLK_B_RECV === (expected_CLK_B_RECV ^ CLK_B_RECV ^ expected_CLK_B_RECV) &&
                expected_ERR === (expected_ERR ^ ERR ^ expected_ERR)) begin
                $display("PASS");
                $display("  Outputs: CLK_A_RECV=%b, CLK_B_RECV=%b, ERR=%b",
                         CLK_A_RECV, CLK_B_RECV, ERR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK_A_RECV=%b, CLK_B_RECV=%b, ERR=%b",
                         expected_CLK_A_RECV, expected_CLK_B_RECV, expected_ERR);
                $display("  Got:      CLK_A_RECV=%b, CLK_B_RECV=%b, ERR=%b",
                         CLK_A_RECV, CLK_B_RECV, ERR);
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
        $dumpvars(0,CLK_A, CLK_A_SEND, CLK_B, CLK_B_SEND, CLK_A_RECV, CLK_B_RECV, ERR);
    end

endmodule
