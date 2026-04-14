`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [4:0] CTRL;
    reg clk;
    reg rst;
    wire [31:0] RES;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .CTRL(CTRL),
        .clk(clk),
        .rst(rst),
        .RES(RES)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            CTRL = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Addition (0x12345678 + 0x11111111)", test_num);
            A = 32'h12345678;
            B = 32'h11111111;
            CTRL = 5'b00000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h23456789);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Subtraction (0x00000010 - 0x00000005)", test_num);
            A = 32'h00000010;
            B = 32'h00000005;
            CTRL = 5'b00001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000000B);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Bitwise AND (0xF0F0F0F0 & 0xAAAAAAAA)", test_num);
            A = 32'hF0F0F0F0;
            B = 32'hAAAAAAAA;
            CTRL = 5'b00010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hA0A0A0A0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Bitwise OR (0xF0F0F0F0 | 0xAAAAAAAA)", test_num);
            A = 32'hF0F0F0F0;
            B = 32'hAAAAAAAA;
            CTRL = 5'b00011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFAFAFAFA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Bitwise XOR (0xFFFF0000 ^ 0x5555AAAA)", test_num);
            A = 32'hFFFF0000;
            B = 32'h5555AAAA;
            CTRL = 5'b00100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Logical Shift Left (0x00000001 << 4)", test_num);
            A = 32'h00000001;
            B = 32'h00000004;
            CTRL = 5'b00101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Subtraction (0 - 1)", test_num);
            A = 32'h00000000;
            B = 32'h00000001;
            CTRL = 5'b00001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Addition Overflow (0xFFFFFFFF + 1)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            CTRL = 5'b00000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Logical Shift Left (0x0000FFFF << 16)", test_num);
            A = 32'h0000FFFF;
            B = 32'h00000010;
            CTRL = 5'b00101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %0d: Bitwise AND with zero", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h00000000;
            CTRL = 5'b00010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [31:0] expected_RES;
        begin
            if (expected_RES === (expected_RES ^ RES ^ expected_RES)) begin
                $display("PASS");
                $display("  Outputs: RES=%h",
                         RES);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RES=%h",
                         expected_RES);
                $display("  Got:      RES=%h",
                         RES);
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
        $dumpvars(0,A, B, CTRL, clk, rst, RES);
    end

endmodule
