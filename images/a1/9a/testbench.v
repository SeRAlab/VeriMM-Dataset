`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg switch_input;
    wire state;
    wire trans_dn;
    wire trans_up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .switch_input(switch_input),
        .state(state),
        .trans_dn(trans_dn),
        .trans_up(trans_up)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            switch_input = 0;
            repeat (2000) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            test_num = 2;
            reset_dut();
            switch_input = 1;
            timeout = 0;

            while (trans_up !== 1'b1 && timeout < 5000) begin
                @(posedge CLK);
                timeout = timeout + 1;
            end

            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            test_num = 3;
            reset_dut();

            switch_input = 1;
            repeat (2000) @(posedge CLK);


            switch_input = 0;
            timeout = 0;
            while (trans_dn !== 1'b1 && timeout < 5000) begin
                @(posedge CLK);
                timeout = timeout + 1;
            end
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            switch_input = 1;
            repeat (10) @(posedge CLK);
            switch_input = 0;

            repeat (2000) @(posedge CLK);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            switch_input = 1;
            repeat (2000) @(posedge CLK);


            switch_input = 0;
            repeat (10) @(posedge CLK);
            switch_input = 1;

            repeat (2000) @(posedge CLK);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            switch_input = 1; repeat(15)  @(posedge CLK);
            switch_input = 0; repeat(20)  @(posedge CLK);
            switch_input = 1; repeat(10)  @(posedge CLK);
            switch_input = 0; repeat(15)  @(posedge CLK);
            switch_input = 1;

            repeat (2000) @(posedge CLK);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_state;
        input expected_trans_dn;
        input expected_trans_up;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_trans_dn === (expected_trans_dn ^ trans_dn ^ expected_trans_dn) &&
                expected_trans_up === (expected_trans_up ^ trans_up ^ expected_trans_up)) begin
                $display("PASS");
                $display("  Outputs: state=%b, trans_dn=%b, trans_up=%b",
                         state, trans_dn, trans_up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%b, trans_dn=%b, trans_up=%b",
                         expected_state, expected_trans_dn, expected_trans_up);
                $display("  Got:      state=%b, trans_dn=%b, trans_up=%b",
                         state, trans_dn, trans_up);
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
        $dumpvars(0,CLK, switch_input, state, trans_dn, trans_up);
    end

endmodule
