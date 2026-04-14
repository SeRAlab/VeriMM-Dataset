`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] ra1;
    reg [4:0] ra2;
    reg [4:0] wa3;
    reg [31:0] wd3;
    reg we3;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .wd3(wd3),
        .we3(we3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we3 = 0;
            wa3 = 0;
            wd3 = 0;
            ra1 = 0;
            ra2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register 0 constant check", test_num);
            reset_dut();

            ra1 = 5'd0;
            ra2 = 5'd0;
            #5;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic write/read (Reg 1 and 2)", test_num);
            reset_dut();


            @(negedge clk);
            we3 = 1; wa3 = 5'd1; wd3 = 32'hAAAABBBB;
            @(posedge clk);


            @(negedge clk);
            we3 = 1; wa3 = 5'd2; wd3 = 32'h12345678;
            @(posedge clk);

            #1 we3 = 0;
            ra1 = 5'd1;
            ra2 = 5'd2;
            #5;

            #1;


            check_outputs(32'hAAAABBBB, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Attempt write to Reg 0", test_num);
            reset_dut();

            @(negedge clk);
            we3 = 1; wa3 = 5'd0; wd3 = 32'hFFFFFFFF;
            @(posedge clk);

            #1 we3 = 0;
            ra1 = 5'd0;
            ra2 = 5'd0;
            #5;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual port read same address", test_num);
            reset_dut();

            @(negedge clk);
            we3 = 1; wa3 = 5'd10; wd3 = 32'hCAFEBABE;
            @(posedge clk);

            #1 we3 = 0;
            ra1 = 5'd10;
            ra2 = 5'd10;
            #5;

            #1;


            check_outputs(32'hCAFEBABE, 32'hCAFEBABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable (we3) check", test_num);
            reset_dut();


            @(negedge clk);
            we3 = 1; wa3 = 5'd15; wd3 = 32'h11111111;
            @(posedge clk);


            @(negedge clk);
            we3 = 0; wa3 = 5'd15; wd3 = 32'hEEEEEEEE;
            @(posedge clk);

            #1 ra1 = 5'd15;
            ra2 = 5'd0;
            #5;

            #1;


            check_outputs(32'h11111111, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max address (Reg 31) check", test_num);
            reset_dut();

            @(negedge clk);
            we3 = 1; wa3 = 5'd31; wd3 = 32'h87654321;
            @(posedge clk);

            #1 we3 = 0;
            ra1 = 5'd31;
            ra2 = 5'd0;
            #5;

            #1;


            check_outputs(32'h87654321, 32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data overwrite check", test_num);
            reset_dut();

            @(negedge clk);
            we3 = 1; wa3 = 5'd20; wd3 = 32'hAAAA0000;
            @(posedge clk);

            @(negedge clk);
            we3 = 1; wa3 = 5'd20; wd3 = 32'h0000BBBB;
            @(posedge clk);

            #1 we3 = 0;
            ra1 = 5'd20;
            ra2 = 5'd20;
            #5;

            #1;


            check_outputs(32'h0000BBBB, 32'h0000BBBB);
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
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
        $dumpvars(0,clk, ra1, ra2, wa3, wd3, we3, rd1, rd2);
    end

endmodule
