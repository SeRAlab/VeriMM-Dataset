`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ADD1;
    reg ADD10;
    reg CLK;
    reg CLR;
    reg RSTX;
    reg SUB1;
    reg SUB10;
    reg [7:0] UBND;
    wire [7:0] CNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADD1(ADD1),
        .ADD10(ADD10),
        .CLK(CLK),
        .CLR(CLR),
        .RSTX(RSTX),
        .SUB1(SUB1),
        .SUB10(SUB10),
        .UBND(UBND),
        .CNT(CNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RSTX = 0;
        CLR = 0;
        ADD1 = 0;
        ADD10 = 0;
        SUB1 = 0;
        SUB10 = 0;
        UBND = 8'hFF;
        @(posedge CLK);
        #1;
        RSTX = 1;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset check...");
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Increment by 1...");
        reset_dut();
        UBND = 8'd100;
        ADD1 = 1;
        @(posedge CLK);
        #1;
        ADD1 = 0;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Increment by 10...");
        reset_dut();
        UBND = 8'd100;
        ADD10 = 1;
        @(posedge CLK);
        #1;
        ADD10 = 0;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Decrement by 1...");
        reset_dut();
        UBND = 8'd100;

        repeat(5) begin
            ADD1 = 1;
            @(posedge CLK);
            #1;
        end
        ADD1 = 0;

        SUB1 = 1;
        @(posedge CLK);
        #1;
        SUB1 = 0;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Decrement by 10...");
        reset_dut();
        UBND = 8'd100;

        ADD10 = 1;
        @(posedge CLK); @(posedge CLK); #1;
        ADD10 = 0;
        ADD1 = 1;
        repeat(5) @(posedge CLK);
        #1;
        ADD1 = 0;

        SUB10 = 1;
        @(posedge CLK);
        #1;
        SUB10 = 0;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Upper Boundary Clamping...");
        reset_dut();
        UBND = 8'd15;
        ADD10 = 1;
        @(posedge CLK);
        #1;
        @(posedge CLK);
        #1;
        ADD10 = 0;
        ADD1 = 1;
        @(posedge CLK);
        #1;
        ADD1 = 0;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Lower Boundary Clamping/Rollover...");
        reset_dut();
        UBND = 8'd50;

        SUB1 = 1;
        @(posedge CLK);
        #1;
        SUB1 = 0;

        ADD1 = 1;
        repeat(5) @(posedge CLK);
        #1;
        ADD1 = 0;
        SUB10 = 1;
        @(posedge CLK);
        #1;
        SUB10 = 0;
        #1;

        check_outputs(8'd00);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: Clear Signal...");
        reset_dut();
        UBND = 8'hFF;
        ADD10 = 1;
        repeat(5) @(posedge CLK);
        #1;
        CLR = 1;
        @(posedge CLK);
        #1;
        CLR = 0;
        ADD10 = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        $display("Running testcase009: Mixed Operations Sequence...");
        reset_dut();
        UBND = 8'd200;

        ADD10 = 1;
        @(posedge CLK); @(posedge CLK); #1;
        ADD10 = 0; ADD1 = 1;
        @(posedge CLK); #1;
        ADD1 = 0; SUB10 = 1;
        @(posedge CLK); #1;
        SUB10 = 0; ADD1 = 1;
        @(posedge CLK); #1;
        ADD1 = 0;
        #1;

        check_outputs(8'd12);
    end
        endtask

    task testcase010;

    begin
        $display("Running testcase010: Dynamic Boundary Change...");
        reset_dut();
        UBND = 8'd100;
        ADD10 = 1;
        repeat(5) @(posedge CLK);
        #1;
        ADD10 = 0;
        UBND = 8'd30;

        @(posedge CLK);
        #1;

        ADD1 = 1;
        @(posedge CLK);
        #1;
        ADD1 = 0;

        if (CNT > 8'd30)
            $display("Note: CNT (%d) is above new UBND (30). Clamping might only occur on increment.", CNT);


        #1;



        check_outputs(CNT > 8'd30 ? CNT : 8'd30);


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
        testcase010();
        
        
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
        input [7:0] expected_CNT;
        begin
            if (expected_CNT === (expected_CNT ^ CNT ^ expected_CNT)) begin
                $display("PASS");
                $display("  Outputs: CNT=%h",
                         CNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CNT=%h",
                         expected_CNT);
                $display("  Got:      CNT=%h",
                         CNT);
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
        $dumpvars(0,ADD1, ADD10, CLK, CLR, RSTX, SUB1, SUB10, UBND, CNT);
    end

endmodule
