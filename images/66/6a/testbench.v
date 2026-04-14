`timescale 1ns/1ps

module d_ff_8bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_ff_8bit dut (
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
        D = 8'h00;
        #20;
        RST = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic storage (0xA5)", test_num);
        reset_dut();

        @(negedge CLK);
        D = 8'hA5;

        @(posedge CLK);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Storage of 0xFF", test_num);
        reset_dut();

        @(negedge CLK);
        D = 8'hFF;

        @(posedge CLK);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Asynchronous reset mid-cycle", test_num);
        reset_dut();

        @(negedge CLK);
        D = 8'h33;
        @(posedge CLK);
        #2;


        #1;
        RST = 1;
        #1;
        #1;

        check_outputs(8'h00);

        #5;
        RST = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Data change while RST is active", test_num);
        reset_dut();

        RST = 1;
        @(negedge CLK);
        D = 8'hAA;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(8'h00);

        RST = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Consecutive data updates", test_num);
        reset_dut();

        @(negedge CLK);
        D = 8'h11;
        @(posedge CLK);
        #2;

        @(negedge CLK);
        D = 8'h22;
        @(posedge CLK);
        #2;

        @(negedge CLK);
        D = 8'h44;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(8'h44);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_ff_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
