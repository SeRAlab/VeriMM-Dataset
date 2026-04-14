`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] A;
    reg CEN;
    reg CLK;
    reg [31:0] D;
    reg WEN;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CEN(CEN),
        .CLK(CLK),
        .D(D),
        .WEN(WEN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            A = 0;
            CEN = 0;
            WEN = 0;
            D = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            A = 10'h010; D = 32'h12345678; CEN = 1; WEN = 1;
            @(posedge CLK);
            #1;


            A = 10'h010; CEN = 1; WEN = 0;
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CEN Inactive (Write Protection)", test_num);
            reset_dut();


            A = 10'h020; D = 32'hAAAAAAAA; CEN = 1; WEN = 1;
            @(posedge CLK);
            #1;


            A = 10'h020; D = 32'hBBBBBBBB; CEN = 0; WEN = 1;
            @(posedge CLK);
            #1;


            A = 10'h020; CEN = 1; WEN = 0;
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 1023", test_num);
            reset_dut();


            A = 10'h3FF; D = 32'hDEADBEEF; CEN = 1; WEN = 1;
            @(posedge CLK);
            #1;


            A = 10'h3FF; CEN = 1; WEN = 0;
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Data", test_num);
            reset_dut();


            A = 10'h050; D = 32'h00001111; CEN = 1; WEN = 1;
            @(posedge CLK);
            #1;

            A = 10'h050; D = 32'hFFFFEEEE; CEN = 1; WEN = 1;
            @(posedge CLK);
            #1;


            A = 10'h050; CEN = 1; WEN = 0;
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hFFFFEEEE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: WEN Read Mode logic", test_num);
            reset_dut();


            A = 10'h100; D = 32'h55555555; CEN = 1; WEN = 1;
            @(posedge CLK);
            #1;


            A = 10'h100; D = 32'h99999999; CEN = 1; WEN = 0;
            @(posedge CLK);
            @(posedge CLK);
            #1;


            #1;



            check_outputs(32'h55555555);
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
        input [31:0] expected_Q;
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
        $dumpvars(0,A, CEN, CLK, D, WEN, Q);
    end

endmodule
