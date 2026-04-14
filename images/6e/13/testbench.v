`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg A18;
    reg CLKCPU;
    reg CS;
    reg [7:0] DIN;
    reg DS;
    reg IDE_INT;
    reg RESET;
    reg RW;
    wire [7:0] DOUT;
    wire INT2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .A18(A18),
        .CLKCPU(CLKCPU),
        .CS(CS),
        .DIN(DIN),
        .DS(DS),
        .IDE_INT(IDE_INT),
        .RESET(RESET),
        .RW(RW),
        .DOUT(DOUT),
        .INT2(INT2)
    );

    // Clock generation (10ns period)
    initial begin
        CLKCPU = 0;
        forever #5 CLKCPU = ~CLKCPU;
    end

        task reset_dut;

    begin
        RESET = 0;
        CS = 0;
        DS = 0;
        RW = 1;
        A = 0;
        A18 = 0;
        DIN = 0;
        IDE_INT = 0;
        repeat(5) @(posedge CLKCPU);
        RESET = 1;
        repeat(2) @(posedge CLKCPU);
    end
        endtask
    task bus_write;

        input [18:0] addr;
        input [7:0] data;
        begin
            @(posedge CLKCPU);
            A18 = addr[18];
            A = addr[2:0];
            DIN = data;
            RW = 0;
            CS = 1;
            DS = 1;
            @(posedge CLKCPU);
            CS = 0;
            DS = 0;
        end
        endtask

    task bus_read;

        input [18:0] addr;
        begin
            @(posedge CLKCPU);
            A18 = addr[18];
            A = addr[2:0];
            RW = 1;
            CS = 1;
            DS = 1;
            @(posedge CLKCPU);

        end
        endtask

    task testcase001;

    begin
        $display("Testcase 001: Reset State Check");
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Read Gayle ID Register");
        reset_dut();
        bus_read(19'h40000);

        #1;


        check_outputs(8'hD1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Interrupt Enable and Trigger");
        reset_dut();



        bus_write(19'h40001, 8'h80);


        @(posedge CLKCPU);
        IDE_INT = 1;
        repeat(2) @(posedge CLKCPU);


        #1;



        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Interrupt Masking Check");
        reset_dut();


        bus_write(19'h40001, 8'h00);


        @(posedge CLKCPU);
        IDE_INT = 1;
        repeat(2) @(posedge CLKCPU);


        #1;



        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Read Interrupt Status Register");
        reset_dut();


        IDE_INT = 1;
        repeat(2) @(posedge CLKCPU);


        bus_read(19'h40002);


        #1;



        check_outputs(8'h80, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Write/Read General Register");
        reset_dut();


        bus_write(19'h40003, 8'h5A);
        bus_read(19'h40003);

        #1;


        check_outputs(8'h5A, 1'b0);
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
        input [7:0] expected_DOUT;
        input expected_INT2;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT) &&
                expected_INT2 === (expected_INT2 ^ INT2 ^ expected_INT2)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h, INT2=%b",
                         DOUT, INT2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h, INT2=%b",
                         expected_DOUT, expected_INT2);
                $display("  Got:      DOUT=%h, INT2=%b",
                         DOUT, INT2);
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
        $dumpvars(0,A, A18, CLKCPU, CS, DIN, DS, IDE_INT, RESET, RW, DOUT, INT2);
    end

endmodule
