`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Nin;
    reg Vin;
    reg Zin;
    reg clk;
    reg rst;
    wire Nout;
    wire Vout;
    wire Zout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Nin(Nin),
        .Vin(Vin),
        .Zin(Zin),
        .clk(clk),
        .rst(rst),
        .Nout(Nout),
        .Vout(Vout),
        .Zout(Zout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Nin = 0;
            Vin = 0;
            Zin = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking outputs after reset", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Capture Zin=1", test_num);
            Zin = 1;
            Vin = 0;
            Nin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Capture Vin=1", test_num);
            Zin = 0;
            Vin = 1;
            Nin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Capture Nin=1", test_num);
            Zin = 0;
            Vin = 0;
            Nin = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Capture all flags (111)", test_num);
            Zin = 1;
            Vin = 1;
            Nin = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Edge sensitivity and data holding", test_num);


            Zin = 1; Vin = 0; Nin = 1;
            @(posedge clk);
            #1;


            Zin = 0; Vin = 1; Nin = 0;
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Reset priority", test_num);


            Zin = 1; Vin = 1; Nin = 0;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Capture pattern 011", test_num);
            Nin = 0;
            Vin = 1;
            Zin = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_Nout;
        input expected_Vout;
        input expected_Zout;
        begin
            if (expected_Nout === (expected_Nout ^ Nout ^ expected_Nout) &&
                expected_Vout === (expected_Vout ^ Vout ^ expected_Vout) &&
                expected_Zout === (expected_Zout ^ Zout ^ expected_Zout)) begin
                $display("PASS");
                $display("  Outputs: Nout=%b, Vout=%b, Zout=%b",
                         Nout, Vout, Zout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Nout=%b, Vout=%b, Zout=%b",
                         expected_Nout, expected_Vout, expected_Zout);
                $display("  Got:      Nout=%b, Vout=%b, Zout=%b",
                         Nout, Vout, Zout);
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
        $dumpvars(0,Nin, Vin, Zin, clk, rst, Nout, Vout, Zout);
    end

endmodule
