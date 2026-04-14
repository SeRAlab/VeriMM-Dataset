`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [15:0] D;
    reg WE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .A(A),
        .D(D),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        WE = 0;
        forever #5 WE = ~WE;
    end

        task reset_dut;

    begin
        A = 0;
        D = 0;
        WE = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %0d: Basic Write and Read at Address 0", test_num);
        A = 4'h0;
        D = 16'hA5A5;
        WE = 1;
        #10;
        WE = 0;
        #10;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test %0d: Boundary Address Check (Address 15)", test_num);
        A = 4'hF;
        D = 16'h5A5A;
        WE = 1;
        #10;
        WE = 0;
        #10;
        #1;

        check_outputs(16'h5A5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test %0d: Overwrite Data Check", test_num);

        A = 4'h7;
        D = 16'h1111;
        WE = 1;
        #10;

        D = 16'hFFFF;
        WE = 1;
        #10;
        WE = 0;
        #10;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test %0d: Multiple Address Persistence", test_num);

        A = 4'h1; D = 16'h1234; WE = 1; #10;

        A = 4'h2; D = 16'h5678; WE = 1; #10;


        WE = 0;
        A = 4'h1;
        #10;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test %0d: Write Enable (WE) Low Inhibition Check", test_num);

        A = 4'hA; D = 16'hBBBB; WE = 1; #10;


        WE = 0;
        D = 16'hEEEE;
        #10;


        A = 4'hA;
        #10;
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [15:0] expected_Q;
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
        $dumpvars(0,A, D, WE, Q);
    end

endmodule
