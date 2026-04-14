`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] nPC;
    reg reset;
    wire [10:0] Addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .nPC(nPC),
        .reset(reset),
        .Addr(Addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            nPC = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(11'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load standard address 0x123", test_num);
            reset_dut();
            nPC = 32'h0000_0123;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h123);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load maximum address 0x7FF", test_num);
            reset_dut();
            nPC = 32'h0000_07FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h7FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verifying truncation of upper bits", test_num);
            reset_dut();

            nPC = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(11'h7FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple sequential updates", test_num);
            reset_dut();

            nPC = 32'hA;
            @(posedge clk);

            nPC = 32'hB;
            @(posedge clk);

            nPC = 32'hC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h00C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset priority check", test_num);
            reset_dut();


            reset = 1;
            nPC = 32'h123;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h000);
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
        input [10:0] expected_Addr;
        begin
            if (expected_Addr === (expected_Addr ^ Addr ^ expected_Addr)) begin
                $display("PASS");
                $display("  Outputs: Addr=%h",
                         Addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Addr=%h",
                         expected_Addr);
                $display("  Got:      Addr=%h",
                         Addr);
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
        $dumpvars(0,clk, nPC, reset, Addr);
    end

endmodule
