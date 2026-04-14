`timescale 1ns/1ps

module RAM8kx8_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] AB;
    reg CLK;
    reg CS;
    reg [7:0] DI;
    reg READ;
    wire [7:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RAM8kx8 dut (
        .AB(AB),
        .CLK(CLK),
        .CS(CS),
        .DI(DI),
        .READ(READ),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        CS = 0;
        READ = 1;
        AB = 0;
        DI = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Write and Read at address 0x05");
        reset_dut();


        CS = 1;
        READ = 0;
        AB = 13'h0005;
        DI = 8'hAA;
        @(posedge CLK);
        #1;


        READ = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: CS disable check (High-Z)");
        reset_dut();

        CS = 0;
        AB = 13'h0005;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'bzzzz_zzzz);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Overwriting existing memory location");
        reset_dut();


        CS = 1; READ = 0; AB = 13'h0100; DI = 8'h11;
        @(posedge CLK); #1;


        DI = 8'h22;
        @(posedge CLK); #1;


        READ = 1;
        @(posedge CLK); #1;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Boundary address check (8191)");
        reset_dut();

        CS = 1; READ = 0; AB = 13'd8191; DI = 8'hF0;
        @(posedge CLK); #1;

        READ = 1;
        @(posedge CLK); #1;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Multiple address persistence check");
        reset_dut();


        CS = 1; READ = 0; AB = 13'h0010; DI = 8'h33;
        @(posedge CLK); #1;


        AB = 13'h0020; DI = 8'h44;
        @(posedge CLK); #1;


        READ = 1; AB = 13'h0010;
        @(posedge CLK); #1;

        if (DO !== 8'h33) begin
            $display("FAIL: Persistence Addr 0x10 failed");
            fail_count = fail_count + 1;
        end else begin

            AB = 13'h0020;
            @(posedge CLK); #1;
            #1;

            check_outputs(8'h44);
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RAM8kx8 Testbench");
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
        input [7:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,AB, CLK, CS, DI, READ, DO);
    end

endmodule
