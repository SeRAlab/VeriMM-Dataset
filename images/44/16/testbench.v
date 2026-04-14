`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] rdReg1;
    reg [4:0] rdReg2;
    reg [31:0] wrData;
    reg wrEnable;
    reg [4:0] wrReg;
    wire [31:0] rdData1;
    wire [31:0] rdData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rdReg1(rdReg1),
        .rdReg2(rdReg2),
        .wrData(wrData),
        .wrEnable(wrEnable),
        .wrReg(wrReg),
        .rdData1(rdData1),
        .rdData2(rdData2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wrEnable = 0;
            wrReg = 0;
            wrData = 0;
            rdReg1 = 0;
            rdReg2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read back", test_num);


            @(posedge clk);
            wrEnable = 1;
            wrReg = 5'd1;
            wrData = 32'hDEADBEEF;

            @(posedge clk);
            wrEnable = 0;

            rdReg1 = 5'd1;
            rdReg2 = 5'd1;

            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Multi-register Write/Read", test_num);


            @(posedge clk);
            wrEnable = 1;
            wrReg = 5'd10;
            wrData = 32'h12345678;


            @(posedge clk);
            wrReg = 5'd20;
            wrData = 32'hABCDEF00;

            @(posedge clk);
            wrEnable = 0;

            rdReg1 = 5'd10;
            rdReg2 = 5'd20;

            #2;
            #1;

            check_outputs(32'h12345678, 32'hABCDEF00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Verify wrEnable functionality", test_num);


            @(posedge clk);
            wrEnable = 1;
            wrReg = 5'd5;
            wrData = 32'hAAAA_5555;


            @(posedge clk);
            wrEnable = 0;
            wrReg = 5'd5;
            wrData = 32'hFFFF_FFFF;

            @(posedge clk);

            rdReg1 = 5'd5;
            rdReg2 = 5'd0;

            #2;

            #1;


            check_outputs(32'hAAAA_5555, rdData2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overwrite check", test_num);


            @(posedge clk);
            wrEnable = 1;
            wrReg = 5'd2;
            wrData = 32'h1111_1111;


            @(posedge clk);
            wrData = 32'h2222_2222;

            @(posedge clk);
            wrEnable = 0;
            rdReg1 = 5'd2;
            rdReg2 = 5'd2;

            #2;
            #1;

            check_outputs(32'h2222_2222, 32'h2222_2222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary Register 31", test_num);

            @(posedge clk);
            wrEnable = 1;
            wrReg = 5'd31;
            wrData = 32'hFFFF_0000;

            @(posedge clk);
            wrEnable = 0;
            rdReg1 = 5'd31;
            rdReg2 = 5'd0;

            #2;
            #1;

            check_outputs(32'hFFFF_0000, rdData2);
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
        input [31:0] expected_rdData1;
        input [31:0] expected_rdData2;
        begin
            if (expected_rdData1 === (expected_rdData1 ^ rdData1 ^ expected_rdData1) &&
                expected_rdData2 === (expected_rdData2 ^ rdData2 ^ expected_rdData2)) begin
                $display("PASS");
                $display("  Outputs: rdData1=%h, rdData2=%h",
                         rdData1, rdData2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdData1=%h, rdData2=%h",
                         expected_rdData1, expected_rdData2);
                $display("  Got:      rdData1=%h, rdData2=%h",
                         rdData1, rdData2);
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
        $dumpvars(0,clk, rdReg1, rdReg2, wrData, wrEnable, wrReg, rdData1, rdData2);
    end

endmodule
