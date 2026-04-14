`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg AS20;
    reg CLK;
    reg DS20;
    reg RESET;
    reg RW20;
    reg [1:0] SIZ;
    wire [3:0] CAS;
    wire [1:0] DSACK;
    wire [31:0] D_OUT;
    wire RAMOE;
    wire [1:0] RAS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .AS20(AS20),
        .CLK(CLK),
        .DS20(DS20),
        .RESET(RESET),
        .RW20(RW20),
        .SIZ(SIZ),
        .CAS(CAS),
        .DSACK(DSACK),
        .D_OUT(D_OUT),
        .RAMOE(RAMOE),
        .RAS(RAS)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            AS20 = 1;
            DS20 = 1;
            RW20 = 1;
            A = 32'h0;
            SIZ = 2'b00;
            tb_D_reg = 32'h0;
            @(posedge CLK);
            #2 RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 32'h1000_0000;
            SIZ = 2'b00;
            RW20 = 1;
            tb_D_reg = 32'hDEADBEEF;

            @(posedge CLK);
            AS20 = 0;
            DS20 = 0;


            repeat(3) @(posedge CLK);
            #1;


            #1;



            check_outputs(4'b0000, 2'b00, 32'hDEADBEEF, 1'b0, 2'b00);

            AS20 = 1;
            DS20 = 1;
            @(posedge CLK);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 32'h2000_0000;
            SIZ = 2'b01;
            RW20 = 1;
            tb_D_reg = 32'h11223344;

            @(posedge CLK);
            AS20 = 0;
            DS20 = 0;

            repeat(3) @(posedge CLK);
            #1;



            #1;




            check_outputs(4'b0111, 2'b00, 32'h11223344, 1'b0, 2'b00);

            AS20 = 1;
            DS20 = 1;
            @(posedge CLK);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 32'h3000_0002;
            SIZ = 2'b10;
            RW20 = 1;
            tb_D_reg = 32'hAAAA_BBBB;

            @(posedge CLK);
            AS20 = 0;
            DS20 = 0;

            repeat(3) @(posedge CLK);
            #1;


            #1;



            check_outputs(4'b1100, 2'b00, 32'hAAAA_BBBB, 1'b0, 2'b00);

            AS20 = 1;
            DS20 = 1;
            @(posedge CLK);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 32'h0000_0003;
            SIZ = 2'b01;
            RW20 = 1;
            tb_D_reg = 32'h88776655;

            @(posedge CLK);
            AS20 = 0;
            DS20 = 0;

            repeat(3) @(posedge CLK);
            #1;


            #1;



            check_outputs(4'b1110, 2'b00, 32'h88776655, 1'b0, 2'b00);

            AS20 = 1;
            DS20 = 1;
            @(posedge CLK);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 32'h4000_0000;
            SIZ = 2'b00;
            RW20 = 0;

            @(posedge CLK);
            AS20 = 0;
            DS20 = 0;

            repeat(2) @(posedge CLK);
            #1;



            if (RAMOE === 1'b1) begin
                $display("PASS: Write mode correctly deactivates RAMOE");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Write mode RAMOE active");
                fail_count = fail_count + 1;
            end

            AS20 = 1;
            DS20 = 1;
            @(posedge CLK);
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
        input [3:0] expected_CAS;
        input [1:0] expected_DSACK;
        input [31:0] expected_D_OUT;
        input expected_RAMOE;
        input [1:0] expected_RAS;
        begin
            if (expected_CAS === (expected_CAS ^ CAS ^ expected_CAS) &&
                expected_DSACK === (expected_DSACK ^ DSACK ^ expected_DSACK) &&
                expected_D_OUT === (expected_D_OUT ^ D_OUT ^ expected_D_OUT) &&
                expected_RAMOE === (expected_RAMOE ^ RAMOE ^ expected_RAMOE) &&
                expected_RAS === (expected_RAS ^ RAS ^ expected_RAS)) begin
                $display("PASS");
                $display("  Outputs: CAS=%h, DSACK=%h, D_OUT=%h, RAMOE=%b, RAS=%h",
                         CAS, DSACK, D_OUT, RAMOE, RAS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CAS=%h, DSACK=%h, D_OUT=%h, RAMOE=%b, RAS=%h",
                         expected_CAS, expected_DSACK, expected_D_OUT, expected_RAMOE, expected_RAS);
                $display("  Got:      CAS=%h, DSACK=%h, D_OUT=%h, RAMOE=%b, RAS=%h",
                         CAS, DSACK, D_OUT, RAMOE, RAS);
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
        $dumpvars(0,A, AS20, CLK, DS20, RESET, RW20, SIZ, CAS, DSACK, D_OUT, RAMOE, RAS);
    end

endmodule
