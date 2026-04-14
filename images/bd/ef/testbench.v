`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg RESET;
    reg clk;
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out1;
    wire [31:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .RESET(RESET),
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RESET = 1;
            EN = 0;
            in1 = 0;
            in2 = 0;
            @(posedge clk);
            #1;
            RESET = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Capture Data (EN=1)", test_num);
            reset_dut();

            in1 = 32'hDEADBEEF;
            in2 = 32'hCAFEBABE;
            EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Hold (EN=0)", test_num);
            reset_dut();


            in1 = 32'h11111111;
            in2 = 32'h22222222;
            EN = 1;
            @(posedge clk);
            #1;


            in1 = 32'hAAAAAAAA;
            in2 = 32'hBBBBBBBB;
            EN = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h11111111, 32'h22222222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Priority", test_num);
            reset_dut();


            in1 = 32'hFFFFFFFF;
            in2 = 32'hEEEEEEEE;
            EN = 1;
            RESET = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Updates", test_num);
            reset_dut();

            EN = 1;
            in1 = 32'h1; in2 = 32'h2;
            @(posedge clk);
            #1;
            in1 = 32'hA; in2 = 32'hB;
            @(posedge clk);
            #1;
            in1 = 32'hFF; in2 = 32'hEE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFF, 32'hEE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Values", test_num);
            reset_dut();

            in1 = 32'hFFFFFFFF;
            in2 = 32'h00000000;
            EN = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 32'h00000000);
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
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
        $dumpvars(0,EN, RESET, clk, in1, in2, out1, out2);
    end

endmodule
