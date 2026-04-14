`timescale 1ns/1ps

module shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    reg RST;
    reg SHIFT_IN;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .RST(RST),
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
            RST = 1;
            LOAD = 0;
            DATA_IN = 8'h00;
            SHIFT_IN = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Parallel Load Operation (8'hA5)", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 8'hA5;
            @(posedge CLK);
            #1 LOAD = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left Once (Load 8'h01, Shift in 1)", test_num);
            reset_dut();

            LOAD = 1;
            DATA_IN = 8'h01;
            @(posedge CLK);
            #1 LOAD = 0;

            SHIFT_IN = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left 8 Times (Load 8'hFF, Shift in 0)", test_num);
            reset_dut();

            LOAD = 1;
            DATA_IN = 8'hFF;
            @(posedge CLK);
            #1 LOAD = 0;
            SHIFT_IN = 0;

            repeat(8) @(posedge CLK);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Serial Input Sequence (1011)", test_num);
            reset_dut();

            SHIFT_IN = 1; @(posedge CLK);
            SHIFT_IN = 0; @(posedge CLK);
            SHIFT_IN = 1; @(posedge CLK);
            SHIFT_IN = 1; @(posedge CLK);
            #1 #1;
 check_outputs(8'h0B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load Priority Over Shift", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 8'h55;
            SHIFT_IN = 1;
            @(posedge CLK);
            #1 LOAD = 0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify MSB Shift Out", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 8'h80;
            @(posedge CLK);
            #1 LOAD = 0;
            SHIFT_IN = 0;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg Testbench");
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
        $dumpvars(0,CLK, DATA_IN, LOAD, RST, SHIFT_IN, Q);
    end

endmodule
