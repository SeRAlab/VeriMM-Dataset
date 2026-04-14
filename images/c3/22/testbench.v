`timescale 1ns/1ps

module dff_async_reset_enable_tb;

    // Testbench signals (sequential circuit)
    reg A1;
    reg A2;
    reg B1;
    reg clk;
    reg enable;
    reg reset_n;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dff_async_reset_enable dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .clk(clk),
        .enable(enable),
        .reset_n(reset_n),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            A1 = 0;
            A2 = 0;
            B1 = 0;
            enable = 0;
            #15;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load Logic High (A1=1, A2=1, Enable=1)", test_num);
            reset_dut();
            A1 = 1;
            A2 = 1;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load Logic Low (A1=0, A2=1, Enable=1)", test_num);
            reset_dut();

            A1 = 1; A2 = 1; enable = 1;
            @(posedge clk);
            #2;

            A1 = 0; A2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify Enable=0 Holds State", test_num);
            reset_dut();

            A1 = 1; A2 = 1; enable = 1;
            @(posedge clk);
            #2;

            enable = 0;
            A1 = 0; A2 = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify Asynchronous Reset Priority", test_num);
            reset_dut();

            A1 = 1; A2 = 1; enable = 1;
            @(posedge clk);
            #2;

            reset_n = 0;
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify B1 Input Independence", test_num);
            reset_dut();
            A1 = 1;
            A2 = 1;
            B1 = 1;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dff_async_reset_enable Testbench");
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
        input expected_X;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
        $dumpvars(0,A1, A2, B1, clk, enable, reset_n, X);
    end

endmodule
