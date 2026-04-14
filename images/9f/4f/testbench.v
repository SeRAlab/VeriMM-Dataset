`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg LOAD;
    reg RST;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
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
        LOAD = 0;
        D = 4'b0000;
        @(negedge CLK);
        RST = 0;
        @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Parallel Load (4'hA)", test_num);
        reset_dut();
        D = 4'b1010;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;

        #1;


        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load and Shift Right Once", test_num);
        reset_dut();
        D = 4'b1000;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;
        @(negedge CLK);
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load and Shift Right Twice", test_num);
        reset_dut();
        D = 4'b1100;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;
        @(negedge CLK);
        @(negedge CLK);
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift until Empty", test_num);
        reset_dut();
        D = 4'b0001;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;
        @(negedge CLK);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load 4'hF and shift 4 times", test_num);
        reset_dut();
        D = 4'b1111;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;
        @(negedge CLK);
        @(negedge CLK);
        @(negedge CLK);
        @(negedge CLK);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sequential Parallel Loads", test_num);
        reset_dut();
        D = 4'b0101;
        LOAD = 1;
        @(negedge CLK);
        D = 4'b1110;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;
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
        $dumpvars(0,CLK, D, LOAD, RST, Q);
    end

endmodule
