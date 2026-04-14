`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C383;
    reg CLK;
    reg [31:0] DI;
    reg [31:0] DR;
    reg DS;
    reg ED;
    reg MPYJ;
    wire [31:0] DOI;
    wire [31:0] DOR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C383(C383),
        .CLK(CLK),
        .DI(DI),
        .DR(DR),
        .DS(DS),
        .ED(ED),
        .MPYJ(MPYJ),
        .DOI(DOI),
        .DOR(DOR)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            C383 = 0;
            DS = 0;
            ED = 0;
            MPYJ = 0;
            DR = 32'h0;
            DI = 32'h0;
            @(posedge CLK);
            #1;
            C383 = 1;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();
            C383 = 0;
            DR = 32'hFFFF_FFFF;
            DI = 32'hAAAA_BBBB;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Pass-through", test_num);
            reset_dut();
            ED = 1;
            MPYJ = 0;
            DR = 32'h1234_5678;
            DI = 32'h8765_4321;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h8765_4321, 32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiply by J rotation", test_num);
            reset_dut();
            ED = 1;
            MPYJ = 1;
            DR = 32'h0000_0005;
            DI = 32'h0000_0003;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h0000_0005, 32'hFFFFFFFD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock Enable (ED=0) check", test_num);
            reset_dut();


            ED = 1;
            MPYJ = 0;
            DR = 32'hAAAA_AAAA;
            DI = 32'hBBBB_BBBB;
            @(posedge CLK);
            #1;


            ED = 0;
            DR = 32'h1111_1111;
            DI = 32'h2222_2222;
            @(posedge CLK);
            #1;



            #1;




            check_outputs(32'hBBBB_BBBB, 32'hAAAA_AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large and Negative Values", test_num);
            reset_dut();
            ED = 1;
            MPYJ = 1;
            DR = 32'h8000_0000;
            DI = 32'h7FFF_FFFF;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h8000_0000, 32'h8000_0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Select (DS) functionality", test_num);
            reset_dut();
            DS = 1;
            ED = 1;
            MPYJ = 0;
            DR = 32'hCCCC_DDDD;
            DI = 32'hEEEE_FFFF;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(32'hEEEE_FFFF, 32'hCCCC_DDDD);
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
        input [31:0] expected_DOI;
        input [31:0] expected_DOR;
        begin
            if (expected_DOI === (expected_DOI ^ DOI ^ expected_DOI) &&
                expected_DOR === (expected_DOR ^ DOR ^ expected_DOR)) begin
                $display("PASS");
                $display("  Outputs: DOI=%h, DOR=%h",
                         DOI, DOR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOI=%h, DOR=%h",
                         expected_DOI, expected_DOR);
                $display("  Got:      DOI=%h, DOR=%h",
                         DOI, DOR);
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
        $dumpvars(0,C383, CLK, DI, DR, DS, ED, MPYJ, DOI, DOR);
    end

endmodule
