`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] Addr;
    reg DMA_in;
    reg EXTCPU;
    reg EXTMEM;
    reg EXTSEL_in;
    wire D1FF;
    wire D1XX;
    wire D6XX;
    wire D8XX;
    wire DMA_out;
    wire EXTSEL_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .DMA_in(DMA_in),
        .EXTCPU(EXTCPU),
        .EXTMEM(EXTMEM),
        .EXTSEL_in(EXTSEL_in),
        .D1FF(D1FF),
        .D1XX(D1XX),
        .D6XX(D6XX),
        .D8XX(D8XX),
        .DMA_out(DMA_out),
        .EXTSEL_out(EXTSEL_out)
    );
    task testcase001;

        begin
            $display("\nRunning testcase001: Idle / Base State (Addr=0x0000)");
            test_num = 1;
            Addr = 16'h0000;
            DMA_in = 0;
            EXTSEL_in = 0;
            EXTCPU = 0;
            EXTMEM = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Exact Address D1FF");
            test_num = 2;
            Addr = 16'hD1FF;
            DMA_in = 0;
            EXTSEL_in = 0;
            EXTCPU = 1;
            EXTMEM = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: D1XX Range (Address 0xD100)");
            test_num = 3;
            Addr = 16'hD100;
            DMA_in = 0;
            EXTSEL_in = 0;
            EXTCPU = 1;
            EXTMEM = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: D6XX Range (Address 0xD655)");
            test_num = 4;
            Addr = 16'hD655;
            DMA_in = 0;
            EXTSEL_in = 0;
            EXTCPU = 1;
            EXTMEM = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: D8XX Range (Address 0xD8AA)");
            test_num = 5;
            Addr = 16'hD8AA;
            DMA_in = 0;
            EXTSEL_in = 0;
            EXTCPU = 1;
            EXTMEM = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: DMA Signal Management");
            test_num = 6;
            Addr = 16'h0000;
            DMA_in = 1;
            EXTSEL_in = 0;
            EXTCPU = 0;
            EXTMEM = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: External Select Management");
            test_num = 7;
            Addr = 16'h0000;
            DMA_in = 0;
            EXTSEL_in = 1;
            EXTCPU = 0;
            EXTMEM = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Complex Condition (Address 0xFFFF)");
            test_num = 8;
            Addr = 16'hFFFF;
            DMA_in = 1;
            EXTSEL_in = 1;
            EXTCPU = 1;
            EXTMEM = 1;
            #10;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("\nRunning testcase009: Boundary Check (Address 0xD0FF)");
            test_num = 9;
            Addr = 16'hD0FF;
            DMA_in = 0;
            EXTSEL_in = 0;
            EXTCPU = 1;
            EXTMEM = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_D1FF;
        input expected_D1XX;
        input expected_D6XX;
        input expected_D8XX;
        input expected_DMA_out;
        input expected_EXTSEL_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1FF === (expected_D1FF ^ D1FF ^ expected_D1FF) &&
                expected_D1XX === (expected_D1XX ^ D1XX ^ expected_D1XX) &&
                expected_D6XX === (expected_D6XX ^ D6XX ^ expected_D6XX) &&
                expected_D8XX === (expected_D8XX ^ D8XX ^ expected_D8XX) &&
                expected_DMA_out === (expected_DMA_out ^ DMA_out ^ expected_DMA_out) &&
                expected_EXTSEL_out === (expected_EXTSEL_out ^ EXTSEL_out ^ expected_EXTSEL_out)) begin
                $display("PASS");
                $display("  Outputs: D1FF=%b, D1XX=%b, D6XX=%b, D8XX=%b, DMA_out=%b, EXTSEL_out=%b",
                         D1FF, D1XX, D6XX, D8XX, DMA_out, EXTSEL_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1FF=%b, D1XX=%b, D6XX=%b, D8XX=%b, DMA_out=%b, EXTSEL_out=%b",
                         expected_D1FF, expected_D1XX, expected_D6XX, expected_D8XX, expected_DMA_out, expected_EXTSEL_out);
                $display("  Got:      D1FF=%b, D1XX=%b, D6XX=%b, D8XX=%b, DMA_out=%b, EXTSEL_out=%b",
                         D1FF, D1XX, D6XX, D8XX, DMA_out, EXTSEL_out);
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

endmodule
