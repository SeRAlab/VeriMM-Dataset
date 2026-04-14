`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg DIR;
    reg LOAD;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .CLK(CLK),
        .D(D),
        .DIR(DIR),
        .LOAD(LOAD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        D = 8'h00;
        LOAD = 1;
        DIR = 0;
        @(posedge CLK);
        #1;
        LOAD = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Parallel Load", test_num);
        reset_dut();
        D = 8'hA5;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Right One Bit", test_num);
        reset_dut();

        D = 8'h80;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        DIR = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Left One Bit", test_num);
        reset_dut();

        D = 8'h01;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        DIR = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multi-bit Shift Right (4 positions)", test_num);
        reset_dut();
        D = 8'hF0;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        DIR = 0;
        repeat(4) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multi-bit Shift Left (4 positions)", test_num);
        reset_dut();
        D = 8'h0F;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        DIR = 1;
        repeat(4) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift out all bits (Right)", test_num);
        reset_dut();
        D = 8'h01;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        DIR = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Direction Switching Logic", test_num);
        reset_dut();
        D = 8'h10;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        DIR = 1;
        @(posedge CLK);
        #1;
        DIR = 1;
        @(posedge CLK);
        #1;
        DIR = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'h20);
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
        $dumpvars(0,CLK, D, DIR, LOAD, Q);
    end

endmodule
