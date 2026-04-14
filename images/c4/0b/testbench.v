`timescale 1ns/1ps

module dff_reset_set_tb;

    // Testbench signals (sequential circuit)
    reg CLK_N;
    reg D;
    reg RESET;
    reg SET;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dff_reset_set dut (
        .CLK_N(CLK_N),
        .D(D),
        .RESET(RESET),
        .SET(SET),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_N = 0;
        forever #5 CLK_N = ~CLK_N;
    end

        task reset_dut;

        begin
            RESET = 1;
            SET = 0;
            D = 0;
            #10;
            RESET = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset", test_num);
            reset_dut();

            D = 1;
            SET = 0;
            RESET = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Asynchronous Set", test_num);
            reset_dut();

            D = 0;
            RESET = 0;
            SET = 1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative Edge Load (D=1)", test_num);
            reset_dut();

            @(posedge CLK_N);
            D = 1;
            SET = 0;
            RESET = 0;

            @(negedge CLK_N);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative Edge Load (D=0)", test_num);
            reset_dut();

            SET = 1; #5; SET = 0;

            @(posedge CLK_N);
            D = 0;
            RESET = 0;
            SET = 0;

            @(negedge CLK_N);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Rising Edge Inactivity", test_num);
            reset_dut();

            @(negedge CLK_N);
            D = 1;
            @(posedge CLK_N);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Async Reset Priority Over Clock", test_num);
            reset_dut();
            @(posedge CLK_N);
            D = 1;
            RESET = 1;
            @(negedge CLK_N);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Async Set Priority Over Clock", test_num);
            reset_dut();
            @(posedge CLK_N);
            D = 0;
            SET = 1;
            @(negedge CLK_N);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Data Stability (No Clock Edge)", test_num);
            reset_dut();

            @(negedge CLK_N); D = 1; @(negedge CLK_N); #2;

            #1;
            D = 0;
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
        $display("dff_reset_set Testbench");
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
        $dumpvars(0,CLK_N, D, RESET, SET, Q);
    end

endmodule
