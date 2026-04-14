`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [4:0] RD;
    reg [4:0] RS1;
    reg [4:0] RS2;
    reg RegWr;
    reg [31:0] WData;
    wire [31:0] RD1;
    wire [31:0] RD2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .RD(RD),
        .RS1(RS1),
        .RS2(RS2),
        .RegWr(RegWr),
        .WData(WData),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            RS1 = 5'd0;
            RS2 = 5'd0;
            RD = 5'd0;
            WData = 32'd0;
            RegWr = 1'b0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Writing to Reg 0 (Hardwired Zero Check)", test_num);


            RD = 5'd0;
            WData = 32'hFFFFFFFF;
            RegWr = 1'b1;
            @(posedge Clk);
            #1;


            RegWr = 1'b0;
            RS1 = 5'd0;
            RS2 = 5'd0;
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Write and Read Register 1", test_num);


            RD = 5'd1;
            WData = 32'h12345678;
            RegWr = 1'b1;
            @(posedge Clk);
            #1;


            RegWr = 1'b0;
            RS1 = 5'd1;
            RS2 = 5'd0;
            #1;

            #1;


            check_outputs(32'h12345678, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: RegWr Enable Check", test_num);


            RD = 5'd5;
            WData = 32'hAAAAAAAA;
            RegWr = 1'b0;
            @(posedge Clk);
            #1;


            RS1 = 5'd5;
            RS2 = 5'd0;
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Dual Port Read (Reg 10 and Reg 20)", test_num);


            RD = 5'd10;
            WData = 32'hAAAA_BBBB;
            RegWr = 1'b1;
            @(posedge Clk);
            #1;


            RD = 5'd20;
            WData = 32'hCCCC_DDDD;
            RegWr = 1'b1;
            @(posedge Clk);
            #1;


            RegWr = 1'b0;
            RS1 = 5'd10;
            RS2 = 5'd20;
            #1;

            #1;


            check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Boundary Register Check (Reg 31)", test_num);


            RD = 5'd31;
            WData = 32'h5555_AAAA;
            RegWr = 1'b1;
            @(posedge Clk);
            #1;


            RegWr = 1'b0;
            RS1 = 5'd31;
            RS2 = 5'd31;
            #1;

            #1;


            check_outputs(32'h5555_AAAA, 32'h5555_AAAA);
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
        input [31:0] expected_RD1;
        input [31:0] expected_RD2;
        begin
            if (expected_RD1 === (expected_RD1 ^ RD1 ^ expected_RD1) &&
                expected_RD2 === (expected_RD2 ^ RD2 ^ expected_RD2)) begin
                $display("PASS");
                $display("  Outputs: RD1=%h, RD2=%h",
                         RD1, RD2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD1=%h, RD2=%h",
                         expected_RD1, expected_RD2);
                $display("  Got:      RD1=%h, RD2=%h",
                         RD1, RD2);
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
        $dumpvars(0,Clk, RD, RS1, RS2, RegWr, WData, RD1, RD2);
    end

endmodule
