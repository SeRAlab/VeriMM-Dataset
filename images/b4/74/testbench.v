`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I_clk;
    reg [31:0] I_dataD;
    reg I_rst;
    reg [4:0] I_selA;
    reg [4:0] I_selB;
    reg [4:0] I_selD;
    reg I_we;
    wire [31:0] O_dataA;
    wire [31:0] O_dataB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_clk(I_clk),
        .I_dataD(I_dataD),
        .I_rst(I_rst),
        .I_selA(I_selA),
        .I_selB(I_selB),
        .I_selD(I_selD),
        .I_we(I_we),
        .O_dataA(O_dataA),
        .O_dataB(O_dataB)
    );

    // Clock generation (10ns period)
    initial begin
        I_clk = 0;
        forever #5 I_clk = ~I_clk;
    end

        task reset_dut;

        begin
            I_rst = 1;
            I_we = 0;
            I_selA = 0;
            I_selB = 0;
            I_selD = 0;
            I_dataD = 0;
            repeat (2) @(posedge I_clk);
            #1 I_rst = 0;
            repeat (1) @(posedge I_clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State Check");
            reset_dut();

            I_selA = 5'd0;
            I_selB = 5'd18;

            #1;
            #1;

            check_outputs(32'h00000000, 32'h0000DFFF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write to Reg 5 and Read Back");
            reset_dut();

            @(posedge I_clk);
            I_we = 1;
            I_selD = 5'd5;
            I_dataD = 32'hDEADBEEF;

            @(posedge I_clk);
            I_we = 0;
            I_selA = 5'd5;
            I_selB = 5'd5;

            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write to Reg 10 and Reg 20");
            reset_dut();


            @(posedge I_clk);
            I_we = 1;
            I_selD = 5'd10;
            I_dataD = 32'h11112222;


            @(posedge I_clk);
            I_selD = 5'd20;
            I_dataD = 32'h33334444;

            @(posedge I_clk);
            I_we = 0;
            I_selA = 5'd10;
            I_selB = 5'd20;

            #1;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify Write Enable = 0");
            reset_dut();


            @(posedge I_clk);
            I_we = 0;
            I_selD = 5'd7;
            I_dataD = 32'hFFFFFFFF;

            @(posedge I_clk);
            I_selA = 5'd7;
            I_selB = 5'd0;

            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting Register 18");
            reset_dut();


            @(posedge I_clk);
            I_we = 1;
            I_selD = 5'd18;
            I_dataD = 32'hCAFEBABE;

            @(posedge I_clk);
            I_we = 0;
            I_selA = 5'd18;
            I_selB = 5'd0;

            #1;
            #1;

            check_outputs(32'hCAFEBABE, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Boundary Register Check (Reg 31)");
            reset_dut();

            @(posedge I_clk);
            I_we = 1;
            I_selD = 5'd31;
            I_dataD = 32'h88887777;

            @(posedge I_clk);
            I_we = 1;
            I_selD = 5'd1;
            I_dataD = 32'h5555AAAA;

            @(posedge I_clk);
            I_we = 0;
            I_selA = 5'd31;
            I_selB = 5'd1;

            #1;
            #1;

            check_outputs(32'h88887777, 32'h5555AAAA);
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
        input [31:0] expected_O_dataA;
        input [31:0] expected_O_dataB;
        begin
            if (expected_O_dataA === (expected_O_dataA ^ O_dataA ^ expected_O_dataA) &&
                expected_O_dataB === (expected_O_dataB ^ O_dataB ^ expected_O_dataB)) begin
                $display("PASS");
                $display("  Outputs: O_dataA=%h, O_dataB=%h",
                         O_dataA, O_dataB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_dataA=%h, O_dataB=%h",
                         expected_O_dataA, expected_O_dataB);
                $display("  Got:      O_dataA=%h, O_dataB=%h",
                         O_dataA, O_dataB);
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
        $dumpvars(0,I_clk, I_dataD, I_rst, I_selA, I_selB, I_selD, I_we, O_dataA, O_dataB);
    end

endmodule
