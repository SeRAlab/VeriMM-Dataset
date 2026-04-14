`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg SEN;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .CLK(CLK),
        .D(D),
        .SEN(SEN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        SEN = 1;
        D = 0;
        repeat(4) @(negedge CLK);
        SEN = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift in 1111", test_num);
        reset_dut();

        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};

        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift in 1010", test_num);
        reset_dut();

        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b0};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b0};

        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify SEN (Enable) signal", test_num);
        reset_dut();

        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b0, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b0};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b0};

        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow check (5 bits)", test_num);
        reset_dut();

        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b1};
        @(negedge CLK) {SEN, D} = {1'b1, 1'b0};

        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
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
        $dumpvars(0,CLK, D, SEN, Q);
    end

endmodule
