`timescale 1ns/1ps

module RAM16X8D_regs_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [7:0] D;
    reg [3:0] DPRA;
    reg WCLK;
    reg WE;
    wire [7:0] DPO;
    wire [7:0] SPO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RAM16X8D_regs dut (
        .A(A),
        .D(D),
        .DPRA(DPRA),
        .WCLK(WCLK),
        .WE(WE),
        .DPO(DPO),
        .SPO(SPO)
    );

    // Clock generation (10ns period)
    initial begin
        WCLK = 0;
        forever #5 WCLK = ~WCLK;
    end

        task reset_dut;

        begin
            $display("\n--- Resetting RAM Content ---");
            WE = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge WCLK);
                A = i;
                D = 8'h00;
            end
            @(posedge WCLK);
            WE = 0;
            A = 0;
            D = 0;
            DPRA = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Basic Write and Single Address Read");
            reset_dut();
            @(posedge WCLK);
            WE = 1; A = 4'h5; D = 8'hA5;
            @(posedge WCLK);
            WE = 0; DPRA = 4'h5;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Dual Port Read from different addresses");
            reset_dut();

            @(posedge WCLK);
            WE = 1; A = 4'h1; D = 8'h11;

            @(posedge WCLK);
            A = 4'h2; D = 8'h22;
            @(posedge WCLK);
            WE = 0;

            A = 4'h1; DPRA = 4'h2;
            #1;

            check_outputs(8'h22, 8'h11);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Verify WE=0 prevents writing");
            reset_dut();

            @(posedge WCLK);
            WE = 0; A = 4'hA; D = 8'hFF;
            @(posedge WCLK);

            DPRA = 4'hA;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Overwriting an existing address");
            reset_dut();
            @(posedge WCLK);
            WE = 1; A = 4'hC; D = 8'h77;
            @(posedge WCLK);
            D = 8'hBB;
            @(posedge WCLK);
            WE = 0; DPRA = 4'hC;
            #1;

            check_outputs(8'hBB, 8'hBB);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Boundary address test (0 and 15)");
            reset_dut();
            @(posedge WCLK);
            WE = 1; A = 4'h0; D = 8'h01;
            @(posedge WCLK);
            A = 4'hF; D = 8'hFE;
            @(posedge WCLK);
            WE = 0; A = 4'h0; DPRA = 4'hF;
            #1;

            check_outputs(8'hFE, 8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RAM16X8D_regs Testbench");
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
        input [7:0] expected_DPO;
        input [7:0] expected_SPO;
        begin
            if (expected_DPO === (expected_DPO ^ DPO ^ expected_DPO) &&
                expected_SPO === (expected_SPO ^ SPO ^ expected_SPO)) begin
                $display("PASS");
                $display("  Outputs: DPO=%h, SPO=%h",
                         DPO, SPO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DPO=%h, SPO=%h",
                         expected_DPO, expected_SPO);
                $display("  Got:      DPO=%h, SPO=%h",
                         DPO, SPO);
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
        $dumpvars(0,A, D, DPRA, WCLK, WE, DPO, SPO);
    end

endmodule
