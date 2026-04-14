`timescale 1ns/1ps

module dbg_register_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] DataIn;
    reg [7:0] Default;
    reg Reset;
    reg Write;
    wire [7:0] DataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dbg_register dut (
        .Clk(Clk),
        .DataIn(DataIn),
        .Default(Default),
        .Reset(Reset),
        .Write(Write),
        .DataOut(DataOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 1;
        Write = 0;
        DataIn = 8'h00;
        Default = 8'h00;
        @(posedge Clk);
        #1 Reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Reset with Custom Default Value", test_num);
        reset_dut();

        Default = 8'hA5;
        Reset = 1;
        @(posedge Clk);
        #1;
        Reset = 0;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Basic Write Enable Logic", test_num);
        reset_dut();

        DataIn = 8'h3C;
        Write = 1;
        @(posedge Clk);
        #1;
        Write = 0;

        #1;


        check_outputs(8'h3C);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Verify Data Persistence when Write=0", test_num);
        reset_dut();


        DataIn = 8'h77;
        Write = 1;
        @(posedge Clk);
        #1;


        DataIn = 8'hFF;
        Write = 0;
        @(posedge Clk);
        #1;

        #1;


        check_outputs(8'h77);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Verify Reset Priority Over Write Enable", test_num);
        reset_dut();

        Default = 8'h12;
        DataIn  = 8'h34;
        Reset   = 1;
        Write   = 1;
        @(posedge Clk);
        #1;
        Reset = 0;
        Write = 0;

        #1;


        check_outputs(8'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Writing Boundary Values (0xFF)", test_num);
        reset_dut();

        DataIn = 8'hFF;
        Write = 1;
        @(posedge Clk);
        #1;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Multiple Sequential Writes", test_num);
        reset_dut();

        Write = 1;
        DataIn = 8'h01; @(posedge Clk);
        #1;
        DataIn = 8'h02; @(posedge Clk);
        #1;
        DataIn = 8'h03; @(posedge Clk);
        #1;
        Write = 0;

        #1;


        check_outputs(8'h03);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dbg_register Testbench");
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
        input [7:0] expected_DataOut;
        begin
            if (expected_DataOut === (expected_DataOut ^ DataOut ^ expected_DataOut)) begin
                $display("PASS");
                $display("  Outputs: DataOut=%h",
                         DataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut=%h",
                         expected_DataOut);
                $display("  Got:      DataOut=%h",
                         DataOut);
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
        $dumpvars(0,Clk, DataIn, Default, Reset, Write, DataOut);
    end

endmodule
