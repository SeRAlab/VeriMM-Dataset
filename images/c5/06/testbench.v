`timescale 1ns/1ps

module RegisterAdd_tb;

    // Testbench signals (sequential circuit)
    reg [25:0] A;
    reg [25:0] B;
    reg CLK;
    reg RESET;
    wire [25:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RegisterAdd dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .RESET(RESET),
        .SUM(SUM)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            A = 0;
            B = 0;
            @(posedge CLK);
            #1;
            RESET = 0;

            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Simple Addition (100 + 200)", test_num);
            reset_dut();
            A = 26'd100;
            B = 26'd200;

            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(26'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Maximum Value Check", test_num);
            reset_dut();
            A = 26'h2AAAAAA;
            B = 26'h1555555;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(26'h3FFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Overflow Wrap-around", test_num);
            reset_dut();
            A = 26'h3FFFFFF;
            B = 26'h1;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(26'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero Addition", test_num);
            reset_dut();
            A = 26'h1234567;
            B = 26'h0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(26'h1234567);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Large Power of Two Addition", test_num);
            reset_dut();
            A = 26'h1000000;
            B = 26'h1000000;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(26'h2000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Alternating Bits", test_num);
            reset_dut();
            A = 26'h1555555;
            B = 26'h1555555;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(26'h2AAAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RegisterAdd Testbench");
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
        input [25:0] expected_SUM;
        begin
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
        $dumpvars(0,A, B, CLK, RESET, SUM);
    end

endmodule
