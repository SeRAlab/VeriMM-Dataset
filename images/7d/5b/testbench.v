`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address1;
    reg [4:0] address2;
    reg [4:0] address3;
    reg clk;
    reg we;
    reg [31:0] wr;
    wire [31:0] rs1;
    wire [31:0] rs2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address1(address1),
        .address2(address2),
        .address3(address3),
        .clk(clk),
        .we(we),
        .wr(wr),
        .rs1(rs1),
        .rs2(rs2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address1 = 0;
            address2 = 0;
            address3 = 0;
            we = 0;
            wr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Register 0 is hardwired to 0", test_num);
            reset_dut();


            address3 = 5'd0;
            wr = 32'hFFFFFFFF;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            address1 = 5'd0;
            address2 = 5'd0;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Reg 1)", test_num);
            reset_dut();


            address3 = 5'd1;
            wr = 32'hABCD1234;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            address1 = 5'd1;
            address2 = 5'd1;
            #1;
            #1;

            check_outputs(32'hABCD1234, 32'hABCD1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable (WE=0)", test_num);
            reset_dut();


            address3 = 5'd5;
            wr = 32'h5555AAAA;
            we = 0;
            @(posedge clk);
            #1;


            address1 = 5'd5;
            address2 = 5'd5;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Port Read (Reg 10 and Reg 20)", test_num);
            reset_dut();


            address3 = 5'd10;
            wr = 32'h10101010;
            we = 1;
            @(posedge clk);
            #1;


            address3 = 5'd20;
            wr = 32'h20202020;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            address1 = 5'd10;
            address2 = 5'd20;
            #1;
            #1;

            check_outputs(32'h10101010, 32'h20202020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Register 31", test_num);
            reset_dut();

            address3 = 5'd31;
            wr = 32'hDEADBEEF;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;

            address1 = 5'd31;
            address2 = 5'd0;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
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
        input [31:0] expected_rs1;
        input [31:0] expected_rs2;
        begin
            if (expected_rs1 === (expected_rs1 ^ rs1 ^ expected_rs1) &&
                expected_rs2 === (expected_rs2 ^ rs2 ^ expected_rs2)) begin
                $display("PASS");
                $display("  Outputs: rs1=%h, rs2=%h",
                         rs1, rs2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rs1=%h, rs2=%h",
                         expected_rs1, expected_rs2);
                $display("  Got:      rs1=%h, rs2=%h",
                         rs1, rs2);
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
        $dumpvars(0,address1, address2, address3, clk, we, wr, rs1, rs2);
    end

endmodule
