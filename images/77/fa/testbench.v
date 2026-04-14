`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bslipcntl;
    reg bsliprst;
    reg clk0;
    reg datain;
    reg x_on_bitslip;
    wire bslipmax;
    wire dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bslipcntl(bslipcntl),
        .bsliprst(bsliprst),
        .clk0(clk0),
        .datain(datain),
        .x_on_bitslip(x_on_bitslip),
        .bslipmax(bslipmax),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk0 = 0;
        forever #5 clk0 = ~clk0;
    end

        task reset_dut;

    begin
        bsliprst = 1;
        bslipcntl = 0;
        datain = 0;
        x_on_bitslip = 0;
        @(posedge clk0);
        #1 bsliprst = 0;
        @(posedge clk0);
    end
    endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        datain = 1;
        @(posedge clk0);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        bslipcntl = 1;
        @(posedge clk0);
        #1 bslipcntl = 0;
        datain = 0;
        repeat(2) @(posedge clk0);
        #1;

        #1;


        check_outputs(1'b0, 1'b0);
    end
    endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        reset_dut();


        for(i=0; i<7; i=i+1) begin
            bslipcntl = 1;
            @(posedge clk0);
            #1 bslipcntl = 0;
            @(posedge clk0);
        end
        #1;

        #1;


        check_outputs(1'b1, 1'b0);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        x_on_bitslip = 1;
        bslipcntl = 1;
        @(posedge clk0);
        #1 bslipcntl = 0;
        datain = 1;
        @(posedge clk0);
        #1;


        #1;



        check_outputs(1'b0, 1'bx);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        repeat(3) begin
            bslipcntl = 1;
            @(posedge clk0);
            #1 bslipcntl = 0;
            @(posedge clk0);
        end

        bsliprst = 1;
        @(posedge clk0);
        #1 bsliprst = 0;
        datain = 1;
        @(posedge clk0);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
    endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        reset_dut();

        for(i=0; i<7; i=i+1) begin
            bslipcntl = 1;
            @(posedge clk0);
            #1 bslipcntl = 0;
            @(posedge clk0);
        end

        bslipcntl = 1;
        @(posedge clk0);
        #1 bslipcntl = 0;
        @(posedge clk0);
        #1;

        #1;


        check_outputs(1'b0, 1'b0);
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
        input expected_bslipmax;
        input expected_dataout;
        begin
            if (expected_bslipmax === (expected_bslipmax ^ bslipmax ^ expected_bslipmax) &&
                expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: bslipmax=%b, dataout=%b",
                         bslipmax, dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bslipmax=%b, dataout=%b",
                         expected_bslipmax, expected_dataout);
                $display("  Got:      bslipmax=%b, dataout=%b",
                         bslipmax, dataout);
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
        $dumpvars(0,bslipcntl, bsliprst, clk0, datain, x_on_bitslip, bslipmax, dataout);
    end

endmodule
