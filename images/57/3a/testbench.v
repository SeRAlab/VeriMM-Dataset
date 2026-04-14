`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [15:0] DATA_IN;
    reg [1:0] RD_ADDR1;
    reg [1:0] RD_ADDR2;
    reg RST;
    reg [1:0] WR_ADDR;
    reg WR_EN;
    wire [15:0] DATA_OUT1;
    wire [15:0] DATA_OUT2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .RD_ADDR1(RD_ADDR1),
        .RD_ADDR2(RD_ADDR2),
        .RST(RST),
        .WR_ADDR(WR_ADDR),
        .WR_EN(WR_EN),
        .DATA_OUT1(DATA_OUT1),
        .DATA_OUT2(DATA_OUT2)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            WR_EN = 0;
            WR_ADDR = 0;
            RD_ADDR1 = 0;
            RD_ADDR2 = 0;
            DATA_IN = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset state check", test_num);
            reset_dut();


            RD_ADDR1 = 2'b00;
            RD_ADDR2 = 2'b01;
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Basic Write and Read (Register 2)", test_num);
            reset_dut();


            WR_EN = 1;
            WR_ADDR = 2'b10;
            DATA_IN = 16'hABCD;
            @(posedge CLK);


            #1;
            WR_EN = 0;
            RD_ADDR1 = 2'b10;
            RD_ADDR2 = 2'b00;
            #1;
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Simultaneous Dual-Read (Registers 1 and 3)", test_num);
            reset_dut();


            WR_EN = 1;
            WR_ADDR = 2'b01;
            DATA_IN = 16'h1111;
            @(posedge CLK);


            WR_ADDR = 2'b11;
            DATA_IN = 16'h3333;
            @(posedge CLK);


            #1;
            WR_EN = 0;
            RD_ADDR1 = 2'b01;
            RD_ADDR2 = 2'b11;
            #1;
            #1;

            check_outputs(16'h1111, 16'h3333);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Write Enable (WR_EN) Logic Check", test_num);
            reset_dut();


            WR_EN = 1;
            WR_ADDR = 2'b00;
            DATA_IN = 16'h5555;
            @(posedge CLK);


            WR_EN = 0;
            WR_ADDR = 2'b00;
            DATA_IN = 16'hFFFF;
            @(posedge CLK);


            #1;
            RD_ADDR1 = 2'b00;
            RD_ADDR2 = 2'b01;
            #1;
            #1;

            check_outputs(16'h5555, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Overwrite Register Data", test_num);
            reset_dut();


            WR_EN = 1;
            WR_ADDR = 2'b11;
            DATA_IN = 16'hAAAA;
            @(posedge CLK);


            DATA_IN = 16'hBBBB;
            @(posedge CLK);


            #1;
            WR_EN = 0;
            RD_ADDR1 = 2'b11;
            RD_ADDR2 = 2'b11;
            #1;
            #1;

            check_outputs(16'hBBBB, 16'hBBBB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Combinational Read Address Switching", test_num);
            reset_dut();


            WR_EN = 1;
            WR_ADDR = 2'b00; DATA_IN = 16'h0001; @(posedge CLK);
            WR_ADDR = 2'b01; DATA_IN = 16'h0002; @(posedge CLK);


            #1; WR_EN = 0; RD_ADDR1 = 2'b00; RD_ADDR2 = 2'b01; #1;


            RD_ADDR1 = 2'b01;
            RD_ADDR2 = 2'b00;
            #1;
            #1;

            check_outputs(16'h0002, 16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file Testbench");
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
        input [15:0] expected_DATA_OUT1;
        input [15:0] expected_DATA_OUT2;
        begin
            if (expected_DATA_OUT1 === (expected_DATA_OUT1 ^ DATA_OUT1 ^ expected_DATA_OUT1) &&
                expected_DATA_OUT2 === (expected_DATA_OUT2 ^ DATA_OUT2 ^ expected_DATA_OUT2)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT1=%h, DATA_OUT2=%h",
                         DATA_OUT1, DATA_OUT2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT1=%h, DATA_OUT2=%h",
                         expected_DATA_OUT1, expected_DATA_OUT2);
                $display("  Got:      DATA_OUT1=%h, DATA_OUT2=%h",
                         DATA_OUT1, DATA_OUT2);
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
        $dumpvars(0,CLK, DATA_IN, RD_ADDR1, RD_ADDR2, RST, WR_ADDR, WR_EN, DATA_OUT1, DATA_OUT2);
    end

endmodule
