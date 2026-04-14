`timescale 1ns/1ps

module shift_reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DATA_IN;
    reg LOAD;
    reg SHIFT_IN;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_4bit dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .SHIFT_IN(SHIFT_IN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        @(negedge CLK);
        LOAD = 1;
        DATA_IN = 4'b0000;
        SHIFT_IN = 0;
        @(negedge CLK);
        LOAD = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Parallel Load 4'hA");
        reset_dut();
        @(negedge CLK);
        LOAD = 1;
        DATA_IN = 4'hA;
        @(negedge CLK);
        LOAD = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Shift Right 4 times with SHIFT_IN=1");
        reset_dut();
        SHIFT_IN = 1;
        LOAD = 0;
        repeat(4) @(negedge CLK);




        #1;





        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Load 4'b1111 then shift in two 0s");
        reset_dut();
        @(negedge CLK);
        LOAD = 1;
        DATA_IN = 4'b1111;
        @(negedge CLK);
        LOAD = 0;
        SHIFT_IN = 0;
        repeat(2) @(negedge CLK);


        #1;



        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Shift in sequence 1, 0, 1, 1");
        reset_dut();
        LOAD = 0;

        SHIFT_IN = 1; @(negedge CLK);
        SHIFT_IN = 0; @(negedge CLK);
        SHIFT_IN = 1; @(negedge CLK);
        SHIFT_IN = 1; @(negedge CLK);

        #1;


        check_outputs(4'b1101);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Verify LOAD priority over SHIFT");
        reset_dut();
        @(negedge CLK);
        LOAD = 1;
        DATA_IN = 4'h5;
        SHIFT_IN = 1;
        @(negedge CLK);
        LOAD = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_4bit Testbench");
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
        $dumpvars(0,CLK, DATA_IN, LOAD, SHIFT_IN, Q);
    end

endmodule
