`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg rst;
    wire [63:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 32'h0;
            B = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 x 0", test_num);
            reset_dut();
            A = 32'd0;
            B = 32'd0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 x 1", test_num);
            reset_dut();
            A = 32'd1;
            B = 32'd1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: FFFFFFFF x 1", test_num);
            reset_dut();
            A = 32'hFFFFFFFF;
            B = 32'd1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: FFFFFFFF x FFFFFFFF", test_num);
            reset_dut();
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(64'hFFFFFFFF00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 2^16 x 2^15", test_num);
            reset_dut();
            A = 32'h00010000;
            B = 32'h00008000;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000000080000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 12345 x 67890", test_num);
            reset_dut();
            A = 32'd12345;
            B = 32'd67890;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000000031F17622);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0x55555555 x 0xAAAAAAAA", test_num);
            reset_dut();
            A = 32'h55555555;
            B = 32'hAAAAAAAA;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h38E38E3871C71C7E);
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
        input [63:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, clk, rst, C);
    end

endmodule
