`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
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
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing dqs_in to dqs_out propagation (High)", test_num);

        dqs_in = 0; lpf_out = 5'b00000; se = 0; si = 0; strobe = 0;
        #10;

        dqs_in = 1;
        lpf_out = 5'b01010;
        #20;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing dqs_in to dqs_out propagation (Low)", test_num);
        dqs_in = 1; lpf_out = 5'b11111; se = 0; si = 0; strobe = 0;
        #10;
        dqs_in = 0;
        #20;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing scan path (se=1, si=1)", test_num);
        dqs_in = 0; lpf_out = 5'b00000; se = 0; si = 0; strobe = 0;
        #10;
        se = 1;
        si = 1;
        #20;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing scan path (se=1, si=0)", test_num);
        dqs_in = 0; lpf_out = 5'b00000; se = 1; si = 1; strobe = 0;
        #10;
        si = 0;
        #20;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing strobe and LPF configuration", test_num);
        dqs_in = 1;
        lpf_out = 5'b10101;
        se = 0;
        si = 0;
        strobe = 1;
        #10;
        strobe = 0;
        #20;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing simultaneous activity", test_num);
        dqs_in = 1;
        se = 1;
        si = 1;
        lpf_out = 5'b00111;
        strobe = 1;
        #20;
        #1;

        check_outputs(1'b1, 1'b1);
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
            #1; // Small delay for combinational logic to settle
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

endmodule
