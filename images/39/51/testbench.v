`timescale 1ns/1ps

module d_latch_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg RESET;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_latch dut (
        .CLK(CLK),
        .D(D),
        .RESET(RESET),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            D = 0;
            #15;
            RESET = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Load Logic 1", test_num);
            reset_dut();
            @(negedge CLK);
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Load Logic 0", test_num);
            reset_dut();

            @(negedge CLK);
            D = 1;
            @(posedge CLK);

            @(negedge CLK);
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Hold value when CLK is low", test_num);
            reset_dut();
            @(negedge CLK);
            D = 1;
            @(posedge CLK);
            @(negedge CLK);
            D = 0;
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Hold value when CLK is high", test_num);
            reset_dut();
            @(negedge CLK);
            D = 1;
            @(posedge CLK);
            #2;
            D = 0;
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Asynchronous Reset Mid-Cycle", test_num);
            reset_dut();
            @(negedge CLK);
            D = 1;
            @(posedge CLK);
            #2;
            RESET = 1;
            #2;
            #1;

            check_outputs(0);
            RESET = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Reset Priority over Data Input", test_num);
            reset_dut();
            @(negedge CLK);
            D = 1;
            RESET = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0);
            RESET = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Multi-cycle Data Stream", test_num);
            reset_dut();
            @(negedge CLK); D = 1;
            @(negedge CLK); D = 0;
            @(negedge CLK); D = 1;
            @(negedge CLK); D = 1;
            @(posedge CLK);
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
        $display("d_latch Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,CLK, D, RESET, Q);
    end

endmodule
