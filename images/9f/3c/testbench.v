`timescale 1ns/1ps

module reg_with_load_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg LOAD;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_with_load dut (
        .CLK(CLK),
        .D(D),
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
        LOAD <= 1;
        D <= 4'h0;
        @(posedge CLK);
        LOAD <= 0;
        D <= 4'h0;
        @(posedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Loading 4'hA", test_num);
        reset_dut();

        D <= 4'hA;
        LOAD <= 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LOAD=0 inhibits write", test_num);
        reset_dut();


        D <= 4'hF;
        LOAD <= 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Loading All Ones (4'hF)", test_num);
        reset_dut();

        D <= 4'hF;
        LOAD <= 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data retention over multiple cycles", test_num);
        reset_dut();


        D <= 4'h7;
        LOAD <= 1;
        @(posedge CLK);


        LOAD <= 0;
        D <= 4'hE;
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Successive load operations", test_num);
        reset_dut();

        D <= 4'h3;
        LOAD <= 1;
        @(posedge CLK);

        D <= 4'hC;
        LOAD <= 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'hC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_with_load Testbench");
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
        $dumpvars(0,CLK, D, LOAD, Q);
    end

endmodule
