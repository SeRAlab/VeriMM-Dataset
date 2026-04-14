`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .CLK(CLK),
        .D(D),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        D = 0;
        @(posedge CLK);

        #1;
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift in all 1s", test_num);
        reset_dut();
        D = 1;
        repeat(8) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift in alternating 10101010", test_num);
        pattern = 8'b10101010;
        reset_dut();
        for (i = 7; i >= 0; i = i - 1) begin
            D = pattern[i];
            @(posedge CLK);
        end
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift in 00001111", test_num);
        pattern = 8'b00001111;
        reset_dut();
        for (i = 7; i >= 0; i = i - 1) begin
            D = pattern[i];
            @(posedge CLK);
        end
        #1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    integer i;
    reg [15:0] sequence;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift 16 bits (Overflow Verification)", test_num);
        sequence = 16'b11001100_00110011;
        reset_dut();
        for (i = 15; i >= 0; i = i - 1) begin
            D = sequence[i];
            @(posedge CLK);
        end
        #1;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift single bit to MSB", test_num);
        reset_dut();


        D = 1;
        @(posedge CLK);
        D = 0;
        repeat(7) @(posedge CLK);

        #1;

        #1;


        check_outputs(8'h80);
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
        input [7:0] expected_Q;
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
        $dumpvars(0,CLK, D, RST, Q);
    end

endmodule
