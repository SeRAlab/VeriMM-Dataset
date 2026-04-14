`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ADDR;
    reg CLK;
    reg [31:0] D_IN;
    reg D_WE;
    wire [31:0] D_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .D_IN(D_IN),
        .D_WE(D_WE),
        .D_OUT(D_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ADDR = 0;
            D_IN = 0;
            D_WE = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);

            ADDR = 32'h0000_0000;
            D_IN = 32'hA5A5_B6B6;
            D_WE = 1;
            @(posedge CLK);
            #2;
            D_WE = 0;
            #1;

            check_outputs(32'hA5A5_B6B6);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write and Read at Word 1 (ADDR=4)", test_num);

            ADDR = 32'h0000_0004;
            D_IN = 32'h1234_5678;
            D_WE = 1;
            @(posedge CLK);
            #2;
            D_WE = 0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Verify Write Enable logic", test_num);


            ADDR = 32'h0000_0010;
            D_IN = 32'hFEED_FACE;
            D_WE = 1;
            @(posedge CLK);
            #2;


            D_IN = 32'h0000_0000;
            D_WE = 0;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(32'hFEED_FACE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Asynchronous Read Verification", test_num);


            ADDR = 32'h0000_0020;
            D_IN = 32'h1111_1111;
            D_WE = 1;
            @(posedge CLK);
            #2;


            ADDR = 32'h0000_0024;
            D_IN = 32'h2222_2222;
            D_WE = 1;
            @(posedge CLK);
            #2;

            D_WE = 0;

            ADDR = 32'h0000_0020;
            #1;
            #1;

            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: High boundary address check", test_num);


            ADDR = 32'h0000_0FFC;
            D_IN = 32'hDEAD_BEEF;
            D_WE = 1;
            @(posedge CLK);
            #2;
            D_WE = 0;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_D_OUT;
        begin
            if (expected_D_OUT === (expected_D_OUT ^ D_OUT ^ expected_D_OUT)) begin
                $display("PASS");
                $display("  Outputs: D_OUT=%h",
                         D_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_OUT=%h",
                         expected_D_OUT);
                $display("  Got:      D_OUT=%h",
                         D_OUT);
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
        $dumpvars(0,ADDR, CLK, D_IN, D_WE, D_OUT);
    end

endmodule
