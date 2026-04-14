`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D0;
    reg D1;
    reg RST;
    reg S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .CLK(CLK),
        .D0(D0),
        .D1(D1),
        .RST(RST),
        .S(S),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            D0 = 0;
            D1 = 0;
            S  = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select D0, Value 0", test_num);
            reset_dut();
            S = 0; D0 = 0; D1 = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select D0, Value 1", test_num);
            reset_dut();
            S = 0; D0 = 1; D1 = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select D1, Value 0", test_num);
            reset_dut();
            S = 1; D0 = 1; D1 = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select D1, Value 1", test_num);
            reset_dut();
            S = 1; D0 = 0; D1 = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Synchronous Reset Priority (Select D0=1, RST=1)", test_num);
            reset_dut();
            S = 0; D0 = 1; D1 = 0;
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Synchronous Reset Priority (Select D1=1, RST=1)", test_num);
            reset_dut();
            S = 1; D0 = 0; D1 = 1;
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verify output is synchronous (no mid-cycle change)", test_num);
            reset_dut();
            S = 0; D0 = 1;
            @(posedge CLK);
            #1;
            D0 = 0;
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
        $display("mux_2to1 Testbench");
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
        input expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
        $dumpvars(0,CLK, D0, D1, RST, S, Y);
    end

endmodule
