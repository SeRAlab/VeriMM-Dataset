`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dqs_in;
    reg [4:0] lpf_out;
    reg se;
    reg si;
    reg strobe;
    wire dqs_out;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dqs_in(dqs_in),
        .lpf_out(lpf_out),
        .se(se),
        .si(si),
        .strobe(strobe),
        .dqs_out(dqs_out),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        strobe = 0;
        forever #5 strobe = ~strobe;
    end

        task reset_dut;

        begin
            dqs_in = 0;
            lpf_out = 5'b00000;
            se = 0;
            si = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SI=1, SE=1 -> SO should be 1", test_num);
            reset_dut();
            @(posedge strobe);
            se <= 1'b1;
            si <= 1'b1;
            @(posedge strobe);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SI=0, SE=1 -> SO should be 0", test_num);
            reset_dut();

            @(posedge strobe);
            se <= 1'b1; si <= 1'b1;
            @(posedge strobe);

            se <= 1'b1; si <= 1'b0;
            @(posedge strobe);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SI=1, SE=0 -> SO should remain 0", test_num);
            reset_dut();
            @(posedge strobe);
            se <= 1'b0;
            si <= 1'b1;
            @(posedge strobe);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SO holds value when SE transitions 1->0", test_num);
            reset_dut();

            @(posedge strobe);
            se <= 1'b1; si <= 1'b1;
            @(posedge strobe);

            se <= 1'b0; si <= 1'b0;
            @(posedge strobe);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DQS_IN high -> DQS_OUT should eventually be 1", test_num);
            reset_dut();
            dqs_in = 1'b1;
            repeat(8) @(posedge strobe);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DQS_IN low -> DQS_OUT should eventually be 0", test_num);
            reset_dut();

            dqs_in = 1'b1;
            repeat(8) @(posedge strobe);

            dqs_in = 1'b0;
            repeat(8) @(posedge strobe);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Changing LPF_OUT while performing SI transfer", test_num);
            reset_dut();
            lpf_out = 5'b11111;
            @(posedge strobe);
            se <= 1'b1; si <= 1'b1;
            @(posedge strobe);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_dqs_out;
        input expected_so;
        begin
            if (expected_dqs_out === (expected_dqs_out ^ dqs_out ^ expected_dqs_out) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: dqs_out=%b, so=%b",
                         dqs_out, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dqs_out=%b, so=%b",
                         expected_dqs_out, expected_so);
                $display("  Got:      dqs_out=%b, so=%b",
                         dqs_out, so);
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
        $dumpvars(0,dqs_in, lpf_out, se, si, strobe, dqs_out, so);
    end

endmodule
