`timescale 1ns/1ps

module d_latch_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg EN;
    reg RESET;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_latch dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .RESET(RESET),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            D <= 0;
            EN <= 0;
            RESET <= 1;
            @(posedge CLK);
            #1;
            RESET <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset (Q=0, Q_N=0)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Data 1 (EN=1, D=1)", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1;
            EN <= 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Data 0 (EN=1, D=0)", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1;
            EN <= 1;
            @(posedge CLK);

            @(posedge CLK);
            D <= 0;
            EN <= 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Hold Logic (Hold 1)", test_num);
            reset_dut();


            @(posedge CLK);
            D <= 1;
            EN <= 1;
            @(posedge CLK);


            @(posedge CLK);
            EN <= 0;
            D <= 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1;
            EN <= 1;
            RESET <= 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Timing (No change before edge)", test_num);
            reset_dut();

            @(posedge CLK);
            #1;
            D <= 1;
            EN <= 1;
            #2;


            if (Q === 1'b0 && Q_N === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: Output did not change before rising edge");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Output changed asynchronously");
            end

            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_latch Testbench");
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
        input expected_Q;
        input expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_N=%b",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_N=%b",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%b, Q_N=%b",
                         Q, Q_N);
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
        $dumpvars(0,CLK, D, EN, RESET, Q, Q_N);
    end

endmodule
