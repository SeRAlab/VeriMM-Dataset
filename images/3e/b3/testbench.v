`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] symbols;
    wire [1:0] outI;
    wire [1:0] outQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .clk(clk),
        .rst(rst),
        .symbols(symbols),
        .outI(outI),
        .outQ(outQ)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            symbols = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0000 -> Expected (1, 1)", test_num);
            reset_dut();
            symbols = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0001 -> Expected (1, -1)", test_num);
            reset_dut();
            symbols = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0010 -> Expected (-1, 1)", test_num);
            reset_dut();
            symbols = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0011 -> Expected (-1, -1)", test_num);
            reset_dut();
            symbols = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_modulator Testbench");
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
        input [1:0] expected_outI;
        input [1:0] expected_outQ;
        begin
            if (expected_outI === (expected_outI ^ outI ^ expected_outI) &&
                expected_outQ === (expected_outQ ^ outQ ^ expected_outQ)) begin
                $display("PASS");
                $display("  Outputs: outI=%h, outQ=%h",
                         outI, outQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outI=%h, outQ=%h",
                         expected_outI, expected_outQ);
                $display("  Got:      outI=%h, outQ=%h",
                         outI, outQ);
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
        $dumpvars(0,clk, rst, symbols, outI, outQ);
    end

endmodule
