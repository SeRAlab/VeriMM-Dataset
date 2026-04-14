`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CSram;
    reg [31:0] Datain;
    reg [7:0] Direc;
    reg EscrMem;
    reg LeerMem;
    reg clk;
    wire [31:0] Dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CSram(CSram),
        .Datain(Datain),
        .Direc(Direc),
        .EscrMem(EscrMem),
        .LeerMem(LeerMem),
        .clk(clk),
        .Dataout(Dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            CSram = 0;
            Datain = 0;
            Direc = 0;
            EscrMem = 0;
            LeerMem = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read", test_num);


            CSram = 1;
            EscrMem = 1;
            Direc = 8'h10;
            Datain = 32'hDEADBEEF;
            @(posedge clk);
            #1;


            EscrMem = 0;
            LeerMem = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Verify CSram inhibits read", test_num);


            CSram = 1;
            EscrMem = 1;
            Direc = 8'h20;
            Datain = 32'h12345678;
            @(posedge clk);
            #1;


            CSram = 0;
            LeerMem = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Verify LeerMem control", test_num);


            CSram = 1;
            EscrMem = 1;
            Direc = 8'h30;
            Datain = 32'hAAAA5555;
            @(posedge clk);
            #1;


            EscrMem = 0;
            LeerMem = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Verify CSram inhibits write", test_num);


            CSram = 0;
            EscrMem = 1;
            Direc = 8'h40;
            Datain = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            CSram = 1;
            LeerMem = 1;
            EscrMem = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Overwrite data", test_num);


            CSram = 1;
            EscrMem = 1;
            Direc = 8'hA0;
            Datain = 32'h11111111;
            @(posedge clk);
            #1;


            Datain = 32'h22222222;
            @(posedge clk);
            #1;


            EscrMem = 0;
            LeerMem = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h22222222);
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
        input [31:0] expected_Dataout;
        begin
            if (expected_Dataout === (expected_Dataout ^ Dataout ^ expected_Dataout)) begin
                $display("PASS");
                $display("  Outputs: Dataout=%h",
                         Dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dataout=%h",
                         expected_Dataout);
                $display("  Got:      Dataout=%h",
                         Dataout);
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
        $dumpvars(0,CSram, Datain, Direc, EscrMem, LeerMem, clk, Dataout);
    end

endmodule
