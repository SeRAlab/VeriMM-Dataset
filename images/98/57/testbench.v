`timescale 1ns/1ps

module edge_detector_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg IN_SIG;
    reg RST;
    wire PULSE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detector dut (
        .CLK(CLK),
        .IN_SIG(IN_SIG),
        .RST(RST),
        .PULSE(PULSE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            IN_SIG = 0;
            repeat(2) @(posedge CLK);
            #1 RST = 0;
            repeat(1) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising Edge Detection", test_num);
            reset_dut();

            IN_SIG = 0;
            @(posedge CLK);
            #1 IN_SIG = 1;


            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant Low Signal", test_num);
            reset_dut();

            IN_SIG = 0;
            repeat(3) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling Edge (1 to 0)", test_num);
            reset_dut();


            #1 IN_SIG = 1;
            repeat(2) @(posedge CLK);


            #1 IN_SIG = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse Duration (Single Cycle Only)", test_num);
            reset_dut();


            #1 IN_SIG = 1;
            @(posedge CLK);


            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Rising Edges", test_num);
            reset_dut();


            #1 IN_SIG = 1;
            repeat(2) @(posedge CLK);


            #1 IN_SIG = 0;
            @(posedge CLK);
            #1 IN_SIG = 1;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse Suppression during Reset", test_num);
            reset_dut();

            RST = 1;
            #1 IN_SIG = 0;
            @(posedge CLK);
            #1 IN_SIG = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("edge_detector Testbench");
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
        input expected_PULSE;
        begin
            if (expected_PULSE === (expected_PULSE ^ PULSE ^ expected_PULSE)) begin
                $display("PASS");
                $display("  Outputs: PULSE=%b",
                         PULSE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PULSE=%b",
                         expected_PULSE);
                $display("  Got:      PULSE=%b",
                         PULSE);
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
        $dumpvars(0,CLK, IN_SIG, RST, PULSE);
    end

endmodule
