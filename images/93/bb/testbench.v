`timescale 1ns/1ps

module reg_file_8x8_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [2:0] RD_ADDR1;
    reg [2:0] RD_ADDR2;
    reg WE;
    reg [2:0] WR_ADDR;
    reg [7:0] WR_DATA;
    wire [7:0] RD_DATA1;
    wire [7:0] RD_DATA2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_8x8 dut (
        .CLK(CLK),
        .RD_ADDR1(RD_ADDR1),
        .RD_ADDR2(RD_ADDR2),
        .WE(WE),
        .WR_ADDR(WR_ADDR),
        .WR_DATA(WR_DATA),
        .RD_DATA1(RD_DATA1),
        .RD_DATA2(RD_DATA2)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            WE = 0;
            WR_ADDR = 0;
            WR_DATA = 0;
            RD_ADDR1 = 0;
            RD_ADDR2 = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Dual Port Read...");
            reset_dut();


            WE = 1;
            WR_ADDR = 3'd0;
            WR_DATA = 8'hAA;
            @(posedge CLK);
            #1;


            WE = 0;
            RD_ADDR1 = 3'd0;
            RD_ADDR2 = 3'd0;
            #1;

            #1;


            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple Register Write/Read...");
            reset_dut();


            WE = 1; WR_ADDR = 3'd2; WR_DATA = 8'h12;
            @(posedge CLK); #1;


            WE = 1; WR_ADDR = 3'd5; WR_DATA = 8'h55;
            @(posedge CLK); #1;

            WE = 0;
            RD_ADDR1 = 3'd2;
            RD_ADDR2 = 3'd5;
            #1;

            #1;


            check_outputs(8'h12, 8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: WE Logic Verification...");
            reset_dut();


            WE = 1; WR_ADDR = 3'd4; WR_DATA = 8'h77;
            @(posedge CLK); #1;


            WE = 0; WR_ADDR = 3'd4; WR_DATA = 8'h99;
            @(posedge CLK); #1;

            RD_ADDR1 = 3'd4;
            RD_ADDR2 = 3'd4;
            #1;


            #1;



            check_outputs(8'h77, 8'h77);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Address Check (0 and 7)...");
            reset_dut();


            WE = 1; WR_ADDR = 3'd0; WR_DATA = 8'h01;
            @(posedge CLK); #1;


            WE = 1; WR_ADDR = 3'd7; WR_DATA = 8'hFE;
            @(posedge CLK); #1;

            RD_ADDR1 = 3'd7;
            RD_ADDR2 = 3'd0;
            #1;

            #1;


            check_outputs(8'hFE, 8'h01);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Successive Writes...");
            reset_dut();

            WE = 1; WR_ADDR = 3'd1; WR_DATA = 8'h11;
            @(posedge CLK); #1;

            WE = 1; WR_ADDR = 3'd1; WR_DATA = 8'h22;
            @(posedge CLK); #1;

            WE = 1; WR_ADDR = 3'd1; WR_DATA = 8'h33;
            @(posedge CLK); #1;

            RD_ADDR1 = 3'd1;
            RD_ADDR2 = 3'd1;
            #1;

            #1;


            check_outputs(8'h33, 8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_8x8 Testbench");
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
        input [7:0] expected_RD_DATA1;
        input [7:0] expected_RD_DATA2;
        begin
            if (expected_RD_DATA1 === (expected_RD_DATA1 ^ RD_DATA1 ^ expected_RD_DATA1) &&
                expected_RD_DATA2 === (expected_RD_DATA2 ^ RD_DATA2 ^ expected_RD_DATA2)) begin
                $display("PASS");
                $display("  Outputs: RD_DATA1=%h, RD_DATA2=%h",
                         RD_DATA1, RD_DATA2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD_DATA1=%h, RD_DATA2=%h",
                         expected_RD_DATA1, expected_RD_DATA2);
                $display("  Got:      RD_DATA1=%h, RD_DATA2=%h",
                         RD_DATA1, RD_DATA2);
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
        $dumpvars(0,CLK, RD_ADDR1, RD_ADDR2, WE, WR_ADDR, WR_DATA, RD_DATA1, RD_DATA2);
    end

endmodule
